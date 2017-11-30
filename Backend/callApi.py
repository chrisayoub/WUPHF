from twilio.rest import Client
from twilio.twiml.voice_response import VoiceResponse
import uuid
import boto3
import os
import time

# Your Account SID from twilio.com/console
account_sid = "ACbc7cd7e6450d6d882a3d2161c0c2c676"
# Your Auth Token from twilio.com/console
auth_token  = "3feefb15b80ad8bbcf285ff464691835"
# Phone number we send from
from_number = '+15126451842'

bark = 'https://wuphf-for-ios.s3.amazonaws.com/bark.mp3'

# S3 bucket
bucket = 'wuphf-for-ios'

def makeCall(msg, senderName, destNumber):
	# Delay this thread
	time.sleep(8)
	# Create the XML from the message
	resp = VoiceResponse()
	resp.say("Hello! This is an automated call from Woof!")
	resp.play(bark)
	resp.pause(length=1)
	resp.say("This message is sent from: " + senderName + ".")
	resp.pause(length=1)
	resp.say("Here is their message: .")
	resp.pause(length=1)
	resp.say(msg)
	resp.pause(length=1)
	resp.say("This call was powered by Woof!")
	resp.play(bark)
	resp.say("Goodbye")
	xml = str(resp)

	# Write to file
	fileName = str(uuid.uuid4()) + ".xml"
	file = open(fileName, "w")
	file.write(xml)
	file.flush()
	os.fsync(file.fileno())

	# Upload file to S3
	s3 = boto3.client('s3')
	s3.upload_file(fileName, bucket, fileName, 
					ExtraArgs={'ContentType': "text/xml", 'ACL': "public-read"})
	file.close()
	os.remove(fileName)
	url = 'http://18.216.122.103/s3?url=https://' + bucket + '.s3.amazonaws.com/' + fileName

	# Set up a client to talk to the Twilio REST API
	client = Client(account_sid, auth_token)
	
	# Make the phone call
	call = client.calls.create(to=destNumber,    # to your cell phone
							   from_=from_number, # from your Twilio phone number
	 						   url=url)


