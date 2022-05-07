//
//  TAEditView.swift
//  Hackathon2022
//
//  Created by Joanna Lin on 4/26/22.
//

import UIKit

class TAEditView: UIViewController {
    
    
    var editorcreate = " "
    var t: String = " "
    var parentController: TAMVProtocol?

    var originaloh: OH?{
        didSet{
            if let name = originaloh?.course?.code{
                coursefield.text = name
            }
            else{
                coursefield.text = ""
            }
            dowfield.text = originaloh?.day
            hrfield1.text = originaloh?.start_time
            hrfield2.text = originaloh?.end_time
            locationfield.text = originaloh?.location
            
        }
    }
    
    var titlelabel: UILabel = {
        let label = UILabel()
        label.text = "Edit/Create OH"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    var courselabel: UILabel = {
        let label = UILabel()
        label.text = "Course: "
//        label.font = UIFont (name: "SFPro-Medium", size: 14)
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.frame = CGRect(x: 0, y: 0, width: 55, height: 17)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var dowlabel: UILabel = {
        let label = UILabel()
        label.text = "Day: "
//        label.font = UIFont (name: "SFPro-Medium", size: 14)
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.frame = CGRect(x: 0, y: 0, width: 37, height: 17)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var hrlabel: UILabel = {
        let label = UILabel()
        label.text = "Time: "
//        label.font = UIFont (name: "SFPro-Medium", size: 14)
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.frame = CGRect(x: 0, y: 0, width: 39, height: 17)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var colon: UILabel = {
        let label = UILabel()
        label.text = ":"
//        label.font = UIFont (name: "SFPro-Medium", size: 14)
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.frame = CGRect(x: 0, y: 0, width: 4, height: 14)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var locationlabel: UILabel = {
        let label = UILabel()
        label.text = "Location: "
//        label.font = UIFont (name: "SFPro-Medium", size: 14)
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.frame = CGRect(x: 0, y: 0, width: 64, height: 17)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var coursefield: UITextField = {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 113, height: 29)
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
//        tf.font = UIFont(name: "SFPro-Regular", size: 12)
        tf.font = .systemFont(ofSize: 12, weight: .regular)
        tf.textAlignment = .justified
        tf.textColor = .black
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    var dowfield: UITextField = {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 113, height: 29)
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        tf.placeholder = "Monday"
//        tf.font = UIFont(name: "SFPro-Regular", size: 12)
        tf.font = .systemFont(ofSize: 12, weight: .regular)
        tf.textAlignment = .justified
        tf.textColor = .black
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    var hrfield1: UITextField = {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 64, height: 29)
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        tf.placeholder = "HH:MM"
//        tf.font = UIFont(name: "SFPro-Regular", size: 12)
        tf.font = .systemFont(ofSize: 12, weight: .regular)
        tf.textAlignment = .justified
        tf.textColor = .black
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    var hrfield2: UITextField = {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 64, height: 29)
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        tf.placeholder = "HH:MM"
//        tf.font = UIFont(name: "SFPro-Regular", size: 12)
        tf.font = .systemFont(ofSize: 12, weight: .regular)
        tf.textAlignment = .justified
        tf.textColor = .black
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    var locationfield: UITextField = {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 300, height: 29)
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        tf.placeholder = "Enter OH location"
//        tf.font = UIFont(name: "SFPro-Regular", size: 12)
        tf.font = .systemFont(ofSize: 12, weight: .regular)
        tf.textAlignment = .justified
        tf.textColor = .black
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    var savebutton: UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(savepressed), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0, green: 0.58, blue: 1, alpha: 1)
        button.frame = CGRect(x: 0, y: 0, width: 73, height: 34)
        button.layer.cornerRadius = 5
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 14)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
    }()
    
    @objc func savepressed(){
        
        parentController?.save(id: originaloh?.id ?? -100, coursename: coursefield.text ?? "", dayofweek: dowfield.text ?? "", starthr: hrfield1.text ?? "... - ", endhr: hrfield2.text ?? " - ...", location: locationfield.text ?? "")
        
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        editorcreate = " "
        t = "\(editorcreate) OH"
        [titlelabel, courselabel, coursefield, dowlabel, hrlabel, colon, dowfield, hrfield1, hrfield2, locationlabel, locationfield, savebutton].forEach { views in
            views.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(views)
        }
        
        setupconstraints()
        // Do any additional setup after loading the view.
    }
    
    func setupconstraints(){
        NSLayoutConstraint.activate([
            titlelabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titlelabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            titlelabel.widthAnchor.constraint(equalToConstant: 100),
            titlelabel.heightAnchor.constraint(equalToConstant: 24),
            
            courselabel.topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 55),
            courselabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 37),
            courselabel.heightAnchor.constraint(equalToConstant: 17),
            courselabel.widthAnchor.constraint(equalToConstant: 55),

            coursefield.leadingAnchor.constraint(equalTo: courselabel.leadingAnchor),
            coursefield.topAnchor.constraint(equalTo: courselabel.bottomAnchor, constant: 10),
            coursefield.heightAnchor.constraint(equalToConstant: 29),
            coursefield.widthAnchor.constraint(equalToConstant: 113),

            dowlabel.topAnchor.constraint(equalTo: coursefield.bottomAnchor, constant: 20),
            dowlabel.leadingAnchor.constraint(equalTo: courselabel.leadingAnchor),
            dowlabel.heightAnchor.constraint(equalToConstant: 17),
//            dowlabel.widthAnchor.constraint(equalToConstant: 37),
            
            dowfield.leadingAnchor.constraint(equalTo: courselabel.leadingAnchor),
            dowfield.topAnchor.constraint(equalTo: dowlabel.bottomAnchor, constant: 10),
            dowfield.heightAnchor.constraint(equalToConstant: 29),
            dowfield.widthAnchor.constraint(equalToConstant: 113),
            
            hrlabel.leadingAnchor.constraint(equalTo: courselabel.leadingAnchor),
            hrlabel.topAnchor.constraint(equalTo: dowfield.bottomAnchor, constant: 20),
            hrlabel.heightAnchor.constraint(equalToConstant: 17),
//            hrlabel.widthAnchor.constraint(equalToConstant: 39),
            
            hrfield1.leadingAnchor.constraint(equalTo: courselabel.leadingAnchor),
            hrfield1.topAnchor.constraint(equalTo: hrlabel.bottomAnchor, constant: 10),
            hrfield1.heightAnchor.constraint(equalToConstant: 29),
            hrfield1.widthAnchor.constraint(equalToConstant: 64),
            
            colon.leadingAnchor.constraint(equalTo: hrfield1.trailingAnchor, constant: 10),
            colon.topAnchor.constraint(equalTo: hrfield1.topAnchor),
            colon.heightAnchor.constraint(equalToConstant: 14),
            colon.widthAnchor.constraint(equalToConstant: 4),
            
            hrfield2.leadingAnchor.constraint(equalTo: colon.trailingAnchor, constant: 10),
            hrfield2.topAnchor.constraint(equalTo: hrfield1.topAnchor),
            hrfield2.heightAnchor.constraint(equalToConstant: 29),
            hrfield2.widthAnchor.constraint(equalToConstant: 64),
            
            locationlabel.leadingAnchor.constraint(equalTo: courselabel.leadingAnchor),
            locationlabel.topAnchor.constraint(equalTo: hrfield1.bottomAnchor, constant: 20),
            locationlabel.heightAnchor.constraint(equalToConstant: 17),
//            locationlabel.widthAnchor.constraint(equalToConstant: 64),
            
            locationfield.leadingAnchor.constraint(equalTo: coursefield.leadingAnchor),
            locationfield.topAnchor.constraint(equalTo: locationlabel.bottomAnchor, constant: 10),
            locationfield.heightAnchor.constraint(equalToConstant: 29),
            locationfield.widthAnchor.constraint(equalToConstant: 300),
            
            savebutton.trailingAnchor.constraint(equalTo: locationfield.trailingAnchor),
            savebutton.topAnchor.constraint(equalTo: locationfield.bottomAnchor, constant: 50),
            savebutton.heightAnchor.constraint(equalToConstant: 34),
            savebutton.widthAnchor.constraint(equalToConstant: 73)
            
            
            
        
        ])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
