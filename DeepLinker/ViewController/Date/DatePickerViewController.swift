//
//  DatePickerViewController.swift
//  DeepLinker
//
//  Created by Hugo Bosc-Ducros on 26/03/2020.
//  Copyright © 2020 HBD. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var completion:((_ dateString:String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - Settings
    
    func loadSettings() {
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.minimumDate = Date()
    }
    
    
    //MARK: - Actions
    
    
    @IBAction func cancelButtonDidTappe(_ sender: Any) {
        self.completion = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseButtonDidTapped(_ sender: Any) {
        completion?(self.datePicker.date.toJSON)
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
