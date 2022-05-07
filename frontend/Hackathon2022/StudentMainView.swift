//
//  StudentMainView.swift
//  Hackathon2022
//
//  Created by Joanna Lin on 4/26/22.
//

import UIKit

class StudentMainView: UIViewController {

    var parentController: LIVProtocol?
    let filterreuse = "FilterReuse"
    var studentid: Int = 0
    var flag: Int = 0
    var hardcode: Int = 0
    
    var ohs: [OH] = []
    var attending: [OH] = []
    
    init(id: Int){
        super.init(nibName:nil, bundle:nil)
        
        self.studentid = id
        
        refreshdata()
        NetworkManager.getOHs(id: studentid){ ohs in
            self.attending = ohs.office_hours ?? []
        }
        //TODO: get office hours that the students are already attending
    }
    
    init(){
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var colView = UICollectionView(frame: .zero, collectionViewLayout: {
       let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }())
    
    lazy var ohtable: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StudentViewOH.self, forCellReuseIdentifier: StudentViewOH.id)
        tableView.isScrollEnabled = true
        tableView.allowsMultipleSelection = true
        return tableView
    }()
    
    var logout: UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(logoutpressed), for: .touchUpInside)
        button.setTitleColor(UIColor(red: 1, green: 0, blue: 0, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.setTitle("Log out", for: .normal)
//        button.titleLabel?.font = UIFont(name: "SFPro-Regular", size: 16)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.titleLabel?.frame = CGRect(x: 0, y: 0, width: 58, height: 19)
        return button
    }()
    
    var coursenamelabel: UILabel = {
        let label = UILabel()
        label.text = "Course Name: "
//        label.font = UIFont (name: "SFPro-Regular", size: 16)
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.frame = CGRect(x: 0, y: 0, width: 150, height: 15)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var courseinput: UITextField = {
       let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 67, height: 24)
        tf.layer.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor
        tf.placeholder = "CS 1998"
        tf.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.textAlignment = .center
//        tf.font = UIFont(name: "SFPro-Regular", size: 10)
        tf.font = .systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    var notes: UILabel = {
       let label = UILabel()
        label.text = "*enter department name and 4 digits class number"
        label.frame = CGRect(x: 0, y: 0, width: 191, height: 10)
        label.textColor = .black
//        label.font = UIFont(name: "SFPro-LightItalic", size: 8)
//        label.font = .systemFont(ofSize: 8, weight: .light)
        label.font = .italicSystemFont(ofSize: 10)
        return label
    }()
    
    var errornotes: UILabel = {
       let label = UILabel()
        label.text = "*error: course not found, please type in the correct format"
        label.frame = CGRect(x: 0, y: 0, width: 191, height: 10)
        label.textColor = .red
//        label.font = UIFont(name: "SFPro-LightItalic", size: 8)
//        label.font = .systemFont(ofSize: 8, weight: .light)
        label.font = .italicSystemFont(ofSize: 10)
        return label
    }()
    
    var search: UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(searchpressed), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        button.setTitle("Search", for: .normal)
//        button.titleLabel?.font = UIFont(name: "SFPro-Regular", size: 16)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
//        button.titleLabel?.frame = CGRect(x: 0, y: 0, width: 33, height: 12)
        button.layer.cornerRadius = 12.5
        return button
    }()
    
    var timelabels: [Time] = []
    var filteredtime: [Time] = []
    var filteredohs: [OH] = []
    var sectionedOH: [[OH]] = [[], [], [], [], [], [], []]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        colView.dataSource = self
        colView.delegate = self
        colView.allowsMultipleSelection = true
        colView.register(StudentOHFilter.self, forCellWithReuseIdentifier: filterreuse)
        
        [colView, ohtable, logout, coursenamelabel, courseinput, notes, search].forEach { views in
            views.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(views)
        }
        
        errornotes.translatesAutoresizingMaskIntoConstraints = false
        
        
        timelabels = [Time(timeDoW: .mon), Time(timeDoW: .tue), Time(timeDoW: .wed), Time(timeDoW: .thu), Time(timeDoW: .fri), Time(timeDoW: .sat), Time(timeDoW: .sun)]
        filteredohs = ohs
        filteredtime = timelabels
        

        
        
        setupconstraints()
        // Do any additional setup after loading the view.
    }
    
    @objc func logoutpressed(){
        ohs = []
        filteredohs = []
        navigationController?.popViewController(animated: true)
    }
    
    @objc func searchpressed(){
        
        if let wish = courseinput.text{
                          
            NetworkManager.getOHsfromCourse(coursecode: wish){ office in
                
                
//                self.ohs = office.office_hours ?? []
                self.filteredohs = office.office_hours ?? []
                self.sortoh()
                self.colView.reloadData()
                self.ohtable.reloadData()
            }
        }
        //TODO: enroll courses, add the error stuff
        else{
            view.willRemoveSubview(notes)
            errornotes.topAnchor.constraint(equalTo: courseinput.bottomAnchor, constant: 8).isActive = true
            errornotes.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31).isActive = true
    //            errornotes.widthAnchor.constraint(equalToConstant: 250),
            errornotes.heightAnchor.constraint(equalToConstant: 10).isActive = true
            view.addSubview(errornotes)
        }
        
        
    }
    
    func sortoh(){
        sectionedOH = [[], [], [], [], [], [], []]
        var x = 0
        filteredohs.forEach { ohdata in
            switch ohdata.day?.lowercased(){
            case "monday":
                sectionedOH[0].append(ohdata)
            case "tuesday":
                sectionedOH[1].append(ohdata)
            case "wednesday":
                sectionedOH[2].append(ohdata)
            case "thursday":
                sectionedOH[3].append(ohdata)
            case "friday":
                sectionedOH[4].append(ohdata)
            case "saturday":
                sectionedOH[5].append(ohdata)
            case "sunday":
                sectionedOH[6].append(ohdata)
            default:
                print("non-existent")
            
                
            }
        }
    }
    
    func refreshdata(){
        NetworkManager.getAllOHs { ohdata in
            self.ohs = ohdata.office_hours ?? []
            
            
            self.filteredohs = self.ohs
            self.sortoh()
            self.ohtable.reloadData()
//            self.refreshControl.endRefreshing()
        }
    }
    
    func setupconstraints(){
        NSLayoutConstraint.activate([
            
            logout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -17),
            logout.trailingAnchor.constraint(equalTo: ohtable.trailingAnchor),
            logout.heightAnchor.constraint(equalToConstant: 50),
            logout.widthAnchor.constraint(equalToConstant: 100),
            
            coursenamelabel.topAnchor.constraint(equalTo: logout.bottomAnchor, constant: 5),
            coursenamelabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31),
            coursenamelabel.heightAnchor.constraint(equalToConstant: 13),
            coursenamelabel.widthAnchor.constraint(equalToConstant: 150),
            
            courseinput.topAnchor.constraint(equalTo: coursenamelabel.bottomAnchor, constant: 15),
            courseinput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31),
            courseinput.heightAnchor.constraint(equalToConstant: 30),
            courseinput.widthAnchor.constraint(equalToConstant: 80),
            
            notes.topAnchor.constraint(equalTo: courseinput.bottomAnchor, constant: 8),
            notes.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31),
//            notes.widthAnchor.constraint(equalToConstant: 250),
            notes.heightAnchor.constraint(equalToConstant: 10),
            
            colView.topAnchor.constraint(equalTo: notes.bottomAnchor, constant: 14),
//            colView.widthAnchor.constraint(equalToConstant: 343),
            colView.heightAnchor.constraint(equalToConstant: 50),
            colView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31),
            colView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            

            ohtable.topAnchor.constraint(equalTo: colView.bottomAnchor, constant: 20),
            ohtable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ohtable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            ohtable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            search.topAnchor.constraint(equalTo: courseinput.topAnchor, constant: 2.5),
            search.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 275),
            search.heightAnchor.constraint(equalToConstant: 25),
            search.widthAnchor.constraint(equalToConstant: 75),
            
//            errornotes.topAnchor.constraint(equalTo: courseinput.bottomAnchor, constant: 8),
//            errornotes.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31),
////            errornotes.widthAnchor.constraint(equalToConstant: 250),
//            errornotes.heightAnchor.constraint(equalToConstant: 10),
            
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
extension StudentMainView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionedOH.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Monday"
        case 1:
            return "Tuesday"
        case 2:
            return "Wednesday"
        case 3:
            return "Thursday"
        case 4:
            return "Friday"
        case 5:
            return "Saturday"
        case 6:
            return "Sunday"
        default:
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionedOH[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection
                   section: Int) -> String? {
        return " "
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: StudentViewOH.id, for: indexPath) as? StudentViewOH {
            let i = sectionedOH[indexPath.section][indexPath.row]
            cell.configure(oh: i)
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 5
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}




extension StudentMainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let checkmark: UIImageView = {
               let image = UIImageView()
                image.image = UIImage(named: "Checkmark")
                image.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
                return image
            }()
            
            let chosen = ohs[indexPath.row]
            NetworkManager.addAttendance(id: chosen.id){ attendance in
                //TODO: Fix
            }
            
            cell.backgroundColor = UIColor(red: 0.169, green: 0.7, blue: 0.19, alpha: 0.3)
            checkmark.translatesAutoresizingMaskIntoConstraints = false
            
            cell.addSubview(checkmark)
            
            checkmark.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            checkmark.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 280).isActive = true
            checkmark.heightAnchor.constraint(equalToConstant: 24).isActive = true
            checkmark.widthAnchor.constraint(equalToConstant: 24).isActive = true
            
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundColor = .white
            cell.subviews.last?.removeFromSuperview()

            NetworkManager.deleteAttendance(id: filteredohs[indexPath.row].id){ _ in
            }
    }
    
    }
    
}
    
    extension StudentMainView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//            return CGSize(width: preferredContentSize.width, height: 31)
//            }
        
        func collectionView(_ collectionView: UICollectionView,
                            didSelectItemAt indexPath: IndexPath) {
            let chosen = timelabels[indexPath.row]
            
            if (flag == 0){
                filteredtime = []
                filteredohs = []
            }
            
            filteredtime.append(chosen)
            self.flag = flag + 1
            chosen.active = true
            
            NetworkManager.getOHsFromDay(day: chosen.getdowfull()){ ohdata in
                ohdata.office_hours?.forEach({ oh in
                    self.filteredohs.append(oh)
                    self.sortoh()
                    self.ohtable.reloadData()
                })
            }
        

            
        }
        
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: 50, height: 50)
    //    }
    //
        func collectionView(_ collectionView: UICollectionView,
                            didDeselectItemAt indexPath: IndexPath) {
            
            let chosen = timelabels[indexPath.row]
            
            self.flag = self.flag - 1
            chosen.active = false
            
            if (flag == 0){
                filteredohs = ohs
                filteredtime = timelabels
                sortoh()
                ohtable.reloadData()
            }
            else {
                filteredohs = []
                filteredtime = []
                timelabels.forEach { time in
                    if (time.active){
                        self.filteredtime.append(time)
                }
                }
                self.filteredtime.forEach { time in
                    NetworkManager.getOHsFromDay(day: time.getdowfull()){ ohdata in
                        ohdata.office_hours?.forEach({ oh in
                            self.filteredohs.append(oh)
                        })
                        self.sortoh()
                        self.ohtable.reloadData()
                        
                }
     
                    
            }
                
                
            }
            

          
        }

    }


    extension StudentMainView: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return timelabels.count
        }
                
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterreuse, for: indexPath) as! StudentOHFilter
            let i = timelabels[indexPath.row]
            cell.configure(time: i)
            cell.heightAnchor.constraint(equalToConstant: 31).isActive = true
            return cell
        }
}
