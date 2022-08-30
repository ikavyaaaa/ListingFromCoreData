//
//  EmployeeViewModel.swift
//  WhiteRabbitMachineTest
//
//  Created by Kavya on 08/08/22.
//

import Foundation
import CoreData
import UIKit

class EmployeeViewModel {
    
    var employeeModel = [EmployeeModel]()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    init(){
        fetchEmployeeList()
    }
    
    func fetchEmployeeList() {
        let strURL = "http://www.mocky.io/v2/5d565297300000680030a986"
        Networking.sharedNetworking.getMethod(url: strURL) { [self] responseData, responseMessage in
            if let responseData = responseData {
                do {
                    employeeModel = try JSONDecoder().decode([EmployeeModel].self, from: responseData)
                    saveEmployeeToCoreData(data: responseData)
                } catch let err {
                    print(err)
                }
            } else {
                print(responseMessage)
            }
        }
    }
    
    func saveEmployeeToCoreData(data: Data) {
        deleteAllData()
        let employeeEntity = NSEntityDescription.insertNewObject(forEntityName: "EmployeeList", into: context!)
        employeeEntity.setValue(data, forKey: "empData")
        
        do {
            try context?.save()
            print("Saved Successfully")
            NotificationCenter.default.post(name: Notification.Name("reloadEmployeeList"), object: nil)
        } catch let err {
            print("Error while saving data with error: \(err.localizedDescription)")
        }
    }
    
    func deleteAllData() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeList")
        fetch.returnsObjectsAsFaults = false
        do {
            var employees = try context?.fetch(fetch) as! [EmployeeList]
            for data in employees {
                self.context!.delete(data)
            }
        } catch let err {
            print(err)
        }
    }
}
