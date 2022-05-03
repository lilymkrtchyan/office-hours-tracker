
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.types import Boolean, String
import datetime
import hashlib
import os
import bcrypt

db = SQLAlchemy()

#association tables

student_association_table = db.Table(
    "student_association",
    db.Column("course_id", db.Integer, db.ForeignKey("courses.id")),
    db.Column("user_id", db.Integer, db.ForeignKey("users.id"))
)

ta_association_table = db.Table(
    "ta_association",
    db.Column("course_id", db.Integer, db.ForeignKey("courses.id")),
    db.Column("user_id", db.Integer, db.ForeignKey("users.id"))
)

# database model classes
#----USER MODEL-----------------------------------------

class User(db.Model):
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    name = db.Column(db.String, nullable = False)
    netid = db.Column(db.String, nullable = False)
    is_ta = db.Column(db.Boolean, nullable = False) #true is the user is a ta, false otherwise
   
    #relationships:
    student_courses = db.relationship("Course", secondary= student_association_table, back_populates="students")
    ta_courses = db.relationship("Course", secondary= ta_association_table, back_populates="tas")
    office_hours = db.relationship("OfficeHours", cascade="delete")

    # User information
    email = db.Column(db.String, nullable=False, unique=True)
    password_digest = db.Column(db.String, nullable=False)

    # Session information. Here there is only one session
    session_token = db.Column(db.String, nullable=False, unique=True)
    session_expiration = db.Column(db.DateTime, nullable=False)
    update_token = db.Column(db.String, nullable=False, unique=True)

    def __init__(self, **kwargs): 
        """
        initalize user object/entry
        """
        self.name = kwargs.get("name", "")
        self.netid = kwargs.get("netid", "")
        self.is_ta = kwargs.get("is_ta", False)    #by default a user is not a ta

        self.email = kwargs.get("email")
        self.password_digest = bcrypt.hashpw(kwargs.get("password").encode("utf8"), bcrypt.gensalt(rounds=13))
        self.renew_session()

    def serialize(self):
        """
        Serialize User object
        """
        return {
            "id": self.id,
            "name": self.name,
            "netid": self.netid,
            "student_courses": [c.simple_serialize() for c in self.student_courses],
            "ta_courses": [t.simple_serialize() for t in self.ta_courses]
        }

    def simple_serialize(self):
        """
        Simply serialize User object
        """
        return {
            "id": self.id,
            "name": self.name,
            "netid": self.netid,
        }

    #authentication methods:-----------------------------------------------------------------------------------------------------

    def _urlsafe_base_64(self):
        """
        Randomly generates hashed tokens (used for session/update tokens)
        """
        return hashlib.sha1(os.urandom(64)).hexdigest()

    def renew_session(self):
        """
        Renews the sessions, i.e.
        1. Creates a new session token
        2. Sets the expiration time of the session to be a day from now
        3. Creates a new update token
        """
        self.session_token = self._urlsafe_base_64()
        self.session_expiration = datetime.datetime.now() + datetime.timedelta(days=1)   #session expires after 1 day
        self.update_token = self._urlsafe_base_64()

    def verify_password(self, password):
        """
        Verifies the password of a user
        """
        return bcrypt.checkpw(password.encode("utf8"), self.password_digest)

    def verify_session_token(self, session_token):
        """
        Verifies the session token of a user
        """
        return session_token == self.session_token and datetime.datetime.now() < self.session_expiration

    def verify_update_token(self, update_token):
        """
        Verifies the update token of a user
        """
        return update_token == self.update_token

#----COURSE MODEL-------------------------------------------------------------------------------

class Course(db.Model):
    """
    Courses model
    """
    __tablename__ = "courses"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    code = db.Column(db.String, nullable = False)    #The number following the subject, etc: CS2800
    name = db.Column(db.String, nullable = False)     #The course tite, etc: Discrete Structures
    

    #relationships
    office_hours = db.relationship("OfficeHours", cascade="delete")
    tas = db.relationship("User", secondary= ta_association_table, back_populates="ta_courses")
    students = db.relationship("User", secondary= student_association_table, back_populates="student_courses")

    def __init__(self, **kwargs): 
        """
        initalize tasks object/entry
        """
        self.code = kwargs.get("code", "")
        self.name = kwargs.get("name", "")

    def serialize(self):
        """
        Serialize Course object
        """
        return {
            "id": self.id,
            "code": self.code,
            "name": self.name,
            "office_hours": [a.simple_serialize() for a in self.office_hours],
            "tas": [t.simple_serialize() for t in self.tas],
            "students": [s.simple_serialize() for s in self.students]
        }

    def simple_serialize(self):
        """
        Simply serialize Course object
        """
        return {
            "id": self.id,
            "code": self.code,
            "name": self.name,
        }

#----OFFICE HOURS MODEL---------------------------------------------------------------------------------

class OfficeHours(db.Model):
    __tablename__ = "office_hours"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    time = db.Column(db.Integer, nullable = False)
    location = db.Column(db.String, nullable = False)
    
    course_id = db.Column(db.Integer, db.ForeignKey("courses.id"), nullable = False)  # the course the OH is for
    ta_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable = False)  #the ta creating the OH
   
    #relationships:
    course = db.relationship("Course", back_populates= "office_hours")
    ta = db.relationship("User", back_populates = "office_hours")

    def __init__(self, **kwargs): #kwargs = key word arguments
        """
        initalize an Office Hour object/entry
        """
        self.time = kwargs.get("time", "")
        self.location = kwargs.get("location", "")
        self.course = kwargs.get("course") 
        self.ta = kwargs.get("ta")

    def serialize(self):
        """
        Serialize Office Hour object
        """
        return {
            "id": self.id,
            "time": self.time,
            "location": self.location,
            "course": self.course.simple_serialize(),
            "ta": self.ta.simple_serialize()
            
        }

    def simple_serialize(self):
        """
        Simply serialize Office Hour object
        """
        return {
            "id": self.id,
            "time": self.time,
            "location": self.location
        }