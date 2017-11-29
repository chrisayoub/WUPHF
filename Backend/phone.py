from twilio.rest import Client
from twilio.twiml.voice_response import VoiceResponse

# Your Account SID from twilio.com/console
account_sid = "ACbc7cd7e6450d6d882a3d2161c0c2c676"
# Your Auth Token from twilio.com/console
auth_token  = "3feefb15b80ad8bbcf285ff464691835"
# Phone number we send from
from_number = '+15126451842'

def sendSms(msg, destNumber):
	client = Client(account_sid, auth_token)
	client.messages.create(
	    to=destNumber, 
	    from_=from_number,
	    body=msg)

