//
//  CarManager.swift
//  Carangas
//
//  Created by Usuário Convidado on 14/04/18.
//  Copyright © 2018 Eric Brito. All rights reserved.
//

import UIKit

class CarManager: REST {
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    class func saveCar(_ car: Car, onComplete: @escaping(Any) -> Void, onError: @escaping(CarError) -> Void) {
        let urlString = basePath + "/" + "\(car._id ?? "")"
        applyOperation(url: urlString, body: car, operation: .save, onComplete: onComplete, onError: onError)
    }
    
    class func updateCar(_ car: Car, onComplete: @escaping(Any) -> Void, onError: @escaping(CarError) -> Void) {
        let urlString = basePath + "/" + "\(car._id ?? "")"
        applyOperation(url: urlString, body: car, operation: .update, onComplete: onComplete, onError: onError)
    }
    
    class func deleteCar(_ car: Car, onComplete: @escaping(Any) -> Void, onError: @escaping(CarError) -> Void) {
        let urlString = basePath + "/" + "\(car._id ?? "")"
        applyOperation(url: urlString, body: car, operation: .delete, onComplete: onComplete, onError: onError)
    }
    
    class func getCars(onComplete: @escaping([Car]) -> Void, onError: @escaping(CarError) -> Void) {
        applyOperation(url: basePath, body: nil, operation: RESTOperation.get, onComplete: { (jsonData) in
            do {
                let cars = try JSONDecoder().decode([Car].self, from: jsonData)
                onComplete(cars)
            }
            catch {
                onError(.invalidJSON)
            }
        }, onError: onError)
    }
}
