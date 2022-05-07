//
//  OH.swift
//  Hackathon2022
//
//  Created by Joanna Lin on 4/26/22.
//

import Foundation

struct OHList: Decodable, Encodable{
    let office_hours: [OH]?
}

struct AttendanceData: Decodable, Encodable{
    let attendance: Int? 
}

struct OH: Decodable, Encodable{
    let id: Int
    let ta: TAStudent?
    let course: Course?
    let day: String?
    let start_time: String?
    let end_time: String?
    let location: String?
    let attendance: Int?
    
}

struct Course: Decodable, Encodable{
    let id: Int
    let name: String?
    let code: String?

}

struct TAStudent: Decodable, Encodable{
    let id: Int
    let name: String?
    let netid: String?
    let email: String?
//    let is_ta: Bool?
    let office_hours: [OH]?
    let student_courses: [Course]?
    let ta_courses: [Course]?
    let session_token: String?
    let session_expiration: String?
    let update_token: String?
    //This is the oh they are attending for student and the oh they are hosting for the ta
}


