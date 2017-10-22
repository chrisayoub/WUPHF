from db import DB, User, Pack, FacebookAccount, TwitterAccount, Message, Bark
from flask import Flask, request
from flask_restful import Resource, Api

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
		phone = request.form['phone']
		enableSMS = request.form['enableSMS'] == 'true'
		# Add to DB
		user = User(email=email, firstName=firstName, lastName=lastName, phoneNumber=phone, enableSMS=enableSMS)
		session.add(user)
		session.commit()
		return {'id' : user.id}

class GetUser(Resource):
	def get(self):
		id = request.args['id']
		user = session.query(User).filter_by(id=id).all()[0]
		return user.as_dict()

class UpdateUser(Resource):
	def post(self):
		id = request.form['id']
		email = request.form['email']
		firstName = request.form['firstName']
		lastName = request.form['lastName']
		phone = request.form['phone']
		enableSMS = request.form['enableSMS'] == 'true'
		# Modify DB entry
		user = session.query(User).filter_by(id=id).all()[0]
		user.email = email
		user.firstName = firstName
		user.lastName = lastName
		user.phoneNumber = phone
		user.enableSMS = enableSMS
		session.commit()
		return user.as_dict()

class SearchUsers(Resource):
	def get(self):
		# Search for users given the search query
		# Return array of users
		return ''

api.add_resource(NewUser, '/user/new')
api.add_resource(GetUser, '/user/get')
api.add_resource(UpdateUser, '/user/update')
api.add_resource(SearchUsers, '/user/search')

# Friends

class SendFriendRequest(Resource):
	def post(self):
		# Send friend request to user with ID from user with ID
		return ''

class GetFriendRequests(Resource):
	def get(self):
		# Get friend requests for user with given ID
		return ''

class AcceptFriendRequest(Resource):
	def post(self):
		# Accept friend request with given request ID
		return ''

class DeclineFriendRequest(Resource):
	def post(self):
		# Decline friend request with given request ID
		return ''

class GetFriends(Resource):
	def get(self):
		# Get friends for user with given ID
		return ''

class RemoveFriend(Resource):
	def post(self):
		# Delete friend with ID from user with ID
		return ''

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
		# Need FB account username and PW
		return ''

class UnlinkFacebookAccount(Resource):
	def post(self):
		# Unlink FB account for given user ID
		return ''

api.add_resource(LinkFacebookAccount, '/facebook/link')
api.add_resource(UnlinkFacebookAccount, '/facebook/unlink')		

# Twitter Accounts

class LinkTwitterAccount(Resource):
	def post(self):
		# Link TW account for given user ID
		# Need oauth_token and oauth_token_secret
		return ''

class UnlinkTwitterAccount(Resource):
	def post(self):
		# Unlink TW account for given user ID
		return ''

api.add_resource(LinkTwitterAccount, '/twitter/link')
api.add_resource(UnlinkTwitterAccount, '/twitter/unlink')

# WUPHF and Bark

class WUPHF(Resource):
	def post(self):
		# Send a WUPHF to the given user

		return ''

	def get(self):
		# Get info about a specific WUPHF
		return ''

class Bark(Resource):
	def post(self):
		# Send a bark to the given pack
		return ''

	def get(self):
		# Get info about a specific Bark
		return ''

api.add_resource(WUPHF, '/wuphf')
api.add_resource(Bark, '/bark')

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

# Feed

class Feed(Resource):
	def get(self):
		# Get 20 feed events for given user ID
		id = request.form['id']
		return ''

api.add_resource(Feed, '/feed')

# Pack

class GetPacks(Resource):
	def get(self):
		# Get packs for user with given ID
		return ''

class CreatePack(Resource):
	def post(self):
		return ''

class UpdatePack(Resource):
	def post(self):
		return ''

class DeletePack(Resource):
	def post(self):
		return ''

class GetPackInfo(Resource):
	def get(self):
		return ''

class AddMemberToPack(Resource):
	def post(self):
		return ''

class RemoveMemberFromPack(Resource):
	def post(self):
		return ''

api.add_resource(GetPacks, '/pack/get')
api.add_resource(CreatePack, '/pack/create')
api.add_resource(UpdatePack, '/pack/update')
api.add_resource(DeletePack, '/pack/delete')
api.add_resource(GetPackInfo, '/pack/info')
api.add_resource(AddMemberToPack, '/pack/addMember')
api.add_resource(RemoveMemberFromPack, '/pack/removeMember')

if __name__ == '__main__':
    app.run(debug=True)