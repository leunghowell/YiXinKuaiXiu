//
//  MaintenanceTypeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/4.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class MaintenanceTypeViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var delegate: OrderPublishDelegate?
    
    var filteredTypes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        searchBar.tintColor = Constants.Color.Primary
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let name = (cell?.textLabel?.text)!.stringByReplacingOccurrencesOfString("维修", withString: "")
        let id = UtilBox.findMTypeIDByName(name)!
        
        delegate?.didSelectedMaintenanceType(name, id: id)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredTypes.count
        } else {
            return Config.MTypeNames!.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("maintenanceTypeCell")! as UITableViewCell
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            cell.textLabel!.text = filteredTypes[indexPath.row]
        } else {
            cell.textLabel!.text = Config.MTypeNames![indexPath.row]
        }
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String) {
        self.filteredTypes = Config.MTypeNames!.filter({( string : String) -> Bool in
            return string.rangeOfString(searchText) != nil
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        self.filterContentForSearchText(searchString!)
        
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController,
                                 shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!)
        return true
    }
    
}
