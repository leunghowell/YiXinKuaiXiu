//
//  OrderPublishViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/4.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import Photos

class OrderPublishViewController: UITableViewController, OrderPublishDelegate, OrderDelegate, ChooseLocationDelegate {
    @IBOutlet var publishButtonItem: UIBarButtonItem!
    @IBOutlet var picture1ImageView: UIImageView!
    @IBOutlet var picture2ImageView: UIImageView!
    @IBOutlet var picture3ImageView: UIImageView!
    @IBOutlet var picture4ImageView: UIImageView!
    
    @IBOutlet var descTextView: BRPlaceholderTextView!
    @IBOutlet var feeCell: UITableViewCell!
    
    @IBOutlet var feeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var maintenanceTypeLabel: UILabel!
    
    var imageViews: [UIImageView] = []
    
    var selectedImage: [DKAsset] = []
    var mTypeID: String?
    var locationInfo: CLLocation?
    
    var order: Order?
    var fee: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if title == Constants.Types[1] {
            feeCell.textLabel?.text = "打包费"
        } else if title == Constants.Types[2] {
            feeCell.hidden = true
        } else {
            feeCell.textLabel?.text = "紧急检查费"
        }
        
        initView()
        
        initNavBar()
    }
    
    func initView() {
        descTextView.placeholder = "在这儿输入问题详情"
        descTextView.setPlaceholderFont(UIFont(name: (descTextView.font?.fontName)!, size: 16))
        
        imageViews.append(picture1ImageView)
        imageViews.append(picture2ImageView)
        imageViews.append(picture3ImageView)
        imageViews.append(picture4ImageView)
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    @IBAction func choosePicture(sender: UITapGestureRecognizer){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(
            title: "拍照",
            style: .Default)
        { (action: UIAlertAction) -> Void in
            self.fromCamera()
            }
        )
        
        alert.addAction(UIAlertAction(
            title: "从相册中选择",
            style: .Default)
        { (action: UIAlertAction) -> Void in
            self.fromAlbum(self.selectedImage)
            }
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func fromCamera() {
        let pickerController = DKImagePickerController()
        pickerController.sourceType = .Camera
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.fromAlbum(assets)
        }
        self.presentViewController(pickerController, animated: true){}
    }
    
    func fromAlbum(selectedImage: [DKAsset]) {
        let pickerController = DKImagePickerController()
        pickerController.defaultSelectedAssets = selectedImage
        pickerController.showsCancelButton = true
        pickerController.maxSelectableCount = 4
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.selectedImage = assets
            
            // bad code
            if self.selectedImage.count == 0 {
                self.imageViews[0].image = UIImage(named: "add_picture")
                self.imageViews[1].image = nil
                self.imageViews[2].image = nil
                self.imageViews[3].image = nil
            } else if self.selectedImage.count == 1 {
                self.imageViews[0].image = UtilBox.getAssetThumbnail(self.selectedImage[0].originalAsset!)
                self.imageViews[1].image = UIImage(named: "add_picture")
                self.imageViews[2].image = nil
                self.imageViews[3].image = nil
            } else if self.selectedImage.count == 2 {
                self.imageViews[0].image = UtilBox.getAssetThumbnail(self.selectedImage[0].originalAsset!)
                self.imageViews[1].image = UtilBox.getAssetThumbnail(self.selectedImage[1].originalAsset!)
                self.imageViews[2].image = UIImage(named: "add_picture")
                self.imageViews[3].image = nil
            } else if self.selectedImage.count == 3 {
                self.imageViews[0].image = UtilBox.getAssetThumbnail(self.selectedImage[0].originalAsset!)
                self.imageViews[1].image = UtilBox.getAssetThumbnail(self.selectedImage[1].originalAsset!)
                self.imageViews[2].image = UtilBox.getAssetThumbnail(self.selectedImage[2].originalAsset!)
                self.imageViews[3].image = UIImage(named: "add_picture")
            } else {
                self.imageViews[0].image = UtilBox.getAssetThumbnail(self.selectedImage[0].originalAsset!)
                self.imageViews[1].image = UtilBox.getAssetThumbnail(self.selectedImage[1].originalAsset!)
                self.imageViews[2].image = UtilBox.getAssetThumbnail(self.selectedImage[2].originalAsset!)
                self.imageViews[3].image = UtilBox.getAssetThumbnail(self.selectedImage[3].originalAsset!)
            }
        }
        
        self.presentViewController(pickerController, animated: true){}
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    // 生成订单
    func generateOrder() {
        var type: Type
        if self.title == Constants.Types[0] {
            type = .Urgent
        } else if self.title == Constants.Types[1] {
            type = .Pack
        } else {
            type = .Reservation
        }
        
        order = Order(type: type, desc: descTextView.text, mType: maintenanceTypeLabel.text!, mTypeID: mTypeID!, location: locationLabel.text!, locationInfo: locationInfo!, fee: self.fee, images: selectedImage)
    }
    
    @IBAction func publish(sender: UIBarButtonItem) {
        descTextView.resignFirstResponder()
        
        if maintenanceTypeLabel.text == "点击选择" {
            UtilBox.alert(self, message: "请选择分类")
        } else if locationLabel.text == "点击选择" {
            UtilBox.alert(self, message: "请选择地址")
        } else if self.title != Constants.Types[2] && feeLabel.text == "点击选择" {
            UtilBox.alert(self, message: "请选择费用")
        } else {
            self.pleaseWait()
            
            generateOrder()
        
            publishButtonItem.enabled = false
            
            OrderModel(orderDelegate: self).publish(order!)
        }
    }
    
    func onPublishOrderResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            order?.date = info
            
            if order?.type == .Urgent {
                performSegueWithIdentifier(Constants.SegueID.ShowOrderPublishConfirmSegue, sender: self)
            } else {
                self.noticeSuccess("发布成功", autoClear: true, autoClearTime: 2)
                
                Config.NotToHomePage = true
                
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        } else {
            publishButtonItem.enabled = true
            UtilBox.alert(self, message: info)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 11
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                if title == Constants.Types[0] {
                    performSegueWithIdentifier(Constants.SegueID.ChooseFeeSegue, sender: self)
                } else {
                    performSegueWithIdentifier(Constants.SegueID.EditPriceSegue, sender: self)
                }
            } else if indexPath.row == 0 {
                performSegueWithIdentifier(Constants.SegueID.ChooseMaintenanceTyeSegue, sender: self)
            } else if indexPath.row == 1 {
                let chooseLocationVC = UtilBox.getController(Constants.ControllerID.ChooseLocation) as! ChooseLocationTableViewController
                chooseLocationVC.delegate = self
                self.navigationController?.showViewController(chooseLocationVC, sender: self)
            }
            
            descTextView.resignFirstResponder()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let mtvc = destination as? MaintenanceTypeViewController {
            mtvc.delegate = self
        } else if let cfvc = destination as? CheckFeeViewController {
            cfvc.delegate = self
        } else if let opcvc = destination as? OrderPublishConfirmViewController {
            opcvc.order = order
        } else if let cfvc = destination as? ChooseFeeViewController {
            cfvc.delegate = self
        }
    }
    
    func didSelectedMaintenanceType(type: String, id: String) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
        cell?.detailTextLabel?.text = type + "维修"
        
        mTypeID = id
    }
    
    func didChooseLocation(name: String, locationInfo: CLLocation) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))
        cell?.detailTextLabel?.text = name
        self.locationInfo = locationInfo
    }
    
    func didSelectedFee(fee: String) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1))
        cell?.detailTextLabel?.text = "￥ " + fee
        
        self.fee = fee
    }
    
    func onPullOrderListResult(result: Bool, info: String, orderList: [Order]) {}
    
    func onPullGrabOrderListResult(result: Bool, info: String, orderList: [Order]) {}
    
    func onGrabOrderResult(result: Bool, info: String) {}
    
    func onCancelOrderResult(result: Bool, info: String) {}
    
    func onCancelOrderConfirmResult(result: Bool, info: String) {}
}

protocol OrderPublishDelegate {
    func didSelectedMaintenanceType(type: String, id: String)
    func didSelectedFee(fee: String)
}
