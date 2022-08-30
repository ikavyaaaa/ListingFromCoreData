//
//  CoreDataHandler.swift
//  WhiteRabbitMachineTest
//
//  Created by Rahul P John on 08/08/22.
//

import Foundation
import CoreData

class CoreDataHandler {
    
    static let sharedDatabase = CoreDataHandler()
    func saveData<T: Codable, E: NSManagedObject>(data: T, dataBase: E) {
        let data = data as! EmployeeModel
    }
    
}
