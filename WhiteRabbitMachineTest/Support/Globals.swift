//
//  Globals.swift
//  WhiteRabbitMachineTest
//
//  Created by Kavya on 08/08/22.
//

import Foundation
import UIKit

extension UIView {
    
    func addStatusCustomBar() {
        let newStatusBar = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.size.height))
        newStatusBar.backgroundColor = UIColor.orange
        self.addSubview(newStatusBar)
    }
    
}
