import tweepy
from db import User, TwitterAccount

consumer_key = 'dE7W4G2gjrFS16oyDatS1Ujhh'
consumer_secret = 'jNS8daivgRdIjBFSCzkUvU9DotUz4SdhOxwGcDdrGOoZtEILnT'

def sendMessage(msg, senderUser, targetUser):
	if sender.TwitterAccount == None:
		return
	if target.TwitterAccount == None:
		return
	# Get values
	targetId = target.TwitterAccount.twitterId
	oauth_token = sender.TwitterAccount.oauth_token
	oauth_token_secret = sender.TwitterAccount.oauth_token_secret
	# Send message
	auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
	auth.set_access_token(oauth_token, oauth_token_secret)
	api = tweepy.API(auth)
	api.send_direct_message(user_id=targetId, text=msg)

####### Test code

# auth = tweepy.OAuthHandler(consumer_key, consumer_secret)

# redirect_url = auth.get_authorization_url()
# print (redirect_url)

# verifier = input('Verifier:')

# auth.get_access_token(verifier)

# print (auth.access_token)
# print (auth.access_token_secret)

# api = tweepy.API(auth)

# api.send_direct_message(user_id=19638927, text='This is a test message')
