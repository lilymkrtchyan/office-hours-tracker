from flask_sqlalchemy import SQLAlchemy

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
    is_ta = db.Column(db.boolean, nullable = False) #true is the user is a ta, false otherwise
   
    #relationships:
    student_courses = db.relationship("Course", secondary= student_association_table, back_populates="students")
    ta_courses = db.relationship("Course", secondary= ta_association_table, back_populates="tas")
    office_hours = db.relationship("OfficeHours", cascade="delete")

    def __init__(self, **kwargs): 
        """
        initalize user object/entry
        """
        self.name = kwargs.get("name", "")
        self.netid = kwargs.get("netid", "")
        self.is_ta = kwargs.get("is_ta", False)    #by default a user is not a ta

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

#----COURSE MODEL-------------------------------------------------------------------------------

class Course(db.Model):
    """
    Courses model
    """
    __tablename__ = "courses"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    subject = db.Column(db.String, nullable = False)  #CS, MATH, PHYS, INFO, etc
    code = db.Column(db.String, nullable = False)    #The number following the subject, etc: 2800 in "CS 2800"
    name = db.Column(db.String, nullable = False)     #The course tite, etc: Discrete Structures

    #relationships
    office_hours = db.relationship("OfficeHours", cascade="delete")
    tas = db.relationship("User", secondary= ta_association_table, back_populates="ta_courses")
    students = db.relationship("User", secondary= student_association_table, back_populates="student_courses")

    def __init__(self, **kwargs): 
        """
        initalize tasks object/entry
        """
        self.subject = kwargs.get("subject", "")
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
            "subject": self.subject,
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
    ta_id = db.Column(db.Integer, db.ForeginKey("users.id"), nullable = False)  #the ta creating the OH
   
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