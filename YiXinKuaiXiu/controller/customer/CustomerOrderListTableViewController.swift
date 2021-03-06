//
//  OrderListTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerOrderListTableViewController: OrderListTableViewController, PopBottomViewDataSource, PopBottomViewDelegate, OrderListChangeDelegate, PopoverPayDelegate, UITextFieldDelegate, PayDelegate {
    
    var mFee: String?
    
    var reloadIndexPath: NSIndexPath?
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let order = orders[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("customerOrderListTopCell", forIndexPath: indexPath)
            
            let typeLabel = cell.viewWithTag(Constants.Tag.CustomerOrderListCellType) as! UILabel
            let mainTypeLabel = cell.viewWithTag(Constants.Tag.CustomerOrderListCellMaintenanceType) as! UILabel
            let statusLabel = cell.viewWithTag(Constants.Tag.CustomerOrderListCellStatus) as! UILabel
            let descLabel = cell.viewWithTag(Constants.Tag.CustomerOrderListCellDesc) as! UILabel
            
            typeLabel.clipsToBounds = true
            typeLabel.layer.cornerRadius = 3
            
            if order.type == .Urgent {
                typeLabel.backgroundColor = Constants.Color.Orange
                typeLabel.text = "紧急"
            } else if order.type == .Pack {
                typeLabel.backgroundColor = Constants.Color.Green
                typeLabel.text = "打包"
            } else {
                typeLabel.backgroundColor = Constants.Color.Blue
                typeLabel.text = "预约"
            }
            
            mainTypeLabel.text = order.mType! + "维修"
            
            statusLabel.text = Constants.Status[(order.status?.rawValue)!]
            
            descLabel.text = order.desc
            return cell
        } else if indexPath.row == (order.payments?.count)! + 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("customerOrderListBottomCell", forIndexPath: indexPath)
            
            let leftButton = cell.viewWithTag(Constants.Tag.CustomerOrderListCellLeftButton) as! UIButton
            leftButton.removeTarget(self, action: nil, forControlEvents: .TouchUpInside)
            leftButton.hidden = false
            
            let rightButton = cell.viewWithTag(Constants.Tag.CustomerOrderListCellRightButton) as! UIButton
            rightButton.removeTarget(self, action: nil, forControlEvents: .TouchUpInside)
            rightButton.hidden = false
            
            let reminderLabel = cell.viewWithTag(Constants.Tag.CustomerOrderListCellReminder) as! UILabel
            reminderLabel.hidden = true
            
            switch order.state! {
            case .NotPayFee:
                leftButton.hidden = true
                
                rightButton.setTitle("付检查费", forState: .Normal)
                rightButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.goPayAction), forControlEvents: UIControlEvents.TouchUpInside)

            case .HasBeenGrabbed:
                if order.type == .Pack {
                    leftButton.hidden = true
                    
                    rightButton.setTitle("竣工付费", forState: .Normal)
                    rightButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.goPayAction), forControlEvents: UIControlEvents.TouchUpInside)
                } else if order.type == .Reservation {
                    leftButton.hidden = true
                    
                    rightButton.setTitle("确定竣工", forState: .Normal)
                    rightButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.confirmDone), forControlEvents: UIControlEvents.TouchUpInside)
                } else {
                    leftButton.setTitle("购买配件", forState: .Normal)
                    leftButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.showPartsMallAction), forControlEvents: UIControlEvents.TouchUpInside)
                
                    rightButton.setTitle("竣工付费", forState: .Normal)
                    rightButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.goPayAction), forControlEvents: UIControlEvents.TouchUpInside)
                }

            case .PaidMFee:
                if order.type == .Urgent  {
                    leftButton.setTitle("补购配件", forState: .Normal)
                    leftButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.showPartsMallAction), forControlEvents: UIControlEvents.TouchUpInside)
                } else {
                    leftButton.hidden = true
                }
                
                rightButton.setTitle("立即评价", forState: .Normal)
                rightButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.goRatingAction), forControlEvents: UIControlEvents.TouchUpInside)

            case .Cancelling:
                leftButton.hidden = true
                rightButton.hidden = true
                reminderLabel.hidden = true
                
            default:
                leftButton.hidden = true
                rightButton.hidden = true
            }
        
            return cell
        } else {
            let payment = order.payments![indexPath.row - 1]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("customerOrderListMidCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = payment.name
            cell.detailTextLabel?.text = "¥" + String(payment.price!) + (payment.paid ? "(已支付)" : "(未支付)")
            
            let background = UIView()
            background.layer.cornerRadius = 3
            background.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            
            let origin = cell.contentView.frame
            
            if order.payments?.count == 1 {
                background.frame = CGRect(x: origin.minX + 10, y: origin.minY, width: UIScreen.mainScreen().bounds.width - 20, height: 36)
            } else {
                if indexPath.row == 1 {
                    background.frame = CGRect(x: origin.minX + 10, y: origin.minY, width: UIScreen.mainScreen().bounds.width - 20, height: 50)
                } else if indexPath.row == order.payments?.count {
                    background.frame = CGRect(x: origin.minX + 10, y: origin.minY - 20, width: UIScreen.mainScreen().bounds.width - 20, height: 56)
                } else {
                    background.frame = CGRect(x: origin.minX + 10, y: origin.minY, width: UIScreen.mainScreen().bounds.width - 20, height: 30)
                    background.layer.cornerRadius = 0
                }
            }
            
            if cell.subviews.count >= 3 {
                cell.subviews[0].removeFromSuperview()
            }
            
            cell.insertSubview(background, atIndex: 0)
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        } else if indexPath.row == (orders[indexPath.section].payments?.count)! + 1 {
            // 这里导致报了警告
            let state = orders[indexPath.section].state
            if state == .PaidFee || state == .HasBeenRated {
                return 8
            } else {
                return UITableViewAutomaticDimension
            }
        } else {
            if indexPath.row == 1 || indexPath.row == orders[indexPath.section].payments?.count {
                return 36
            } else {
                return 24
            }
        }
    }
    
    func hide(){
        for v in self.view.subviews {
            if let vv = v as? PopBottomView{
                vv.hide()
            }
        }
    }
    
    //MARK : - PopBottomViewDataSource
    //var payPopoverView: PayPopoverView?
    func viewPop() -> UIView {
        let payPopoverView = UIView.loadFromNibNamed("PayPopoverView") as! PayPopoverView
        payPopoverView.closeButton.addTarget(self, action: #selector(PopBottomView.hide), forControlEvents: UIControlEvents.TouchUpInside)
        payPopoverView.doPayButton.addTarget(self, action: #selector(PopBottomView.hide), forControlEvents: UIControlEvents.TouchUpInside)
        payPopoverView.delegate = self
        payPopoverView.viewController = self
        
        let order = orders[(selectedIndexPath?.section)!]
        
        if order.type == .Pack { // 付打包费
            payPopoverView.feeLabel.text = "￥" + order.fee!
            payPopoverView.fee = order.fee!
            payPopoverView.type = .PackFee
            payPopoverView.date = order.date!
        } else if order.state == .NotPayFee { // 付上门费
            payPopoverView.feeLabel.text = "￥" + order.fee!
            payPopoverView.fee = order.fee!
            payPopoverView.type = .Fee
            payPopoverView.date = order.date!
        }
        
        return payPopoverView
    }
    
    func onPayResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            self.noticeSuccess("支付成功", autoClear: true, autoClearTime: 2)
            didChange()
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func viewHeight() -> CGFloat {
        return 346
    }
    
    func isEffectView() -> Bool {
        return false
    }
    
    func viewWillAppear() {
        tableView.scrollEnabled = false
    }
    
    func viewWillDisappear() {
        tableView.scrollEnabled = true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if !UtilBox.isNum(string, digital: true) {
            return false
        }
        
        return true
    }
    
    func confirmDone(sender: UIButton) {
        self.pleaseWait()
        
        let cell = sender.superview?.superview as! UITableViewCell
        selectedIndexPath = tableView.indexPathForCell(cell)!
        
        let order = orders[(selectedIndexPath?.section)!]
        
        PayModel(payDelegate: self).goPay(order.date!, type: .MPFee, fee: "0", couponID: "")
    }
    
    func onGoPayResult(result: Bool, info: String) {
        self.clearAllNotice()
        
        if result {
            self.noticeSuccess("已确定", autoClear: true, autoClearTime: 2)
            
            didChange()
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func goPayAction(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        selectedIndexPath = tableView.indexPathForCell(cell)!
        
        let order = orders[(selectedIndexPath?.section)!]
        
        if order.type == .Urgent && order.state != .NotPayFee {
            let vc = UtilBox.getController(Constants.ControllerID.GoPayMFee) as! PayMFeeViewController
            vc.order = order
            vc.delegate = self
            self.navigationController?.showViewController(vc, sender: self)
        } else {
            let v = PopBottomView(frame: self.view.bounds)
            v.dataSource = self
            v.delegate = self
            v.showInView(self.view)
        }
    }
    
    func goRatingAction(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        selectedIndexPath = tableView.indexPathForCell(cell)!
        
        let ratingVC = UtilBox.getController(Constants.ControllerID.Rating) as! RatingViewController
        ratingVC.order = orders[(selectedIndexPath?.section)!]
        ratingVC.delegate = self
        self.navigationController?.showViewController(ratingVC, sender: self)
    }
    
    func showPartsMallAction(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        selectedIndexPath = tableView.indexPathForCell(cell)!
        
        let partsMallVC = UtilBox.getController(Constants.ControllerID.PartsMall) as! PartsMallViewController
        partsMallVC.order = orders[(selectedIndexPath?.section)!]
        partsMallVC.delegate = self
        self.navigationController?.showViewController(partsMallVC, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let codvc = destination as? CustomerOrderDetailViewController {
            codvc.order = segueOrder
            codvc.delegate = self
        }
        
    }
    
    func didChange() {
        refresh()
    }
}

protocol OrderListChangeDelegate {
    func didChange()
}
