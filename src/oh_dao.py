"""
DAO (Data Access Object) file for Office Hours

Helper file containing functions for accessing data in our database
"""
from db import db
from db import User
from db import OfficeHours
from db import Course

def get_course_by_id(course_id):
    """
    Returns a user object from the database given an id
    """
    return Course.query.filter(Course.course_id == course_id).first()

def get_oh_by_id(oh_id):
    """
    Gets office hour by id
    """
    return OfficeHours.query.filter(OfficeHours.id == oh_id).first()

def get_all_oh():
    """
    Gets all office hours and return them as list of office hour objects
    """
    return OfficeHours.query.all()

def get_oh_filtered(day = None, start_time = None, end_time = None,location = None, course_code = None, ta_name = None, ta_id = None):
    """
    Gets office hours filtered on office hour characteristics
    """
    filtered = OfficeHours.query
    if course_code is not None:
        course = Course.query.filter(Course.code == course_code).first()
        filtered = filtered.filter(OfficeHours.course == course)
    if day is not None:
        filtered = filtered.filter(OfficeHours.day == day)
    if start_time is not None:
        filtered = filtered.filter(OfficeHours.start_time == start_time)
    if end_time is not None:
        filtered = filtered.filter(OfficeHours.end_time == end_time)
    if location is not None:
        filtered = filtered.filter(OfficeHours.location == location)
    if ta_name is not None:
        user = User.query.filter(User.name == ta_name).first()
        filtered = filtered.filter(OfficeHours.ta == user)
    if ta_id is not None:
        user = User.query.filter(User.user_id == ta_id).first()
        filtered = filtered.filter(OfficeHours.ta == user)
    return filtered.all()

def create_oh(day, start_time, end_time,location, course_id, ta_id):
    """
    Creates office hour and return true if succesful
    """
    new_oh = OfficeHours(
        day = day,
        start_time = start_time,
        end_time = end_time,
        location = location,
        course_id = course_id,
        ta_id = ta_id,
        attendance = 0
    )
    db.session.add(new_oh)
    db.session.commit()
    return new_oh




