//
//  LogInView.swift
//  Hackathon2022
//
//  Created by Joanna Lin on 4/26/22.
//

import UIKit

protocol LIVProtocol{
    
}

class LogInView: UIViewController, LIVProtocol {

    var welcome: UILabel = {
        let label = UILabel()
        label.text = "Welcome to 4OH !"
        label.textAlignment = .center
//        label.font = UIFont (name: "SFPro-Medium", size: 24)
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.frame = CGRect(x: 0, y: 0, width: 252.29, height: 29)
        return label
    }()
    
    var subwelcome: UILabel = {
        let label = UILabel()
        label.text = "Please log in below to track your office hour"
        label.textAlignment = .center
//        label.font = UIFont (name: "SFPro-Regular", size: 12)
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.frame = CGRect(x: 0, y: 0, width: 307, height: 14)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var email: UILabel = {
        let label = UILabel()
        label.text = "Email: "
//        label.font = UIFont (name: "SFPro-Regular", size: 16)
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.frame = CGRect(x: 0, y: 0, width: 46.61, height: 19)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var password: UILabel = {
        let label = UILabel()
        label.text = "Password: "
//        label.font = UIFont (name: "SFPro-Regular", size: 16)
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.frame = CGRect(x: 0, y: 0, width: 79.03, height: 19)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var emailinput: UITextField = {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 307, height: 41)
        tf.layer.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()
    
    var passwordinput: UITextField = {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 307, height: 41)
        tf.layer.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()
    
    var taloginbutton: UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(talogin), for: .touchUpInside)
        button.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.setTitle("Log in as TA", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.titleLabel?.frame = CGRect(x: 0, y: 0, width: 133.74, height: 19)
        button.frame = CGRect(x: 0, y: 0, width: 183.39, height: 39)
        button.layer.borderColor = UIColor(red: 0, green: 0.58, blue: 1, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 19.5
        return button
    }()
    
    var studentloginbutton: UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(studentlogin), for: .touchUpInside)
        button.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.setTitle("Log in as Student", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.titleLabel?.frame = CGRect(x: 0, y: 0, width: 133.74, height: 19)
        button.frame = CGRect(x: 0, y: 0, width: 183.39, height: 39)
        button.layer.borderColor = UIColor(red: 0, green: 0.58, blue: 1, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 19.5
        return button
    }()
    
    var emptyfields: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "Please enter all required fields"
        label.font = .systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    var wronginputs: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "Wrong email or password"
        label.font = .systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    var wronglogin: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "Please use the other login"
        label.font = .systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    var logo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Image")
        image.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [password, subwelcome, email, logo, passwordinput, welcome, emailinput, taloginbutton, studentloginbutton].forEach { views in
            views.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(views)
        }
        wronginputs.translatesAutoresizingMaskIntoConstraints = false
        wronglogin.translatesAutoresizingMaskIntoConstraints = false
        emptyfields.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        setupconstraints()

        // Do any additional setup after loading the view.
    }
    
    func setupconstraints(){
        NSLayoutConstraint.activate([
        
            welcome.topAnchor.constraint(equalTo: view.topAnchor, constant: 204),
            welcome.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcome.widthAnchor.constraint(equalToConstant: 252.29),
            welcome.heightAnchor.constraint(equalToConstant: 29),
            
            subwelcome.topAnchor.constraint(equalTo: welcome.bottomAnchor, constant: 12),
            subwelcome.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            email.topAnchor.constraint(equalTo: subwelcome.bottomAnchor, constant: 55),
            email.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            
            emailinput.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10),
            emailinput.leadingAnchor.constraint(equalTo: email.leadingAnchor),
            emailinput.widthAnchor.constraint(equalToConstant: 307),
            emailinput.heightAnchor.constraint(equalToConstant: 41),
            
            password.topAnchor.constraint(equalTo: emailinput.bottomAnchor, constant: 20),
            password.leadingAnchor.constraint(equalTo: email.leadingAnchor),
            
            passwordinput.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 10),
            passwordinput.leadingAnchor.constraint(equalTo: email.leadingAnchor),
            passwordinput.widthAnchor.constraint(equalToConstant: 307),
            passwordinput.heightAnchor.constraint(equalToConstant: 41),
            
            taloginbutton.topAnchor.constraint(equalTo: passwordinput.bottomAnchor, constant: 50),
            taloginbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taloginbutton.widthAnchor.constraint(equalToConstant: 184),
            taloginbutton.heightAnchor.constraint(equalToConstant: 39),
            
            studentloginbutton.topAnchor.constraint(equalTo: taloginbutton.bottomAnchor, constant: 10),
            studentloginbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            studentloginbutton.widthAnchor.constraint(equalToConstant: 184),
            studentloginbutton.heightAnchor.constraint(equalToConstant: 39),
            
            logo.bottomAnchor.constraint(equalTo: welcome.topAnchor, constant: -15),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 70),
            logo.widthAnchor.constraint(equalToConstant: 70)
            
        ])
    }

    
    @objc func talogin(){
        if view.subviews.contains(wronginputs){
            view.willRemoveSubview(wronginputs)
        }
        if view.subviews.contains(wronglogin){
            view.willRemoveSubview(wronglogin)
        }
        if view.subviews.contains(emptyfields){
            view.willRemoveSubview(emptyfields)
        }
        if let username = emailinput.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = passwordinput.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            LoginManager.getUser(email: username, password: password){ success, user in
                if (success){
                    let editor = TAMainView(id: user!.id)
                    editor.parentController? = self
                    self.navigationController?.pushViewController(editor, animated: true)
                }
                else{
                    print("Haha")
//                    self.wronginputs.translatesAutoresizingMaskIntoConstraints = false
//                    self.wronginputs.topAnchor.constraint(equalTo: self.passwordinput.bottomAnchor, constant: 20).isActive = true
//                    self.wronginputs.trailingAnchor.constraint(equalTo: self.passwordinput.trailingAnchor).isActive = true
//                    self.view.addSubview(self.wronginputs)
                }
                
            }
        }
        else{
//            self.emptyfields.translatesAutoresizingMaskIntoConstraints = false
//            self.emptyfields.topAnchor.constraint(equalTo: self.passwordinput.bottomAnchor, constant: 20).isActive = true
//            self.emptyfields.trailingAnchor.constraint(equalTo: self.passwordinput.trailingAnchor).isActive = true
//            self.view.addSubview(self.emptyfields)
        }
        
        
    }
    
    @objc func studentlogin(){
        if view.subviews.contains(wronginputs){
            view.willRemoveSubview(wronginputs)
        }
        if view.subviews.contains(wronglogin){
            view.willRemoveSubview(wronglogin)
        }
        if view.subviews.contains(emptyfields){
            view.willRemoveSubview(emptyfields)
        }
        if let username = emailinput.text, let password = passwordinput.text{
            LoginManager.getUser(email: username, password: password){ success, user in
                if success{
                    let editor = StudentMainView(id: user?.id ?? 0)
                    editor.parentController? = self
                    self.navigationController?.pushViewController(editor, animated: true)
                }
                else{
                print("Incorrect email or password")
//                self.wronginputs.topAnchor.constraint(equalTo: self.passwordinput.bottomAnchor, constant: 20).isActive = true
//                self.wronginputs.trailingAnchor.constraint(equalTo: self.passwordinput.trailingAnchor).isActive = true
//                self.view.addSubview(self.wronginputs)
            
            }
        }
        }
            else{
                print("Please enter the required field")
//                self.emptyfields.topAnchor.constraint(equalTo: self.passwordinput.bottomAnchor, constant: 20).isActive = true
//                self.emptyfields.trailingAnchor.constraint(equalTo: self.passwordinput.trailingAnchor).isActive = true
//                self.view.addSubview(self.emptyfields)
            }
        
        
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

