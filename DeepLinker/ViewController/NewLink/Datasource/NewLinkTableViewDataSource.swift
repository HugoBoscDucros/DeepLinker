//
//  NewLinkTableViewDataSource.swift
//  DeepLinker
//
//  Created by Hugo Bosc-Ducros on 25/03/2020.
//  Copyright © 2020 HBD. All rights reserved.
//

import Foundation
import UIKit

class NewLinkTableViewDataSource:NSObject,UITableViewDataSource, UITableViewDelegate {
    
    unowned var delegate:URLParameterDelegate
    
    init(_ delegate:URLParameterDelegate) {
        self.delegate = delegate
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SchemeCell") as! PathTableViewCell
            let (title, placeholder, keyPath) = getPathCellParameters(for: indexPath.row)
//            cell.set(title, placeholder: placeholder, type:type, delegate: self.delegate)
            cell.set(title, placeholder: placeholder, keyPath: keyPath, delegate: self.delegate)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParameterCell") as! ParameterTableViewCell
            cell.delegate = self.delegate
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Base URL"
        } else if section == 1 {
            return "Query String"
        }
        return nil
    }
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return ["Base URL", "QueryString"]
//    }
    
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 73
        }
        return 188
    }
    
    //MARK: - Utils
    
//    func getPathCellParameters(for row:Int) -> (String, String, PathType) {
//        switch row {
//        case 0:
//            return ("Sheme", "https", .sheme)
//        case 1:
//            return ("Path", "somewere/seome", .host)
//        default:
//            return ("", "", .path)
//        }
//    }
    
    func getPathCellParameters(for row:Int) -> (String, String, AnyKeyPath) {
        switch row {
        case 0:
            return ("Sheme", "Ex: https", \URLComponents.scheme)
        case 1:
            return ("host", "Ex: google.com", \URLComponents.host)
        default:
            return ("path", "Ex: /map", \URLComponents.path)
        }
    }
}
