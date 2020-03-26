//
//  PathTableViewCell.swift
//  DeepLinker
//
//  Created by Hugo Bosc-Ducros on 24/03/2020.
//  Copyright © 2020 HBD. All rights reserved.
//

import UIKit

class PathTableViewCell: UITableViewCell, UITextFieldDelegate {
    

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var type:PathType = .sheme
    weak var delegate:URLParameterDelegate?
    var keyPath:AnyKeyPath?
    
    var completion:((_ value:String) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.delegate = self
    }
    
    func set(_ title:String, placeholder:String = "", completion:@escaping ((_ value:String) -> ())) {
        self.label.text = title
        self.textField.placeholder = placeholder
        self.completion = completion
    }
    
    func set(_ title:String, placeholder:String = "", type: PathType, delegate:URLParameterDelegate) {
        self.type = type
        self.label.text = title
        self.textField.placeholder = placeholder
        self.delegate = delegate
    }
    
    func set(_ title:String, placeholder:String = "", keyPath:AnyKeyPath, delegate:URLParameterDelegate) {
        self.delegate = delegate
        self.keyPath = keyPath
        self.label.text = title
        self.textField.placeholder = placeholder
    }
    
//    @IBAction func buttonDidTapped(_ sender: Any) {
//        guard let value = self.textField.text,
//            !value.isEmpty
//            else {return}
//        completion?(value)
//        self.delegate?.addPath(type: self.type, value: value)
//    }
    
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
        let textRange = Range(range, in: text)/*,
        let keyPath = self.keyPath*/ else {return true}
        let updatedText = text.replacingCharacters(in: textRange,
                                                    with: string)
        if let keyPath = self.keyPath as? WritableKeyPath<URLComponents, String?> {
            self.delegate?.urlComponents[keyPath:keyPath] = updatedText
        } else if let keyPath = self.keyPath as? WritableKeyPath<URLComponents, String> {
            self.delegate?.urlComponents[keyPath:keyPath] = updatedText
        }
        
        return true
    }
}
