import json

from db import db
from flask import Flask
from flask import request

from db import Course
from db import User
from db import OfficeHours
import users_dao
import oh_dao
import datetime

app = Flask(__name__)
db_filename = "oht.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()


# generalized response formats
def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=404):
    return json.dumps({"error": message}), code

#------COURSE ROUTES-----------------------------------------------------------------

@app.route("/")
@app.route("/api/courses/")
def get_courses():
    """
    Endpoint for getting all courses.
    """
    courses = []
    for course in Course.query.all():
        courses.append(course.serialize())

    return success_response({"courses": courses})


@app.route("/api/courses/", methods=["POST"])
def create_course():
    """
    Endpoint for creating a new course.
    """
    body = json.loads(request.data)
    if body.get("code") is None:
        return failure_response("Please insert the code", 400)
    if body.get("name") is None:
        return failure_response("Please insert the name", 400)
   
    spaceFree = body.get("code").replace(" ", "")
    lowercase = spaceFree.lower()
    new_course = Course(code=lowercase, name=body.get("name"))
    db.session.add(new_course)
    db.session.commit()
    return success_response(new_course.serialize(), 201)


@app.route("/api/courses/<int:user_id>/<course_id>/enroll/", methods=["GET"])
def enroll_in_course(user_id, course_id):
    """
    Endpoint for enrolling a user into a course by user id and course id
    """

    course = Course.query.filter_by(course_id = course_id).first()
    if course is None:
        return failure_response("Course not found!")
    user = User.query.filter_by(user_id = user_id).first()
    if user is None:
        return failure_response("User not found!")
    if user.is_ta:
        course.tas.append(user)
    else:
        course.students.append(user)
    db.session.commit()
    return success_response(user.serialize(), 200)


@app.route("/api/courses/<int:user_id>/<course_id>/unenroll/", methods=["GET"])
def unenroll(user_id, course_id):
    course = Course.query.filter_by(course_id = course_id).first()
    if course is None:
        return failure_response("Course not found!")
    user = User.query.filter_by(user_id = user_id).first()
    if user is None:
        return failure_response("User not found!")
    if not user in course.students:
        return failure_response("Student is not enrolled in this course!")
    course.students.remove(user)
    db.session.commit()
    return success_response(user.serialize(), 200)



@app.route("/api/course/", methods=["POST"])
def get_course():
    """
    Endpoint for getting a course by code.
    """
    body = json.loads(request.data)
    spaceFree = body.get("code").replace(" ", "")
    lowercase = spaceFree.lower()
    course = Course.query.filter_by(code=lowercase).first()
    if course is None:
        return failure_response("course not found!")
    return success_response(course.serialize())




@app.route("/api/courses/<int:course_id>/", methods=["DELETE"])
def delete_course(course_id):
    """
    Endpoint for deleting a course by id and removing corresponding TAs/students.
    """
    course = Course.query.filter_by(course_id = course_id).first()
    if course is None:
        return failure_response("Course not found!")
    
    db.session.delete(course)
    db.session.commit()
    return success_response(course.serialize())

#------OFFICE ROUTES-----------------------------------------------------------------

@app.route("/api/officehours/")
def get_all_office_hours():
    """
    Endpoint for getting all office hours based on filter
    """
    office_hours = oh_dao.get_all_oh()
    return success_response({"office_hours":[o.serialize() for o in office_hours]})


@app.route("/api/officehours/",methods = ["POST"])
def get_all_office_hours_filter():
    """
    Endpoint for getting all office hours based on filter
    """
    body = json.loads(request.data)
    course_code = body.get("course_code")
    if course_code is not None:
        course_code = course_code.replace(" ", "").lower()
    start_time = body.get("start_time")
    end_time = body.get("end_time")
    day = body.get("day")
    location = body.get("location")
    ta_name = body.get("ta_name")
    ta_id = body.get("ta_id")
    office_hours = oh_dao.get_oh_filtered(day,start_time,end_time,location,course_code,ta_name,ta_id)
    return success_response({"office_hours":[o.serialize() for o in office_hours]})

@app.route("/api/officehours/create/<int:course_id>/<int:ta_id>/",methods = ["POST"])
def create_officehour(course_id,ta_id):
    """
    Endpoint for creating office hour after verifying session token
    """
    was_successful, session_token = extract_token(request)

    if not was_successful:
        return session_token

    user = users_dao.get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return failure_response("Invalid session token")

    body = json.loads(request.data)
    day = body.get("day")
    start_time = body.get("start_time")
    end_time = body.get("end_time")
    location = body.get("location")
    
    if day is None or start_time is None or end_time is None or location is None:
        return failure_response("Office Hour info not found!")
    ta = users_dao.get_user_by_id(ta_id)
     
    course = oh_dao.get_course_by_id(course_id)
    if course is None:
        return failure_response("Course not found!")
    if ta is None:
        return failure_response("Ta not found!")
    new_oh = oh_dao.create_oh(day,start_time,end_time,location,course_id,ta_id)
    ta.office_hours.append(new_oh)
    return success_response(new_oh.serialize(),201)


@app.route("/api/officehours/<int:office_hour_id>/",methods = ["POST"])
def update_officehour(office_hour_id):
    """
    Endpoint for updating office hour by id after verifying session
    """
    was_successful, session_token = extract_token(request)

    if not was_successful:
        return session_token

    user = users_dao.get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return failure_response("Invalid session token")

    oh = oh_dao.get_oh_by_id(office_hour_id)
    if oh is None:
        return failure_response("Office hour not found!")
    body = json.loads(request.data)
    day = body.get("day")
    start_time = body.get("start_time")
    end_time = body.get("end_time")
    location = body.get("location")

    if day is not None:
        oh.day = day
    if start_time is not None:
        oh.start_time = start_time
    if end_time is not None:
        oh.end_time = end_time
    if location is not None:
        oh.location = location
    return success_response(oh.serialize())


@app.route("/api/officehours/<int:office_hour_id>/",methods = ["DELETE"])
def delete_officehour(office_hour_id):
    """
    Endpoint for deleting office hour by id after verifying session
    """
    was_successful, session_token = extract_token(request)

    if not was_successful:
        return session_token

    user = users_dao.get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return failure_response("Invalid session token")

    oh = oh_dao.get_oh_by_id(office_hour_id)
    if oh is None:
        return failure_response("Office hour not found!")
    db.session.delete(oh)
    db.session.commit()
    return success_response("Successfully deleted")        #look at oh.serialize()


#-----ATTENDING OH ROUTES------------------------------------------------------------------------------------
@app.route("/api/officehours/<int:office_hour_id>/attendance/")
def get_attendance(office_hour_id):
    """
    Endpoint for getting the attendance of an office hour by its id
    """
    oh = oh_dao.get_oh_by_id(office_hour_id)
    if oh is None:
        return failure_response("Office hour not found!")
    return success_response(
        {
            "attendance": oh.attendance
        }
    )

@app.route("/api/officehours/<int:office_hour_id>/attend/")
def attend_officehour(office_hour_id):
    """
    Endpoint for selecting an office hour for a user to attend. 
    Increment the office hour's attendance by 1.
    """
    was_successful, session_token = extract_token(request)

    if not was_successful:
        return session_token

    user = users_dao.get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return failure_response("Invalid session token")

    oh = oh_dao.get_oh_by_id(office_hour_id)
    if oh is None:
        return failure_response("Office hour not found!")

    oh.attendance +=1

    db.session.commit()
    return success_response(oh.serialize())

@app.route("/api/officehours/<int:office_hour_id>/unattend/")
def remove_attendance(office_hour_id):
    """
    Endpoint for removing a user's attendance from an office hour.
    Decrement the office hour's attendance by 1.
    """
    was_successful, session_token = extract_token(request)

    if not was_successful:
        return session_token

    user = users_dao.get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return failure_response("Invalid session token")

    oh = oh_dao.get_oh_by_id(office_hour_id)
    if oh is None:
        return failure_response("Office hour not found!")
    
    oh.attendance -=1
    if oh.attendance <= 0:
        oh.attendance = 0

    db.session.commit()
    return success_response(oh.serialize())

#-----AUTHORIZATION AND USER ROUTES-----------------------------------------------------------------------------------

def extract_token(request):
    """
    Helper function that extracts the token from the header of a request
    """
    auth_header = request.headers.get("Authorization")  
    
    if auth_header is None:
        return False, json.dumps("Missing authorization header")

    #gets token
    bearer_token = auth_header.replace("Bearer", "").strip()

    return True, bearer_token


@app.route("/register/", methods=["POST"])
def register_account():
    """
    Endpoint for registering a new user
    """
    body = json.loads(request.data)
    email = body.get("email")
    password = body.get("password")
    name = body.get("name")
    netid = body.get("netid")
    is_ta = body.get("is_ta", False)

    if email is None or password is None:
        return failure_response("Missing email or password")
    if name is None:
        return failure_response("Missing name")
    if netid is None:
        return failure_response("Missing netid")
    
    was_successful, user = users_dao.create_user(email,password,name,netid,is_ta)

    if not was_successful:
        return failure_response("User already exists")

    return success_response(user.serialize(), 201 )


@app.route("/login/", methods=["POST"])
def login():
    """
    Endpoint for logging in a user, can login as a student or ta
    """
    body = json.loads(request.data)
    email = body.get("email")
    password = body.get("password") 
    is_ta = body.get("is_ta", False)

    if email is None or password is None:
        return failure_response("Missing email or password", 400)

    was_successful, user = users_dao.verify_credentials(email, password)

    if not was_successful:
        return failure_response("Incorrect username or password", 401)

    #update if user is now a student or a ta:
    users_dao.update_user_status(email, is_ta)

    return success_response(user.serialize())


@app.route("/session/", methods=["POST"])
def update_session():
    """
    Endpoint for updating a user's session
    """
    was_successful, update_token = extract_token(request)

    if not was_successful:
        return update_token

    try:
        user = users_dao.renew_session(update_token)
    except Exception as e:
        return failure_response(f"Invalid update token: {str(e)}") #f allows you to print a variable

    return success_response(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token
        }
    )

@app.route("/logout/",methods=["POST"])
def logout():
    was_successful, session_token = extract_token(request)

    if not was_successful:
        return session_token
    
    user = users_dao.get_user_by_session_token(session_token)

    if not user or not user.verify_session_token(session_token):
        return failure_response("Invalid session token")

    user.session_expiration = datetime.datetime.now()

    db.session.commit()

    return success_response({
        "message": "You have successfully logged out!"
    })

@app.route("/api/users/", methods=["GET"])
def get_all_users():
    """
    Endpoint for getting all users
    """
    users = users_dao.get_all_users()
    return success_response({"users":[u.serialize() for u in users]})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)