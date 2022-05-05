"""
DAO (Data Access Object) file

Helper file containing functions for accessing data in our database
"""
from http.client import NETWORK_AUTHENTICATION_REQUIRED
from unicodedata import name
from db import db
from db import User
from db import OfficeHours
from db import Course

#----AUTHENICATION AND USER FUNCTIONS-------------------------------------------------------------

def get_user_by_id(user_id):
    """
    Returns a user object from the database given an id
    """
    return User.query.filter(User.user_id == user_id).first()

def get_user_by_email(email):
    """
    Returns a user object from the database given an email
    """
    return User.query.filter(User.email == email).first()


def get_user_by_session_token(session_token):
    """
    Returns a user object from the database given a session token
    """
    return User.query.filter(User.session_token == session_token).first()


def get_user_by_update_token(update_token):
    """
    Returns a user object from the database given an update token
    """
    return User.query.filter(User.update_token == update_token).first()


def verify_credentials(email, password):
    """
    Returns true if the credentials match, otherwise returns false
    """
    optional_user = get_user_by_email(email)

    if optional_user is None:
        return False, None

    return optional_user.verify_password(password), optional_user


def create_user(email, password, name, netid, is_ta):
    """
    Creates a User object in the database

    Returns if creation was successful, and the User object
    """
    optional_user = get_user_by_email(email)

    if optional_user is not None:
        return False, optional_user
    
    user = User(
        email=email, 
        password=password,
        name = name,
        netid = netid,
        is_ta= is_ta
        )
    db.session.add(user)
    db.session.commit()
    return True, user


def renew_session(update_token):
    """
    Renews a user's session token
    Returns the User object
    """
    user = get_user_by_update_token(update_token)

    if user is None:
        raise Exception("Invalid update token")  #in our dao file, return exception rather than json failure response

    user.renew_session()
    db.session.commit()

    return user 

def update_user_status(email, is_ta):
    """
    Updates the user's is_ta status with whatever label they logged in with by their email.
    """
    user = get_user_by_email(email)
    user.is_ta = is_ta



#-----OFFICE HOUR FUNCTIONS-----------------------------------------------------------------------------

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

def get_oh_filtered(day = None, time = None, location = None, course_code = None, ta_name = None):
    """
    Gets office hours filtered on office hour characteristics
    """
    filtered = OfficeHours.query
    if day is not None:
        filtered = filtered.filter(OfficeHours.day == day)
    if time is not None:
        filtered = filtered.filter(OfficeHours.time == time)
    if location is not None:
        filtered = filtered.filter(OfficeHours.location == location)
    if course_code is not None:
        filtered = filtered.filter(OfficeHours.course.code == course_code)
    if ta_name is not None:
        filtered = filtered.filter(OfficeHours.ta.name == ta_name)
    return filtered.all()

def create_oh(day, time, location, course_id, ta_id):
    """
    Creates office hour and return true if succesful
    """
    new_oh = OfficeHours(
        day = day,
        time = time,
        location = location,
        course_id = course_id,
        ta_id = ta_id
    )
    db.session.add(new_oh)
    db.session.commit()
    return new_oh




