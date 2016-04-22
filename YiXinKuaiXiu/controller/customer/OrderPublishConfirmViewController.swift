//
//  OrderPublishConfirmViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/5.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import Photos

class OrderPublishConfirmViewController: UITableViewController, PopBottomViewDataSource,PopBottomViewDelegate {
    @IBOutlet var doPayButton: UIButton!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var feeLabel: UILabel!
    @IBOutlet var feeTitleLabel: UILabel!
    @IBOutlet var feeCell: UITableViewCell!
    @IBOutlet var imageCell: UITableViewCell!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image1: UIImageView!
    
    var order: Order?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        self.tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        
        self.tableView.layoutIfNeeded()
    }
    
    func initView() {
        doPayButton.layer.cornerRadius = 3
        doPayButton.backgroundColor = Constants.Color.Primary
        
        descLabel.text = order?.desc
        
        locationLabel.text = order?.location
        
        timeLabel.text = UtilBox.getDateFromString(String(NSDate().timeIntervalSince1970), format: Constants.DateFormat.YMD)
        
        if order?.type == "打包维修" {
            feeTitleLabel.text = "打包费"
            feeLabel.text = order?.fee
        } else if order?.type == "预约维修" {
            feeCell.hidden = true
        } else {
            feeLabel.text = order?.fee
        }
        
        if order?.image1 == nil {
            imageCell.hidden = true
        } else if order?.image2 == nil {
            image2.image = UtilBox.getAssetThumbnail((order?.image1!.originalAsset)!)
        } else {
            image1.image = UtilBox.getAssetThumbnail((order?.image1!.originalAsset)!)
            image2.image = UtilBox.getAssetThumbnail((order?.image2!.originalAsset)!)
        }
    }
    
    @IBAction func doPay(sender: UIButton) {
        let v = PopBottomView(frame: self.view.bounds)
        v.dataSource = self
        v.delegate = self
        v.showInView(self.view)
    }
    
    func hide(){
        for v in self.view.subviews {
            if let vv = v as? PopBottomView{
                vv.hide()
            }
        }
    }
    
    //MARK : - PopBottomViewDataSource
    func viewPop() -> UIView {
        let payPopoverView = UIView.loadFromNibNamed("PayPopoverView") as! PayPopoverView
        payPopoverView.closeButton.addTarget(self, action: #selector(PopBottomView.hide), forControlEvents: UIControlEvents.TouchUpInside)
        payPopoverView.doPayButton.addTarget(self, action: #selector(PopBottomView.hide), forControlEvents: UIControlEvents.TouchUpInside)
        payPopoverView.doPayButton.addTarget(self, action: #selector(OrderPublishConfirmViewController.goPay), forControlEvents: UIControlEvents.TouchUpInside)
        payPopoverView.feeLabel.text = order?.fee
        return payPopoverView
    }
    
    func goPay() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func viewHeight() -> CGFloat {
        return 295
    }
    
    func isEffectView() -> Bool {
        return false
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            if indexPath.row == 0 {
                return descLabel.frame.size.height + 28
            } else if indexPath.row == 2 {
                return locationLabel.frame.size.height + 28
            } else if indexPath.row == 1{
               return order?.image1 == nil ? 0 : 70
            } else {
                return 44
            }
        default:
            return 44
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1 : 5
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

}
