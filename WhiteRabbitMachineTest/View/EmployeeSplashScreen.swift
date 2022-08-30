//
//  EmployeeSplashScreen.swift
//  WhiteRabbitMachineTest
//
//  Created by Kavya on 08/08/22.
//

import Foundation
import UIKit


class EmployeeSplashScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didEndSplash()
    }
    
    private func didEndSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let employeeListView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmployeeListView") as! EmployeeListView
            self.navigationController?.pushViewController(employeeListView, animated: true)
        }
    }
    
}
