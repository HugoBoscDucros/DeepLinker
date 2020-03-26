//
//  UIViewController+Extension.swift
//  DeepLinker
//
//  Created by Hugo Bosc-Ducros on 24/03/2020.
//  Copyright © 2020 HBD. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAddressReasearcher(completion:@escaping (_ selectedAddress:String) -> ()) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SearchAddressViewController") as! SearchAddressViewController
        vc.completion = completion
        let navVC = UINavigationController(rootViewController: vc)
        self.present(navVC, animated: true, completion: nil)
    }
    
    func presentDatePicker(completion:@escaping (_ selectedDate:String) -> ()) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DatePickerViewController") as! DatePickerViewController
        vc.completion = completion
        self.present(vc, animated: true, completion: nil)
    }
}
