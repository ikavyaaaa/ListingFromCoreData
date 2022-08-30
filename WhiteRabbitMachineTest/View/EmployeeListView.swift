//
//  ViewController.swift
//  WhiteRabbitMachineTest
//
//  Created by Kavya on 08/08/22.
//

import UIKit
import Kingfisher
import CoreData

class EmployeeListView: UIViewController {
    
    @IBOutlet weak var employeeListTableView: UITableView!
    @IBOutlet weak var searchToggleBackgroundView: UIView!
    @IBOutlet weak var searchToggleForegroundView: UIView!
    @IBOutlet weak var txtSearchEmployee: UITextField!
    
    var isSearchName = true
    
    var employeeViewModel = EmployeeViewModel()
    var employeeDatabaseModel = [EmployeeDatabaseModel]()
    var employeeDummyDatabaseModel = [EmployeeDatabaseModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDecoration()
    }
    
    private func UIDecoration() {
        searchToggleForegroundView.layer.cornerRadius = searchToggleForegroundView.frame.size.height / 2
        searchToggleBackgroundView.layer.cornerRadius = searchToggleBackgroundView.frame.size.height / 2
        searchToggleBackgroundView.layer.borderWidth = 2.0
        searchToggleBackgroundView.layer.borderColor = UIColor.orange.cgColor
        searchToggleForegroundView.backgroundColor = .white
        txtSearchEmployee.layer.cornerRadius = 5.0
        txtSearchEmployee.layer.borderColor = UIColor.orange.cgColor
        txtSearchEmployee.layer.borderWidth = 1.5
        txtSearchEmployee.layer.sublayerTransform = CATransform3DMakeTranslation(20.0, 0.0, 0.0)
        searchToggleForegroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didUpdateSearchToggle)))
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTabledata), name: Notification.Name("reloadEmployeeList"), object: nil)
        customLoader.sharedLoader.showActivityIndicator(with: self)
        if isSearchName {
            txtSearchEmployee.placeholder = "Search employee by name"
        } else {
            txtSearchEmployee.placeholder = "Search employee by email"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver("reloadEmployeeList")
    }
    
    @objc private func reloadTabledata() {
        customLoader.sharedLoader.hideActivityIndicator()
        self.view.addStatusCustomBar()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.orange
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        title = "Employee List"
        fetchEMPFromDatabase()
        customLoader.sharedLoader.hideActivityIndicator()
    }
    
    @objc private func didUpdateSearchToggle() {
        if isSearchName {
            searchToggleForegroundView.backgroundColor = UIColor.green
            txtSearchEmployee.placeholder = "Search employee by email"
            isSearchName = false
        } else {
            isSearchName = true
            txtSearchEmployee.placeholder = "Search employee by name"
            searchToggleForegroundView.backgroundColor = UIColor.white
        }
    }
    @IBAction func searchAction(_ sender: UITextField) {
        if sender.text != "" {
            if isSearchName {
                employeeDatabaseModel = employeeDummyDatabaseModel.filter({$0.name.uppercased().contains(sender.text!.uppercased())})
            } else {
                employeeDatabaseModel = employeeDummyDatabaseModel.filter({$0.email.uppercased().contains(sender.text!.uppercased())})
            }
        } else {
            employeeDatabaseModel = employeeDummyDatabaseModel
        }
        employeeListTableView.reloadData()
    }
}

//MARK: - Extending EmployeeListView to confirm tableview delegate and datasource

extension EmployeeListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeDatabaseModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeListViewCell", for: indexPath) as! EmployeeListViewCell
        cell.selectionStyle = .none
        let employeeData = employeeDatabaseModel[indexPath.row]
        if let profileImageURL = URL(string: employeeData.profileimage) {
            cell.imgProfile.kf.setImage(with: profileImageURL)
        }
        cell.lblProfileName.text = employeeData.name
        cell.lblProfileCompany.text = employeeData.companyname
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailView") as! DetailView
        detailVC.employeeDetail = employeeDatabaseModel[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0.0, y: cell.contentView.frame.size.height)
        UIView.animate(withDuration: 0.2, delay: 0.05 * CGFloat(indexPath.row)) {
            cell.transform = CGAffineTransform(translationX: cell.contentView.frame.size.width, y: cell.contentView.frame.size.height)
        }
    }
}


//MARK: - Extensing EmployeeListView to dismiss the keyboard

extension EmployeeListView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}


//MARK: - Extensing EmployeeListView to save data to coreData

extension EmployeeListView {
    
    func fetchEMPFromDatabase() {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeList")
        fetch.returnsObjectsAsFaults = false
        
        do {
            let employees = try context?.fetch(fetch) as! [EmployeeList]
            print(employees.count)
            let allData: [EmployeeModel] = try JSONDecoder().decode([EmployeeModel].self, from: employees[0].empData!)
            for employee in allData {
                employeeDummyDatabaseModel.append(EmployeeDatabaseModel(bs: employee.company?.bs ?? "", catchPhrase: employee.company?.catchPhrase ?? "", city: employee.address.city, companyname: employee.company?.name ?? "", email: employee.email, id: "\(employee.id)", lat: employee.address.geo.lat, lng: employee.address.geo.lng, name: employee.name, phone: employee.phone ?? "", profileimage: employee.profileImage ?? "", street: employee.address.street, suite: employee.address.suite, username: employee.username, website: employee.website ?? "", zipcode: employee.address.zipcode))
            }
            employeeDatabaseModel = employeeDummyDatabaseModel
            employeeListTableView.delegate = self
            employeeListTableView.dataSource = self
            employeeListTableView.reloadData()
        } catch let err {
            print(err)
        }
    }
    
}
