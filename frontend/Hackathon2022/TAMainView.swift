//
//  TAMainView.swift
//  Hackathon2022
//
//  Created by Joanna Lin on 4/26/22.
//

import UIKit

protocol TAMVProtocol{
    func viewDidLoad()
    func save(id: Int, coursename: String, dayofweek: String, starthr: String, endhr: String, location: String)
}

class TAMainView: UIViewController, TAMVProtocol {
   
    
    var taid: Int = 0
    var ohs: [OH] = []
    var chosen = -1
    var parentController: LIVProtocol?
    
    init(id: Int){
        super.init(nibName:nil, bundle:nil)
        self.taid = id
        
        NetworkManager.getOHs(id: id){ ohdata in
            ohdata.office_hours?.forEach({ oh in
                self.ohs.append(oh)
            })
            self.ohtable.reloadData()
        }
        
        
    }
    
    init(){
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var ohtable: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TAViewOH.self, forCellReuseIdentifier: TAViewOH.id)
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    var logout: UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(logoutpressed), for: .touchUpInside)
        button.setTitleColor(UIColor(red: 1, green: 0, blue: 0, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.setTitle("Log out", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.titleLabel?.frame = CGRect(x: 0, y: 0, width: 58, height: 19)
        return button
    }()
    
    var yourOHs: UILabel = {
        let label = UILabel()
        label.text = "Your Current OH"
//        label.font = UIFont (name: "SFPro-Medium", size: 20)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.frame = CGRect(x: 0, y: 0, width: 162, height: 24)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var createOHbutton: UIButton = {
        let button = UIButton()
         button.addTarget(self, action: #selector(createohpressed), for: .touchUpInside)
         button.backgroundColor = UIColor(red: 0, green: 0.58, blue: 1, alpha: 1)
         button.frame = CGRect(x: 0, y: 0, width: 102, height: 27)
         button.layer.cornerRadius = 15
         button.setTitle("+ Create OH", for: .normal)
         button.setTitleColor(.white, for: .normal)
         button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
         return button
    }()
    
    @objc func logoutpressed(){
        ohs = []
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        


        [ohtable, yourOHs, logout, createOHbutton].forEach { views in
            views.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(views)
        }
        setupconstraints()
        

        
        // Do any additional setup after loading the view.
    }
    
//    func sortoh(){
//
//    }
    
    func setupconstraints(){
        
        NSLayoutConstraint.activate([
        
            yourOHs.topAnchor.constraint(equalTo: logout.bottomAnchor, constant: 50),
            yourOHs.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            yourOHs.heightAnchor.constraint(equalToConstant: 24),
            yourOHs.widthAnchor.constraint(equalToConstant: 162),
            
            createOHbutton.topAnchor.constraint(equalTo: yourOHs.bottomAnchor, constant: 59),
//            createOHbutton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 225),
            createOHbutton.heightAnchor.constraint(equalToConstant: 30),
            createOHbutton.widthAnchor.constraint(equalToConstant: 130),
            createOHbutton.trailingAnchor.constraint(equalTo: ohtable.trailingAnchor, constant: -30),
            
            logout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -17),
            logout.trailingAnchor.constraint(equalTo: createOHbutton.trailingAnchor),
            logout.heightAnchor.constraint(equalToConstant: 50),
            logout.widthAnchor.constraint(equalToConstant: 100),
            
            ohtable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            ohtable.topAnchor.constraint(equalTo: createOHbutton.bottomAnchor, constant: 30),
            ohtable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ohtable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20)
            
        ])
        
    }
    
    @objc func createohpressed(){
        chosen = -1
        let editor = TAEditView()
        editor.editorcreate = "Create"
        editor.parentController = self
        navigationController?.pushViewController(editor, animated: true)
    }
    
    
    
    func save(id: Int, coursename: String, dayofweek: String, starthr: String, endhr: String, location: String){

        var courseid: Int = 0
        NetworkManager.getCourseid(coursecode: coursename){ coursedata in
            courseid = coursedata.id

            
            if (self.chosen == -1){

                NetworkManager.createOH(taid: self.taid, courseid: courseid, dayofweek: dayofweek, start: starthr, end: endhr, location: location) { oh in
                    self.ohs.append(oh)
                    self.ohtable.reloadData()
                }
                
            }
            else {
                NetworkManager.updateOH(id: id, dayofweek: dayofweek, start: starthr, end: endhr, location: location){ updatedoh in
                    self.ohs[self.chosen] = updatedoh
                    self.chosen = -1
                    self.ohtable.reloadData()
                }
            }
        }
        
    }

}

    
    extension TAMainView: UITableViewDataSource {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ohs.count
        }


        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TAViewOH.id, for: indexPath) as? TAViewOH {

                let i = ohs[indexPath.row]
                cell.configure(oh: i)
                cell.edit.tag = indexPath.row
                cell.edit.addTarget(self, action: #selector(editpressed(_:)), for: .touchUpInside)
                cell.delete.tag = indexPath.row
                cell.delete.addTarget(self, action: #selector(deletepressed(_:)), for: .touchUpInside)
//                cell.delete.layer.borderWidth = 1
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                
                NetworkManager.getAttendance(id: i.id){ attend in
                    if let numattend = attend.attendance {
                    cell.attendance.text = "• \(numattend) going"
                    }
                }
//                cell.layer.borderWidth = 1
//                cell.layer.cornerRadius = 10
//                cell.layer.shadowOpacity = 0.1
                //TODO: add the blue border and fix the shadow
//                cell.layer.shadowColor = UIColor(red: 0.175, green: 0.175, blue: 0.175, alpha: 1).cgColor
//                cell.layer.shadowOffset = .zero
                
                return cell
            } else {
                return UITableViewCell()
            }
        }
        
        @objc func editpressed(_ sender: UIButton){
            let editor = TAEditView()
            editor.parentController = self
            editor.originaloh = ohs[sender.tag]
            self.chosen = sender.tag
            present(editor, animated: true, completion: nil)
        }
        
        @objc func deletepressed(_ sender: UIButton){
            let originaloh = ohs[sender.tag]
            NetworkManager.deleteOH(id: originaloh.id){ _ in
                
            }
            self.ohs.removeAll()
            NetworkManager.getOHs(id: self.taid){ ohdata in
                ohdata.office_hours?.forEach({ oh in
                    self.ohs.append(oh)
                })
                self.ohtable.reloadData()
            }
        }
    }




    extension TAMainView: UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
//            return UITableView.automaticDimension
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


