//
//  ParameterTableViewCell.swift
//  DeepLinker
//
//  Created by Hugo Bosc-Ducros on 24/03/2020.
//  Copyright © 2020 HBD. All rights reserved.
//

import UIKit
import HBAutocomplete

class ParameterTableViewCell: UITableViewCell, UITextFieldDelegate {

    enum ParameterType:String, CaseIterable {
        case text = "Text"
        case address = "Address"
        case date = "Date"
    }

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var typeControl: UIControl!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var type:ParameterType = .text
    //weak var presenter:UIViewController?
    weak var delegate:URLParameterDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.typeControl.layer.borderColor = UIColor.lightGray.cgColor
        self.typeControl.layer.borderWidth = 1
        self.typeControl.layer.cornerRadius = 5
        self.valueTextField.delegate = self
    }
    
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch  self.type {
        case .text:
            return true
        case .address:
            self.delegate?.presenter.presentAddressReasearcher() { selectedAddress in
                self.valueTextField.text = selectedAddress
            }
            return false
        case .date:
            self.delegate?.presenter.presentDatePicker(completion: { (selectedDate) in
                
                print(selectedDate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                self.valueTextField.text = selectedDate
            })
            return false
        }
    }
    
    //MARK: - Actions
    
    @IBAction func typeControlDidTapped(_ sender: Any) {
        if HBDropDownList.isVisible {
            HBDropDownList.hide()
            return
        }
        HBDropDownList.show(below: sender as! UIView, withData: ParameterType.allCases.map{$0.rawValue}) { (selectedString) in
            self.type = ParameterType(rawValue: selectedString)!
            self.typeLabel.text = selectedString
        }
    }
    
    @IBAction func removeButtonDidTapped(_ sender: Any) {
        guard let key = self.keyTextField.text,
            !key.isEmpty
            else {return}
        self.delegate?.removeParameter(for: key)
    }
    
    @IBAction func addButtonDidTapped(_ sender: Any) {
        guard let key = self.keyTextField.text,
            let value = self.valueTextField.text,
            !key.isEmpty,
            !value.isEmpty
            else {return}
        self.delegate?.addParameter(key: key, value: value)
    }
    
}
