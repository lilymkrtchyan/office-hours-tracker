import json

from db import db
from flask import Flask
from flask import request

from db import Course
from db import User
from db import OfficeHours
import users_dao
import datetime

app = Flask(__name__)
db_filename = "cms.db"

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


@app.route("/api/courses/<int:user_id>/<int:course_id>/enroll/", methods=["POST"])
def enroll_in_course(user_id, course_id):
    """
    Endpoint for enrolling a user into a course by user id and course id
    """
    user = User.query.filter_by(id = user_id).first()
    if user is None:
        return failure_response("User not found!")
    course = Course.query.filter_by(id = course_id).first()
    if user.is_ta:
        course.tas.append(user)
    else:
        course.students.append(user)
    db.session.commit()
    return success_response(new_course.serialize(), 201)


@app.route("/api/courses/", methods=["POST"])
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


@app.route("/api/courses/<int:course_id>/<int:user_id>/", methods=["DELETE"])
def delete_course(course_id, user_id):
    """
    Endpoint for deleting a course by id and removing corresponding TAs/students.
    """
    course = Course.query.filter_by(id = course_id).first()
    if course is None:
        return failure_response("Course not found!")
    user = User.query.filter_by(id = user_id).first()
    if user is None:
        return failure_response("User not found!")
    if user.is_ta:
        course.tas.remove(user)
    else:
        course.students.remove(user)
    db.session.delete(course)
    db.session.commit()
    return success_response(course.serialize())

#-----AUTHORIZATION ROUTES-----------------------------------------------------------------------------------

def extract_token(request):
    """
    Helper function that extracts the token from the header of a request
    """
    auth_header = request.headers.get("Authorization")  

    if auth_header is None:
        return False, json.dumps({"Missing authorization header"})

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

    if email is None or password is None:
        return failure_response("Missing email or password")
    
    was_successful, user = users_dao.create_user(email,password)

    if not was_successful:
        return failure_response("User already exists")

    return success_response(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token               
        }, 201
    )


@app.route("/login/", methods=["POST"])
def login():
    """
    Endpoint for logging in a user
    """
    body = json.loads(request.data)
    email = body.get("email")
    password = body.get("password") 

    if email is None or password is None:
        return failure_response("Missing email or password", 400)

    was_successful, user = users_dao.verify_credentials(email, password)

    if not was_successful:
        return failure_response("Incorrect username or password", 401)

    return success_response(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token
        }

    )


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


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)