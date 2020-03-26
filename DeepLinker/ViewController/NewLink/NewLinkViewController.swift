//
//  NewLinkViewController.swift
//  DeepLinker
//
//  Created by Hugo Bosc-Ducros on 24/03/2020.
//  Copyright © 2020 HBD. All rights reserved.
//

import UIKit

class NewLinkViewController: UIViewController, URLParameterDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var tryButton: UIButton!
    
    lazy var dataSource =  {
        return NewLinkTableViewDataSource(self)
    }()
    
    var urlComponents = URLComponents() {
        didSet {
            if let urlString = self.urlComponents.url?.absoluteString {
                self.urlLabel.text = urlString
                self.clearButton.isHidden = false
                self.copyButton.isHidden = false
                self.tryButton.isHidden = false
            } else {
                self.resetUrlActionsAndLabel()
            }
            
        }
    }
    
    //MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
    }
    
    //MARK: - Settings
    
    private func loadSettings() {
        self.setTableView()
        self.resetUrlActionsAndLabel()
    }
    
    private func resetUrlActionsAndLabel() {
        self.urlLabel.text = ""
        self.clearButton.isHidden = true
        self.copyButton.isHidden = true
        self.tryButton.isHidden = true
    }
    
    private func setTableView() {
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self.dataSource
        self.tableView.tableFooterView = UIView()
    }
    
    private func clearUrlComponents() {
        self.urlComponents.scheme = nil
        self.urlComponents.host = nil
        self.urlComponents.path = ""
        self.urlComponents.queryItems = nil
    }
    

    //MARK: - Actions
    
    @IBAction func clearButtonDidTapped(_ sender: Any) {
        self.clearUrlComponents()
        self.tableView.reloadData()
    }
    
    @IBAction func copyButtonDidTapped(_ sender: Any) {
        guard let urlString = self.urlComponents.url?.absoluteString else {return}
        UIPasteboard.general.string = urlString
    }
    
    @IBAction func tryButtonDidTapped(_ sender: Any) {
        guard let url = self.urlComponents.url,
        UIApplication.shared.canOpenURL(url) else {return}
        UIApplication.shared.open(url)
    }
    
    
    //MARK: - ParameterDelegate
     
     func removeParameter(for Key: String) {
        self.urlComponents.queryItems?.removeAll(where: {$0.name == Key})
     }
        
    func addParameter(key: String, value: String) {
        let item = URLQueryItem(name: key, value: value)
        (self.urlComponents.queryItems == nil) ? (self.urlComponents.queryItems = [item]):self.urlComponents.queryItems?.append(item)
    }
    
    func addPath(type: PathType, value: String) {
        switch type {
        case .sheme:
            self.urlComponents.scheme = value
        case .host:
            self.urlComponents.host = value
        case .path:
            self.urlComponents.path = value
        }
    }
    
    var presenter: UIViewController {
        return self
    }
}
