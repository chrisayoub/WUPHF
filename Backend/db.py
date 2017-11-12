from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, String, Text, Table, Float, Boolean, TIMESTAMP
from sqlalchemy.dialects.mysql import DOUBLE

# Configure this line for database connection
engine = create_engine('mysql+mysqlconnector://root:root@localhost/wuphf', pool_recycle=3600) #, echo=True)
Session = sessionmaker(bind=engine)
Base = declarative_base()

# Allows serializable classes
class JsonifyClass():
	def as_dict(self):
			return {c.name: getattr(self, c.name) for c in self.__table__.columns}

# Many-to-Many relationships

pack_membership = Table('pack membership', Base.metadata,
	Column('packId', Integer, ForeignKey('pack.id')),
	Column('userId', Integer, ForeignKey('user.id'))
)

friendship = Table('friendships', Base.metadata,
    Column('friend_one', Integer, ForeignKey('user.id')),
    Column('friend_two', Integer, ForeignKey('user.id'))
)

requests = Table('requests', Base.metadata,
	Column('id', Integer, primary_key=True),
    Column('requester', Integer, ForeignKey('user.id')),
    Column('accepter', Integer, ForeignKey('user.id'))
)

# User

class User(Base, JsonifyClass):
	__tablename__ = 'user'
	id = Column(Integer, primary_key=True)
	email = Column(String(255))
	firstName = Column(String(255))
	lastName = Column(String(255))
	fullName = Column(Text)
	phoneNumber = Column(String(255))
	enableSMS = Column(Boolean)
	facebookAccount = relationship("FacebookAccount", uselist=False, backref="user")
	twitterAccount = relationship("TwitterAccount", uselist=False, backref="user")
	friends = relationship("User", secondary=friendship, 
                           primaryjoin=id==friendship.c.friend_one,
                           secondaryjoin=id==friendship.c.friend_two)
	requestsSent = relationship("User", secondary=requests, 
                      			 primaryjoin=id==requests.c.requester,
                       			 secondaryjoin=id==requests.c.accepter)
	requestsRecieved = relationship("User", secondary=requests, 
                      			    primaryjoin=id==requests.c.accepter,
                       			    secondaryjoin=id==requests.c.requester)

# Pack

class Pack(Base, JsonifyClass):
	__tablename__ = 'pack'
	id = Column(Integer, primary_key=True)
	name = Column(String(255))
	image = Column(Text)
	members = relationship("User",
						secondary=pack_membership,
						backref="packs")

# Accounts

class FacebookAccount(Base, JsonifyClass):
	__tablename__ = 'facebook'
	id = Column(Integer, primary_key=True)
	userId = Column(Integer, ForeignKey('user.id'))
	fbId = Column(Text)
	token = Column(Text)

class TwitterAccount(Base, JsonifyClass):
	__tablename__ = 'twitter'
	id = Column(Integer, primary_key=True)
	userId = Column(Integer, ForeignKey('user.id'))
	twitterId = Column(Integer)
	oauth_token = Column(Text)
	oauth_token_secret = Column(Text)

# WUPHF and Bark

class Message(Base, JsonifyClass):
	__tablename__ = 'message'
	id = Column(Integer, primary_key=True)
	senderId = Column(Integer, ForeignKey('user.id'))
	targetId = Column(Integer, ForeignKey('user.id'))
	message = Column(Text)
	time = Column(TIMESTAMP)

class Bark(Base, JsonifyClass):
	__tablename__ = 'bark'
	id = Column(Integer, primary_key=True)
	senderId = Column(Integer, ForeignKey('user.id'))
	targetPack = Column(Integer, ForeignKey('pack.id'))
	message = Column(Text)
	time = Column(TIMESTAMP)
	isResolved = Column(Boolean)
	latitude = Column(DOUBLE)
	longitude = Column(DOUBLE)
	
# Used as singleton for database access

class DB():
	session = Session()
	Base.metadata.create_all(engine)

##### Test code

# def test():
# 	database = DB()
# 	session = database.session
# 	ed_user = User(email='ed@email.com', firstName='Ed', lastName='Jones', phoneNumber='555-852-4953')
# 	ed_user.email = 'new@email.com'
# 	session.add(ed_user)
# 	for instance in session.query(User).order_by(User.id):
# 		print(instance.email, instance.phoneNumber)
# 	session.commit()

# test()
