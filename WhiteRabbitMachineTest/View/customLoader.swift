//
//  customLoader.swift
//  WhiteRabbitMachineTest
//
//  Created by Kavya on 08/08/22.
//

import Foundation
import UIKit

class customLoader {
    
    static let sharedLoader = customLoader()
    private init() {}
    private let loaderMainView: UIView = {
        let loaderMainView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        loaderMainView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return loaderMainView
    }()
    
    lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(frame: CGRect(x: loaderMainView.center.x - 15.0, y: loaderMainView.center.y - 15.0, width: 30.0, height: 30.0))
        loader.tintColor = UIColor.white
        loader.startAnimating()
        return loader
    }()
    
    func showActivityIndicator(with controller: UIViewController) {
        loaderMainView.addSubview(loader)
        controller.view.addSubview(loaderMainView)
        controller.view.bringSubviewToFront(loader)
    }
    
    func hideActivityIndicator() {
        loader.stopAnimating()
        loaderMainView.removeFromSuperview()
    }
    
}
