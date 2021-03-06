//
//  CustomerWithDrawViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class WithDrawViewController: UITableViewController, UITextFieldDelegate, WalletDelegate, BankCardChangeDelegate {
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var moneyTextField: UITextField!
    @IBOutlet var bankLabel: UILabel!
    
    var delegate: WalletChangeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initNavBar()
    }
    
    func initView() {
        doneButton.enabled = false
        
        if Config.BankOwner == nil {
            bankLabel.text = "请选择"
        } else {
            var num = Config.BankNum! as NSString
            if num.length >= 4 {
                num = num.substringFromIndex(num.length - 4)
            }
            bankLabel.text = Config.BankName! + "(尾号" + (num as String) + ")"
        }
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "提现"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    var alert: OYSimpleAlertController?
    var alertView: EnterPasswordAlertView?
    @IBAction func enterPassword(sender: UIBarButtonItem) {
        moneyTextField.resignFirstResponder()
        
        alert = OYSimpleAlertController()
        alert!.contentOffset = -50
        
        alertView = UIView.loadFromNibNamed("EnterPasswordAlertView") as? EnterPasswordAlertView
        
        alertView!.cancelButton.addTarget(self, action: #selector(WithDrawViewController.cancel), forControlEvents: UIControlEvents.TouchUpInside)
        
        alertView!.confirmButton.addTarget(self, action: #selector(WithDrawViewController.doSubmit), forControlEvents: UIControlEvents.TouchUpInside)
        
        alertView?.pwdTextField.becomeFirstResponder()
        
        alert!.initView(alertView!)
        
        presentViewController(alert!, animated: true, completion: nil)
    }
    
    func doSubmit() {
        alertView?.pwdTextField.resignFirstResponder()
        
        WalletModel(walletDelegate: self).doWithDraw(moneyTextField.text!, pwd: (alertView?.pwdTextField.text)!)
        
        self.pleaseWait()
    }
    
    func onWithDrawResult(result: Bool, info: String) {
        self.clearAllNotice()
        
        if result {
            self.noticeSuccess("申请成功", autoClear: true, autoClearTime: 2)
            
            Config.Money = String(Float(Config.Money!)! - Float(moneyTextField.text!)!)
            delegate?.didRecharge()
            
            alert?.dismissViewControllerAnimated(true, completion: nil)
            alert = nil
            
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            self.noticeError(info, autoClear: true, autoClearTime: 2)
        }
    }
    
    func cancel() {
        alertView?.pwdTextField.resignFirstResponder()
        alert?.dismissViewControllerAnimated(true, completion: nil)
        alert = nil
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if !UtilBox.isNum(string, digital: true) {
            return false
        }
        
        if range.location == 0 && textField.text?.characters.count == 0 {
            doneButton.enabled = true
        } else if range.location == 0 && textField.text?.characters.count == 1 {
            doneButton.enabled = false
        }
        
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if Config.BankOwner == nil {
                performSegueWithIdentifier(Constants.SegueID.WithDrawToBindBankCardSegue, sender: self)
            } else {
                performSegueWithIdentifier(Constants.SegueID.WithDrawToBoundBankCardSegue, sender: self)
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 20
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : "您有￥" + Config.Money! + "余额可供转出"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let bbcvc = destination as? BoundBankCardViewController {
            bbcvc.delegate = self
        } else if let bbcvc = destination as? BindBankCardViewController {
            bbcvc.delegate = self
        }
    }
    
    func didChange() {
        if Config.BankOwner == nil {
            bankLabel.text = "请选择"
        } else {
            var num = Config.BankNum! as NSString
            num = num.substringFromIndex(num.length - 4)
            bankLabel.text = Config.BankName! + "(尾号" + (num as String) + ")"
        }
    }

    func onGetD2DAccountResult(result: Bool, info: String, accountList: [D2DAccount]) {}
}
