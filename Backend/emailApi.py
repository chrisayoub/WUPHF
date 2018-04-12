import smtplib

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

MY_ADDRESS = ''
PASSWORD = ''

# https://medium.freecodecamp.org/send-emails-using-code-4fcea9df63f
def sendEmail(text, targetEmail, subject):
    # set up the SMTP server
    s = smtplib.SMTP(host='smtp.gmail.com', port=587)
    s.starttls()
    s.login(MY_ADDRESS, PASSWORD)

    msg = MIMEMultipart()       # create a message

    # setup the parameters of the message
    msg['From']='WUPHF for iOS'
    msg['To']=targetEmail
    msg['Subject']=subject
    
    # add in the message body
    msg.attach(MIMEText(text, 'plain'))
    
    # send the message via the server set up earlier.
    s.send_message(msg)
    del msg
        
    # Terminate the SMTP session and close the connection
    s.quit()

