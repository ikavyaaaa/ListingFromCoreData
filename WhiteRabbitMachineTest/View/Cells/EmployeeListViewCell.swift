//
//  EmployeeListViewCell.swift
//  WhiteRabbitMachineTest
//
//  Created by Kavya on 08/08/22.
//

import Foundation
import UIKit


class EmployeeListViewCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var lblProfileCompany: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIDecoration()
    }
    
    private func UIDecoration() {
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
        imgProfile.layer.borderWidth = 3.0
        imgProfile.layer.borderColor = UIColor.orange.withAlphaComponent(0.5).cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
