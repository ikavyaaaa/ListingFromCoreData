//
//  DetailView.swift
//  WhiteRabbitMachineTest
//
//  Created by Kavya on 08/08/22.
//

import Foundation
import UIKit


class DetailView: UIViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblEMPDetails: UILabel!
    
    var employeeDetail: EmployeeDatabaseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDecoration()
    }
    
    private func UIDecoration() {
        view.addStatusCustomBar()
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
        imgProfile.layer.borderColor = UIColor.orange.cgColor
        imgProfile.layer.borderWidth = 5.0
        if let profileImage = URL(string: employeeDetail.profileimage) {
            imgProfile.kf.setImage(with: profileImage)
        }
        lblEMPDetails.text = "Name : \(employeeDetail.name)\nUsername : \(employeeDetail.username)\nEmail Address : \(employeeDetail.street) \(employeeDetail.suite) \(employeeDetail.city) \(employeeDetail.zipcode)\nPhone : \(employeeDetail.phone ?? "NIL")\nWebsite : \(employeeDetail.website ?? "NIL")\nCompany : \(employeeDetail.companyname)"
    }
    
}
