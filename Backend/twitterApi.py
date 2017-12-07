import tweepy
from db import User, TwitterAccount

consumer_key = 'dE7W4G2gjrFS16oyDatS1Ujhh'
consumer_secret = 'jNS8daivgRdIjBFSCzkUvU9DotUz4SdhOxwGcDdrGOoZtEILnT'

def sendTwitter(senderAccount, targetAccount, msg):
	# Get values
	oauth_token = senderAccount.oauth_token
	oauth_token_secret = senderAccount.oauth_token_secret
	
	# Send message
	auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
	auth.set_access_token(oauth_token, oauth_token_secret)
	api = tweepy.API(auth)
	api.send_direct_message(user_id=targetAccount.twitterId, text=msg)
