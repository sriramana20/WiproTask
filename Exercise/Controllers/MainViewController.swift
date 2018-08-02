//
//  ViewController.swift
//  Exercise
//
//  Created by sriramana on 8/1/18.
//  Copyright © 2018 sriramana. All rights reserved.
//


import UIKit
import SwiftyJSON
import ObjectMapper

class MainViewController: UITableViewController {
    
    let cellId = "cellId"
    var dataItems : [DataModel]  = [DataModel]()
    var baseData = ItemsModel()
    let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let progressIndicator = ProgressView(text: "Loading")
    let internetAlertMsg = "The Internet connection appears to be offline."
    var viewModelObj = HomeFeedViewModel()

    /*
     refresh control to refresh the data in the tableview
     */
    lazy var refreshController: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MainViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.setupTableView()
        self.callService()
    }
    
    /*
     intialize properties of table view , register custom table cell with table view
     */
    func setupTableView(){
        self.viewModelObj.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(CustomInfoTableCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.addSubview(self.refreshController)

        self.navigationController?.navigationBar.barTintColor = UIColor(red:61/255.0, green: 197/255.0, blue: 222/255.0, alpha:1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16.0)]
    }
    func callService(){
        if NetworkManager.sharedInstance.checkNetworkConnectivity(){
            self.getJSONFeed()
        }else{
            if self.refreshController.isRefreshing {
                self.refreshController.endRefreshing()
            }
            self.showErrorAlert(alert: internetAlertMsg)
        }
    }
    /*
     REST API call to fetch the data and processing it to display
     */
    func getJSONFeed(){
        self.showProgressIndicator()
        self.viewModelObj.getJsonFeed()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomInfoTableCell
        cell.renderData(info : dataItems[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItems.count
    }
}
extension MainViewController{

    /*
     show the progrees view
     */
    func showProgressIndicator() {
        self.delegate.window?.isUserInteractionEnabled = false
        self.delegate.window?.addSubview(self.progressIndicator)
    }
    /*
     hide the progrees view
     */
    func hideProgressIndicator(){
        self.delegate.window?.isUserInteractionEnabled = true
        self.progressIndicator.removeFromSuperview()
    }

    /*
     show the alert view with error messages
     */
    func showErrorAlert(alert message: String?) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    /*
     refresh control handler
     */
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.callService()
    }
}
extension MainViewController : JsonFeedVMDelegate{
    func errorHandling(_ error:String){
        DispatchQueue.main.async {
            self.hideProgressIndicator()
            self.showErrorAlert(alert: error)
        }
    }
    func getJSONFeedSuccessHandler(_ title : String, response: [DataModel]){
        DispatchQueue.main.async {
            self.hideProgressIndicator()
            self.title = title
            self.dataItems  = response
            self.tableView.reloadData()
            
            if self.refreshController.isRefreshing {
                self.refreshController.endRefreshing()
            }
        }
    }
}
