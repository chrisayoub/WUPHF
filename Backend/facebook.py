import facebook
from db import FacebookAccount

def makeWallPost(account, targetAccount, msg):
	graph = facebook.GraphAPI(access_token=account.token, version="2.10")
	graph.put_object(parent_object='me', connection_name='feed',
                  message=msg, privacy=json.dumps(
							        {'value' : 'CUSTOM', 'allow' : targetUser.fbId}))
