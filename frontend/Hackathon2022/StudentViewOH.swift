//
//  StudentViewOH.swift
//  Hackathon2022
//
//  Created by Joanna Lin on 4/26/22.
//

import UIKit

class StudentViewOH: UITableViewCell {

    static let id = "StudentViewOHID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupview()
        setupconstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    var border: UIButton = {
//       let border = UIButton()
//        border.layer.borderWidth = 0.5
//        border.layer.borderColor = UIColor.black.cgColor
//        border.layer.cornerRadius = 5
//        return border
//    }()
    
    var taname: UILabel = {
        let label = UILabel()
//        label.frame = CGRect(x: 0, y: 0, width: 45, height: 12)
        label.textColor = .black
//        label.font = UIFont(name: "SFPro-Regular", size: 10)
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.text = "..."
        return label
    }()
    
    var profilepic: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "camera")
        image.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        return image
    }()
    
    var locationpic: UIImageView = {
        let image = UIImageView()
         image.image = UIImage(named: "pin")
         image.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
         return image
    }()
    
//    var coursename: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 15, weight: .semibold)
//        label.textColor = .black
//        return label
//    }()
    
    var time: UILabel = {
        let label = UILabel()
//        label.font = UIFont(name: "SFPro-Medium", size: 12)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.text = "..."
        return label
    }()
    
    var location: UILabel = {
        let label = UILabel()
//        label.frame = CGRect(x: 0, y: 0, width: 57, height: 12)
        label.textColor = .black
        label.text = "..."
//        label.font = UIFont(name: "SFPro-Regular", size: 10)
        label.font = .systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
//    @objc func attendancepressed(){
//        if attendance.isHighlighted {
//            attendance.backgroundColor = .green
//
//        }
////        if !attendance.isHighlighted{
////            attendance.backgroundColor = .clear
////            attendance.isHighlighted = false
////        }
//    }
    
    func setupconstraints(){
        NSLayoutConstraint.activate([
            
//            border.topAnchor.constraint(equalTo: contentView.topAnchor),
//            border.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
//            border.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
//            border.heightAnchor.constraint(equalToConstant: 31),
//            border.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            time.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            time.heightAnchor.constraint(equalToConstant: 14),
            time.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            profilepic.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 4),
            profilepic.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            profilepic.heightAnchor.constraint(equalToConstant: 12),
            profilepic.widthAnchor.constraint(equalToConstant: 12),
            profilepic.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            taname.leadingAnchor.constraint(equalTo: profilepic.trailingAnchor, constant: 2),
            taname.topAnchor.constraint(equalTo: profilepic.topAnchor),
            taname.heightAnchor.constraint(equalToConstant: 12),
            
            locationpic.topAnchor.constraint(equalTo: profilepic.topAnchor),
            locationpic.leadingAnchor.constraint(equalTo: taname.leadingAnchor, constant: 71),
            locationpic.heightAnchor.constraint(equalToConstant: 12),
            locationpic.widthAnchor.constraint(equalToConstant: 12),
            
            location.leadingAnchor.constraint(equalTo: locationpic.trailingAnchor, constant: 2),
            location.topAnchor.constraint(equalTo: profilepic.topAnchor),
            location.heightAnchor.constraint(equalToConstant: 12)
            
        
        ])
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
//
//    }
//
    func setupview(){
        [time, location, taname, locationpic, profilepic].forEach { views in
            views.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(views)
        }
    }

    
    func configure(oh: OH){
//        if let coursetitle = oh.coursename{
//            coursename.text = coursetitle
//        }
//        else {
//            coursename.text = "Course name not available"
//        }
        taname.text = oh.ta?.name ?? ""
        
        if let starthr = oh.start_time{
            if let endhr = oh.end_time{
                time.text = "\(starthr) - \(endhr)"
            }
            else{
                time.text = "\(starthr) - ..."
            }
        }
        else if let endhr = oh.end_time{
            time.text = "... - \(endhr)"
        }
        else{
            time.text = "Time not available"
        }
        
        
        
        if let locationspot = oh.location {
            location.text = locationspot
        }
        else{
            location.text = "Location not available"
        }
        
        
        
    }


}
