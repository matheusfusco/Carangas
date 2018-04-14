//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Eric Brito.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    var car: Car!
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if car != nil {
            tfName.text = self.car.name
            tfBrand.text = self.car.brand
            tfPrice.text = "\(self.car.price)"
            scGasType.selectedSegmentIndex = self.car.gasType
        }
    }
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        sender.isEnabled = false
        sender.alpha = 0.5
        sender.backgroundColor = .gray
        
        if car == nil {
            car = Car()
        }
        car.brand = tfBrand.text!
        car.name = tfName.text!
        car.gasType = scGasType.selectedSegmentIndex
        car.price = Double(tfPrice.text!)!
        
        if car._id == nil {
            CarManager.saveCar(car, onComplete: { (any) in
                //sucesso cadastro
                self.goBack()
            }, onError: { (error) in
                //erro
            })
        }
        else {
            CarManager.updateCar(car, onComplete: { (any) in
                //sucesso atualizacao
                self.goBack()
            }, onError: { (error) in
                //erro
            })
        }
    }
    
    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }

}
