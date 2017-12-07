from db import DB, User, Pack, FacebookAccount, TwitterAccount, Message, Bark
from sqlalchemy import or_
from flask import Flask, request
from flask import make_response
from flask_restful import Resource, Api
from phone import sendSms
from emailApi import sendEmail
from facebookApi import makeWallPost
from twitterApi import sendTwitter
from callApi import makeCall
import json
from threading import Thread
import urllib.request

app = Flask("WUPHF")
api = Api(app)

database = DB()
session = database.session

# User

class NewUser(Resource):
	def post(self):
		email = request.form['email']
		firstName = request.form['firstName']
		lastName = request.form['lastName']
		fullName = firstName + ' ' + lastName
		# Add to DB
		user = User(email=email, firstName=firstName, lastName=lastName, fullName=fullName, phoneNumber='', enableSMS=False)
		session.add(user)
		session.commit()
		return {'id' : user.id}

class GetUser(Resource):
	def get(self):
		id = request.args['id']
		users = session.query(User).filter_by(id=id).all()
		if len(users) == 0:
			return {'success' : False}, 422
		return getUserFullProperties(users[0])

class GetUserByEmail(Resource):
	def get(self):
		email = request.args['email']
		users = session.query(User).filter_by(email=email).all()
		if len(users) == 0:
			return {'success' : False}, 422
		return getUserFullProperties(users[0])

def getUserFullProperties(user):
	result = user.as_dict()

	if user.facebookAccount == None:
			result['facebookLinked'] = False
	else:
		result['facebookLinked'] = True

	if user.twitterAccount == None:
		result['twitterLinked'] = False
	else:
		result['twitterLinked'] = True

	return result

def usersToJson(users):
	result = '['
	for user in users:
		result += str(json.dumps(getUserFullProperties(user))) + ','
	if len(users) > 0:
		result = result[:-1]
	result += ']'
	return json.loads(result)

class UpdateUser(Resource):
	def post(self):
		id = request.form['id']
		email = request.form['email']
		firstName = request.form['firstName']
		lastName = request.form['lastName']
		# Modify DB entry
		users = session.query(User).filter_by(id=id).all()
		if len(users) == 0:
			return {'success' : False}, 422
		user = users[0]
		user.email = email
		user.firstName = firstName
		user.lastName = lastName
		user.fullName = firstName + ' ' + lastName
		session.commit()
		return {'success' : True}

class SearchUsers(Resource):
	def get(self):
		query = request.args['query']
		userId = request.args['id']

		users = session.query(User).filter_by(id=userId).all()
		if len(users) == 0:
			return {'success' : False}, 422
		searcher = users[0]

		queryLike = '%' + query + '%'
		if query == '':
			return usersToJson([])
		# Full name or email like the query
		userList = session.query(User).filter(or_(User.fullName.like(queryLike), User.email.like(queryLike))).all()
		if searcher in userList:
			userList.remove(searcher)
		# Format return value
		result = '['
		for user in userList:
			if user in searcher.requestsRecieved:
				continue
			if user in searcher.friends:
				continue
			userDict = getUserFullProperties(user)
			# Add if we requested or not
			userDict['requested'] = user in searcher.requestsSent
			result += str(json.dumps(userDict)) + ','
		# In case empty
		if len(userList) > 0:
			result = result[:-1]
		result += ']'
		return json.loads(result)

api.add_resource(NewUser, '/user/new')
api.add_resource(GetUser, '/user/get')
api.add_resource(UpdateUser, '/user/update')
api.add_resource(SearchUsers, '/user/search')
api.add_resource(GetUserByEmail, '/user/get/byEmail')

# Friends

class SendFriendRequest(Resource):
	def post(self):
		# Send friend request to user with ID from user with ID
		senderId = request.form['senderId']
		requestId = request.form['requestId']

		senderList = session.query(User).filter_by(id=senderId).all()
		requestedList = session.query(User).filter_by(id=requestId).all()
		if len(senderList) != 1 or len(requestedList) != 1:
			return {'success' : False}, 422

		sender = senderList[0]
		requested = requestedList[0]
		sender.requestsSent.append(requested)
		session.commit()
		return {'success' : True}

class GetFriendRequests(Resource):
	def get(self):
		# Get friend requests for user with given ID
		id = request.args['id']
		users = session.query(User).filter_by(id=id).all()
		if len(users) != 1:
			return []
		return usersToJson(users[0].requestsRecieved)

class AcceptFriendRequest(Resource):
	def post(self):
		# Accept friend request sent to user with ID from user with ID
		senderId = request.form['senderId']
		requestId = request.form['requestId']

		senderList = session.query(User).filter_by(id=senderId).all()
		requestedList = session.query(User).filter_by(id=requestId).all()
		if len(senderList) != 1 or len(requestedList) != 1:
			return {'success' : False}, 422

		sender = senderList[0]
		requested = requestedList[0]

		sender.requestsSent.remove(requested)
		sender.friends.append(requested)
		requested.friends.append(sender)
		session.commit()
		return {'success' : True}

class DeclineFriendRequest(Resource):
	def post(self):
		# Decline friend request sent to user with ID from user with ID
		senderId = request.form['senderId']
		requestId = request.form['requestId']

		senderList = session.query(User).filter_by(id=senderId).all()
		requestedList = session.query(User).filter_by(id=requestId).all()
		if len(senderList) != 1 or len(requestedList) != 1:
			return {'success' : False}, 422

		sender = senderList[0]
		requested = requestedList[0]

		sender.requestsSent.remove(requested)
		session.commit()
		return {'success' : True}

class GetFriends(Resource):
	def get(self):
		# Get friends for user with given ID
		id = request.args['id']
		users = session.query(User).filter_by(id=id).all()
		if len(users) != 1:
			return []
		return usersToJson(users[0].friends)

class RemoveFriend(Resource):
	def post(self):
		# Delete friend with ID from user with ID
		userId = request.form['userId']
		friendId = request.form['friendId']

		userList = session.query(User).filter_by(id=userId).all()
		friendList = session.query(User).filter_by(id=friendId).all()
		if len(userList) != 1 or len(friendList) != 1:
			return {'success' : False}, 422

		user = userList[0]
		friend = friendList[0]

		user.friends.remove(friend)
		friend.friends.remove(user)
		session.commit()
		return {'success' : True}

api.add_resource(SendFriendRequest, '/friend/request/send')
api.add_resource(GetFriendRequests, '/friend/request/get')
api.add_resource(AcceptFriendRequest, '/friend/request/accept')
api.add_resource(DeclineFriendRequest, '/friend/request/decline')
api.add_resource(GetFriends, '/friend/get')
api.add_resource(RemoveFriend, '/friend/remove')

# Facebook Accounts

class LinkFacebookAccount(Resource):
	def post(self):
		# Link FB account for given user ID
		id = request.form['id']
		fbId = request.form['fbId']
		token = request.form['token']
		users = session.query(User).filter_by(id=id).all()
		if len(users) == 0:
			return {'success' : False}, 422
		user = users[0]
		fb = FacebookAccount(userId=id, fbId=fbId, token=token)
		session.add(fb)
		session.commit()
		return {'success' : True}

class UnlinkFacebookAccount(Resource):
	def post(self):
		# Unlink FB account for given user ID
		id = request.form['id']
		users = session.query(User).filter_by(id=id).all()
		if len(users) == 0:
			return {'success' : False}, 422
		user = users[0]
		fb = user.facebookAccount
		if fb == None:
			return {'success' : False}, 422
		session.delete(fb)
		session.commit()
		return {'success' : True}

api.add_resource(LinkFacebookAccount, '/facebook/link')
api.add_resource(UnlinkFacebookAccount, '/facebook/unlink')		

# Twitter Accounts

class LinkTwitterAccount(Resource):
	def post(self):
		# Link TW account for given user ID
		id = request.form['id']
		twId = request.form['twId']
		oauth = request.form['oauth']
		secret = request.form['secret']
		users = session.query(User).filter_by(id=id).all()
		if len(users) == 0:
			return {'success' : False}, 422
		user = users[0]
		tw = TwitterAccount(userId=id, twitterId=twId, oauth_token=oauth, oauth_token_secret=secret)
		session.add(tw)
		session.commit()
		return {'success' : True}

class UnlinkTwitterAccount(Resource):
	def post(self):
		# Unlink TW account for given user ID
		id = request.form['id']
		users = session.query(User).filter_by(id=id).all()
		if len(users) == 0:
			return {'success' : False}, 422
		user = users[0]
		tw = user.twitterAccount
		if tw == None:
			return {'success' : False}, 422
		session.delete(tw)
		session.commit()
		return {'success' : True}

api.add_resource(LinkTwitterAccount, '/twitter/link')
api.add_resource(UnlinkTwitterAccount, '/twitter/unlink')

# SMS

class LinkSMS(Resource):
	def post(self):
		# Link SMS for given user ID and given phone number
		id = request.form['id']
		phone = request.form['phone']
		users = session.query(User).filter_by(id=id).all()
		if len(users) == 0:
			return {'success' : False}, 422
		user = users[0]
		user.enableSMS = True
		user.phoneNumber = phone
		session.commit()
		return {'success' : True}

class UnlinkSMS(Resource):
	def post(self):
		# Unlink SMS for given user ID
		id = request.form['id']
		users = session.query(User).filter_by(id=id).all()
		if len(users) == 0:
			return {'success' : False}, 422
		user = users[0]
		user.enableSMS = False
		user.phoneNumber = ''
		session.commit()
		return {'success' : True}

api.add_resource(LinkSMS, '/sms/link')
api.add_resource(UnlinkSMS, '/sms/unlink')

# WUPHF and Bark

class WUPHF(Resource):
	def post(self):
		# Send a WUPHF to the given user from given user ID
		userId = request.form['userId']
		friendId = request.form['friendId']
		msg = request.form['message']

		userList = session.query(User).filter_by(id=userId).all()
		friendList = session.query(User).filter_by(id=friendId).all()
		if len(userList) != 1 or len(friendList) != 1:
			return {'success' : False}, 422

		user = userList[0]
		friend = friendList[0]

		# Get senderName and message
		senderName = user.fullName
		text = wrapWUPHF(msg=msg, senderName=senderName)

		# Send an email

		# wuphfios@gmail.com
		# wuphfforios
		subject = 'WUPHF from ' + senderName
		try:
			emailThread = Thread(target = sendEmail, args = (text, friend.email, subject))
			emailThread.start()
		except:
			print('Could not email')

		# Send SMS
		if friend.enableSMS:
			try:
				smsThread = Thread(target = sendSms, args = (text, friend.phoneNumber))
				smsThread.start()
			except:
				print('Could not SMS')
			try:
				callThread = Thread(target = makeCall, args = (msg, senderName, friend.phoneNumber))
				callThread.start()
			except:
				print('Could not call')

		# Send Facebook
		if user.facebookAccount != None and friend.facebookAccount != None:
			try:
				fbThread = Thread(target = makeWallPost, args = (user.facebookAccount, friend.facebookAccount, text))
				fbThread.start()
			except:
				print('Could not Facebook')

		# Send Twitter
		if user.twitterAccount != None and friend.twitterAccount != None:
			try:
				twThread = Thread(target = sendTwitter, args = (user.twitterAccount, friend.twitterAccount, text))
				twThread.start()
			except:
				print('Could not Twitter')

		return {'success' : True}

	def get(self):
		# Get info about a specific WUPHF
		return ''

api.add_resource(WUPHF, '/wuphf')

class S3(Resource):
	def post(self):
		url = request.args['url']
		text = urllib.request.urlopen(url).read().decode('utf-8')
		response = make_response(str(text))
		response.headers['Content-Type'] = 'application/xml'
		return response

api.add_resource(S3, "/s3")

# Generate messages from user message

def wrapWUPHF(msg, senderName):
	return 'Message from ' + senderName + ':\n' + msg + ' -- Powered by WUPHF'

def wrapBark(msg, senderName, location):
	mapUrl = 'http://maps.google.com/?ll='
	mapUrl += latitude + ','
	mapUrl =+ longitude

	result =  'Urgent message from ' + senderName + ':\n'
	result += msg
	result += " -- Sent from location " + mapUrl
	result += " -- Powered by WUPHF"
	return result

if __name__ == '__main__':
	app.run(debug=True, host='0.0.0.0', port=80)
