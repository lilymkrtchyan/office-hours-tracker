import json

from db import db
from flask import Flask
from flask import request
from db import Course
from db import User
from db import OfficeHours

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


@app.route("/api/courses/<int:user_id>/<int:course_id/enroll>", methods=["POST"])
def enroll_in_course(user_id, course_id):
    """
    Endpoint for enrolling in a course.
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