from twilio.rest import Client
from twilio.twiml.voice_response import VoiceResponse

# Your Account SID from twilio.com/console
account_sid = ""
# Your Auth Token from twilio.com/console
auth_token  = ""
# Phone number we send from
from_number = ''

def sendSms(msg, destNumber):
	client = Client(account_sid, auth_token)
	client.messages.create(
	    to=destNumber, 
	    from_=from_number,
	    body=msg)

