//
//  NetworkManager.swift
//  Hackathon2022
//
//  Created by Joanna Lin on 4/27/22.
//

import Foundation
import Alamofire

class NetworkManager{
    static let host = "http://34.130.154.75/api"

    static func getAllOHs(completion: @escaping (OHList) -> Void) {
        let endpoint = "\(host)/officehours/"
        
        AF.request(endpoint, method: .get).validate().responseData { response in
            //process the response
            switch (response.result){
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(OHList.self, from: data){
                    completion(userResponse)
                }
                else{
                    print ("Failed to decode getAllOHs")
                }
                
            case .failure(let error):
                print (error.localizedDescription)
                
            }
            
        }
    }
    
    // About attendance
    
    static func addAttendance(id: Int, completion: @escaping (OH) -> Void) {
        let endpoint = "\(host)/officehours/\(id)/attend/"
        
        AF.request(endpoint, method: .get).validate().responseData { response in
            //process the response
            switch (response.result){
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(OH.self, from: data){
                    completion(userResponse)
                }
                else{
                    print ("Failed to decode addAttendance")
                }
                
            case .failure(let error):
                print (error.localizedDescription)
                
            }
            
        }
    }
    
    static func deleteAttendance(id: Int, completion: @escaping (OH) -> Void) {
        let endpoint = "\(host)/officehours/\(id)/unattend"
        
        AF.request(endpoint, method: .get).validate().responseData { response in
            //process the response
            switch (response.result){
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(OH.self, from: data){
                    completion(userResponse)
                }
                else{
                    print ("Failed to decode deleteAttendance")
                }
                
            case .failure(let error):
                print (error.localizedDescription)
                
            }
        }
    }
    
    static func getAttendance(id: Int, completion: @escaping (AttendanceData) -> Void) {
        let endpoint = "\(host)/officehours/\(id)/attendance/"
        
        AF.request(endpoint, method: .get).validate().responseData { response in
            //process the response
            switch (response.result){
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(AttendanceData.self, from: data){
                    completion(userResponse)
                }
                else{
                    print ("Failed to decode getAttendance")
                }
                
            case .failure(let error):
                print (error.localizedDescription)
                
            }
            
        }
    }
    

    static func getOHs(id: Int, completion: @escaping (OHList) -> Void) {
        let endpoint = "\(host)/officehours/"
        let params: Parameters = [
            "ta_id": id
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            //process the response
            switch (response.result){
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
           
                if let userResponse = try? jsonDecoder.decode(OHList.self, from: data){
                    completion(userResponse)
                }
                else{
                    print ("Failed to decode getOHs")
                }
                
            case .failure(let error):
                print (error.localizedDescription)
                
            }
            
        }
    }
    
    
    
    
    static func getOHsFromDay(day: String, completion: @escaping (OHList) -> Void) {
        let endpoint = "\(host)/officehours/"
        let params: Parameters = [
            "day": day
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            //process the response
            switch (response.result){
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
           
                if let userResponse = try? jsonDecoder.decode(OHList.self, from: data){
                    completion(userResponse)
                }
                else{
                    print ("Failed to decode getOHsFromDay")
                }
                
            case .failure(let error):
                print (error.localizedDescription)
                
            }
            
        }
    }

    
    static func getOHsfromCourse(coursecode: String, completion: @escaping (OHList) -> Void) {
        let endpoint = "\(host)/officehours/"
        let params: Parameters = [
            "course_code" : coursecode
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            //process the response
            switch (response.result){
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
           
                if let userResponse = try? jsonDecoder.decode(OHList.self, from: data){
                    completion(userResponse)
                }
                else{
                    print ("Failed to decode getOHsFromCourse")
                }
                
            case .failure(let error):
                print (error.localizedDescription)
                
            }
            
        }
    }
    
    static func getCourseid(coursecode: String, completion: @escaping (Course) -> Void){
        let endpoint = "\(host)/course/"

        let params: Parameters = [
            "code": coursecode
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            //process the response
            switch (response.result){
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(Course.self, from: data){
//                    print(userResponse)
                    completion(userResponse)
                }
                else{
                    print ("Failed to decode getCourseid")
                }
                
            case .failure(let error):
                print (error.localizedDescription)
                
            }
            
        }
    }
    
    static func createOH(taid: Int, courseid: Int, dayofweek: String, start: String, end: String, location: String, completion: @escaping (OH) -> Void) {

        
        let endpoint = "\(host)/officehours/create/\(courseid)/\(taid)/"
        let params: Parameters = [
            "day": dayofweek,
            "start_time": start,
            "end_time": end,
            "location": location
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            //process the response
            switch (response.result){
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(OH.self, from: data){
                    completion(userResponse)
                }
                else{
                    print ("Failed to decode createOH")
                }
                
            case .failure(let error):
                print (error.localizedDescription)
                
            }
            
        }
    
        
        
    }
    
    static func updateOH(id: Int, dayofweek: String, start: String, end: String, location: String, completion: @escaping (OH) -> Void) {
        print(id)
        let endpoint = "\(host)/officehours/\(id)/"
        let params: Parameters = [
            "day": dayofweek,
            "start_time": start,
            "end_time": end,
            "location": location,
        ]
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            //process the response
            switch (response.result){
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(OH.self, from: data){
                    completion(userResponse)
                }
                else{
                    print ("Failed to decode updateOH")
                }
                
            case .failure(let error):
                print (error.localizedDescription)
                
            }
            
        }
    }

    
    static func deleteOH(id: Int, completion: @escaping (Bool) -> Void) {
        print(id)
        let endpoint = "\(host)/officehours/\(id)/"
        //ID will just be in url
        
        AF.request(endpoint, method: .delete, encoding: JSONEncoding.default).validate().responseData { response in
            //process the response
            switch (response.result){
            case .success(_):
                completion(true)
            case .failure(let error):
                print (error.localizedDescription)
                completion(false)
            }
            
        }
    }
    

//    static func getPostersOHs(poster: String, completion: Any) {
//
//    }
    
}


