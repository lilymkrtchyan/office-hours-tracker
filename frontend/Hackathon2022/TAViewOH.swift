//
//  TAViewOH.swift
//  Hackathon2022
//
//  Created by Joanna Lin on 4/26/22.
//

import UIKit

class TAViewOH: UITableViewCell {
    
    static let id = "TAViewOHID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupview()
        setupconstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var border: UIView = {
       let border = UIView()
//        border.frame = CGRect(x: 0, y: 0, width: 315, height: 100)
        border.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        border.layer.borderWidth = 1
        border.backgroundColor = .clear
        border.layer.cornerRadius = 10
//        border.layer.shadowOffset = CGSize(width: 1, height: 1)
//        border.layer.shadowColor = UIColor.black.cgColor
//        border.layer.shadowRadius = 10
//        border.layer.shadowOpacity = 0.3
//        border.layer.masksToBounds = false
//        border.layer.shouldRasterize = true
//        border.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        return border
    }()

    var delete: UIButton = {
        let button = UIButton()
//        button.addTarget(self, action: #selector(deletepressed), for: .touchUpInside)
        button.setTitleColor(UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.setTitle("Delete", for: .normal)
//        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 12)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
//        button.titleLabel?.frame = CGRect(x: 0, y: 0, width: 23, height: 14)
        return button
    }()
    
    var edit: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.setTitle("Edit", for: .normal)
//        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 12)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
//        button.frame = CGRect(x: 0, y: 0, width: 23, height: 14)
        return button
    }()
    
    var coursename: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 58, height: 17)
//        label.font = UIFont(name: "SFPro-Medium", size: 14)
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 0.608, green: 0.608, blue: 0.608, alpha: 1)
        return label
    }()
    
    var date: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 104, height: 14)
//        label.font = UIFont(name: "SFPro-Medium", size: 12)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.text = "..."
        return label
    }()
    
    var time: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 60, height: 14)
//        label.font = UIFont(name: "SFPro-Regular", size: 12)
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.text = "..."
        return label
    }()
    
    var location: UILabel = {
        let label = UILabel()
//        label.frame = CGRect(x: 0, y: 0, width: 104, height: 14)
//        label.font = UIFont(name: "SFPro-Regular", size: 12)
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.text = "..."
        return label
    }()
    
    var attendance: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 60, height: 14)
//        label.font = UIFont(name: "SFPro-Medium", size: 12)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(red: 0.169, green: 0.7, blue: 0.19, alpha: 1)
        label.text = "• ... going"
        return label
    }()
    
    var clock: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "time")
        image.frame = CGRect(x: 0, y: 0, width: 10.5, height: 10.5)
        return image
    }()
    
    var pin: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "pin")
        image.frame = CGRect(x: 0, y: 0, width: 10.5, height: 10.5)
        return image
    }()
    
    func setupview(){
        [border, delete, edit, time, location, coursename, attendance, coursename, pin, clock, date].forEach { views in
            views.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(views)
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
//
//    }
    
    func setupconstraints(){
        NSLayoutConstraint.activate([
        
            border.topAnchor.constraint(equalTo: contentView.topAnchor),
            border.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            border.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            border.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            coursename.topAnchor.constraint(equalTo: border.topAnchor, constant: 10),
            coursename.leadingAnchor.constraint(equalTo: border.leadingAnchor, constant: 17),
            coursename.heightAnchor.constraint(equalToConstant: 17),
            
            delete.bottomAnchor.constraint(equalTo: location.bottomAnchor, constant: 5),
            delete.trailingAnchor.constraint(equalTo: border.trailingAnchor, constant: -7),
            delete.widthAnchor.constraint(equalToConstant: 58),
            delete.heightAnchor.constraint(equalToConstant: 24),
            
            edit.bottomAnchor.constraint(equalTo: delete.topAnchor, constant: 0),
            edit.trailingAnchor.constraint(equalTo: delete.trailingAnchor),
            edit.widthAnchor.constraint(equalToConstant: 58),
            edit.heightAnchor.constraint(equalToConstant: 24),
            
            time.topAnchor.constraint(equalTo: clock.topAnchor, constant: -1.75),
            time.leadingAnchor.constraint(equalTo: clock.trailingAnchor, constant: 5),
            time.heightAnchor.constraint(equalToConstant: 14),
            
            date.topAnchor.constraint(equalTo: coursename.bottomAnchor, constant: 10),
            date.leadingAnchor.constraint(equalTo: coursename.leadingAnchor),
//            date.widthAnchor.constraint(equalToConstant: 104),
            date.heightAnchor.constraint(equalToConstant: 14),
            
            clock.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 8),
            clock.leadingAnchor.constraint(equalTo: coursename.leadingAnchor),
            clock.widthAnchor.constraint(equalToConstant: 10.5),
            clock.heightAnchor.constraint(equalToConstant: 10.5),
            
            pin.topAnchor.constraint(equalTo: clock.bottomAnchor, constant: 8),
            pin.leadingAnchor.constraint(equalTo: date.leadingAnchor),
            pin.widthAnchor.constraint(equalToConstant: 10.5),
            pin.heightAnchor.constraint(equalToConstant: 10.5),
            
            location.topAnchor.constraint(equalTo: pin.topAnchor, constant: -1.75),
            location.leadingAnchor.constraint(equalTo: pin.trailingAnchor, constant: 5),
            location.heightAnchor.constraint(equalToConstant: 14),
            location.trailingAnchor.constraint(equalTo: delete.leadingAnchor),
            
            attendance.topAnchor.constraint(equalTo: coursename.topAnchor),
            attendance.trailingAnchor.constraint(equalTo: delete.trailingAnchor, constant: -10),
            attendance.heightAnchor.constraint(equalToConstant: 14)
            
        ])
    }
    
//    @objc func deletepressed(){
//
//    }
    
//    @objc func editpressed(){
//
//    }
    
    
    
    func configure(oh: OH){
        
        if let datedata = oh.day{
            date.text = datedata
        }
        else{
            date.text = "Date not available"
        }
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
    
        if let ohlocation = oh.location{
            location.text = ohlocation
        }
        else{
            location.text = "Location not available"
        }
        
        if let ohcode = oh.course?.code{
            coursename.text = "\(ohcode)"
        }
        else{
            coursename.text = "Course name not available"
        }
        
    }

}
