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
    let serviceManager = ServiceManager.sharedInstance
    let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let progressIndicator = ProgressView(text: "Loading")
    let internetAlertMsg = "The Internet connection appears to be offline."

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
            self.showErrorAlert(alert: internetAlertMsg)
        }
    }
    /*
     REST API call to fetch the data and processing it to display
     */
    func getJSONFeed(){
        self.showProgressIndicator()
        self.serviceManager.getDataFromService(success: {(response) -> Void in
            let json = JSON(response)
            if json != JSON.null {
                self.dataItems.removeAll()
                for i in 0..<json["rows"].count {
                    if let rawStr = json["rows"][i].rawString(),
                        let obj = Mapper<DataModel>().map(JSONString: rawStr){
                        self.dataItems.append(obj)
                    }
                }
                DispatchQueue.main.async {
                    self.hideProgressIndicator()
                    if let title =  json["title"].string{
                        self.title = title
                    }
                    self.tableView.reloadData()
                    if self.refreshController.isRefreshing {
                        self.refreshController.endRefreshing()
                    }
                }
            } else {
                self.hideProgressIndicator()
                self.showErrorAlert(alert: "Oops! Something's not right.")
            }
        }) {(error) -> Void in
            if let err  = error{
                self.hideProgressIndicator()
                print(err.localizedDescription)
               self.showErrorAlert(alert: err.localizedDescription)
            }
        }
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
