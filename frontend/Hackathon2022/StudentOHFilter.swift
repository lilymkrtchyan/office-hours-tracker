//
//  StudentOHFilter.swift
//  Hackathon2022
//
//  Created by Joanna Lin on 4/26/22.
//

import UIKit

class StudentOHFilter: UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = UIColor(red: 0, green: 0.58, blue: 1, alpha: 0.3)
                layer.borderColor = UIColor(red: 0, green: 0.58, blue: 1, alpha: 1).cgColor
                timelabel.textColor = UIColor(red: 0, green: 0.58, blue: 1, alpha: 1)
            } else {
                backgroundColor = .white
                layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
                layer.borderWidth = 1
                timelabel.textColor = .black
            }
        }
    }
    
    
    var timelabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = false
//        label.frame = CGRect(x: 0, y: 0, width: 66, height: 14)
        return label
    }()
    
//    var coursedropdown
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        layer.borderWidth = 1
        backgroundColor = .white
//
//
//
        timelabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timelabel)
        NSLayoutConstraint.activate([
            timelabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            timelabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            timelabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            timelabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            timelabel.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    func configure(time: Time){
        timelabel.text = time.getdow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
