from db import FacebookAccount
import json
import requests

def makeWallPost(account, targetAccount, msg):
	payload =  {'privacy' : '{\'value\': \'SELF\'}', 
				'message' : msg, 'tags' : str(targetAccount.fbId)}
	r = requests.post("https://graph.facebook.com/v2.11/me/feed?access_token=" + account.token, 
		data=payload)
