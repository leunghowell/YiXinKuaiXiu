//
//  HandymanHomeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import KYDrawerController

class HandymanHomeViewController: UIViewController, HandymanDrawerDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate, GetNearbyDelegate, ModifyUserInfoDelegate, OrderDelegate, GetInitialInfoDelegate, UserInfoDelegate {
    
    @IBOutlet var mapView: BMKMapView!
    @IBOutlet var getLocationButton: UIButton!
    
    var drawerController: KYDrawerController?
    
    var personList: [Person]?
    
    let locationService = BMKLocationService()
    
    var gotLocation = false
    
    var timer: NSTimer?
    var isRefreshing = false
    
    var toDrawer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initNavBar()
        
        OrderModel(orderDelegate: self).pullOrderList(0, pullType: .OnGoing)
        
        GetInitialInfoModel(getInitialInfoDelegate: self).getVersionCode()
    }
    
    func initView() {
        drawerController = self.navigationController?.parentViewController as? KYDrawerController
        drawerController?.drawerWidth = UIScreen.mainScreen().bounds.width * 0.75
        (drawerController?.drawerViewController as! HandymanDrawerViewController).delegate = self
        
        getLocationButton.layer.borderWidth = 0.5
        getLocationButton.layer.borderColor = Constants.Color.Gray.CGColor
        getLocationButton.layer.cornerRadius = 3

        mapView.zoomLevel = 18
        mapView.showsUserLocation = true
        mapView.userTrackingMode = BMKUserTrackingModeFollow
    }

    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "主页"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    @IBAction func getLocation(sender: UIButton) {
        //        if !mapView.userLocationVisible {
        //            locationService.startUserLocationService()
        //        }
        
        if Config.CurrentLocationInfo != nil {
            mapView.centerCoordinate = (Config.CurrentLocationInfo?.coordinate)!
        }
        
        locationService.startUserLocationService()
    }
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        if gotLocation {
            locationService.stopUserLocationService()
        } else {
            mapView.updateLocationData(userLocation)
            mapView.removeAnnotations(mapView.annotations)
            
            let localLatitude = userLocation.location.coordinate.latitude
            let localLongitude = userLocation.location.coordinate.longitude
            
            Config.CurrentLocationInfo = userLocation.location
            
            //GetNearbyModel(getNearbyDelegate: self).doGetNearby(localLatitude.description, longitude: localLongitude.description, distance: 30)
            
            gotLocation = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = NSTimer.new(every: Constants.RefreshTimer.seconds) { (timer: NSTimer) in
            if !self.isRefreshing {
                self.isRefreshing = true
                
                UserInfoModel(userInfoDelegate: self).doGetUserInfo()
            }
        }
        
        timer?.start()
    }
    
    override func viewDidDisappear(animated: Bool) {
        timer?.invalidate()
        
        super.viewDidDisappear(animated)
    }
    
    func onGetUserInfoResult(result: Bool, info: String) {
        if result {
            (drawerController?.drawerViewController as! HandymanDrawerViewController).tableView.reloadData()
            
            isRefreshing = false
        }
    }
    
    func didModify(indexPath: NSIndexPath, value: String) {
        (drawerController?.drawerViewController as! HandymanDrawerViewController).tableView.reloadData()
    }
    
    func onGetNearbyResult(result: Bool, info: String, personList: [Person]) {
        if result {
            self.personList = personList
            
            for person in personList {
                let annotation = BMKPointAnnotation()
                let lat = CLLocationDegrees(person.latitude!)
                let lot = CLLocationDegrees(person.longitude!)
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lot!)
                
                mapView.addAnnotation(annotation)
            }
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let view =  BMKPinAnnotationView(annotation: annotation, reuseIdentifier: "aaa")
        view.animatesDrop = false
        view.image = UIImage(named: "customerLocation")
        
        return view
    }
    
    @IBAction func doGrab(sender: UIButton) {
        if Config.Audited == 0 && (Config.Name == nil || Config.Name == "") && (Config.IDNum == nil || Config.IDNum == "") {
            showAuditAlertView()
        } else if Config.Audited == 0 && Config.Name != nil && Config.Name != "" && Config.IDNum != nil && Config.IDNum != "" {
            showModifyAuditAlertView()
        } else {
            performSegueWithIdentifier(Constants.SegueID.ShowGrabListSegue, sender: self)
        }
    }
    
    var notAuditYetAlert: OYSimpleAlertController?
    
    func showAuditAlertView() {
        notAuditYetAlert = OYSimpleAlertController()
        UtilBox.showAlertView(self, alertViewController: notAuditYetAlert!, message: "尚未认证身份", cancelButtonTitle: "取消", cancelButtonAction: #selector(HandymanHomeViewController.auditCancel), confirmButtonTitle: "去认证", confirmButtonAction: #selector(HandymanHomeViewController.doAudit))
    }
    
    func showModifyAuditAlertView() {
        notAuditYetAlert = OYSimpleAlertController()
        UtilBox.showAlertView(self, alertViewController: notAuditYetAlert!, message: "身份认证审核中", cancelButtonTitle: "取消", cancelButtonAction: #selector(HandymanHomeViewController.auditCancel), confirmButtonTitle: "修改", confirmButtonAction: #selector(HandymanHomeViewController.doAudit))
    }
    
    // 点击去认证按钮
    func doAudit() {
        notAuditYetAlert?.dismissViewControllerAnimated(true, completion: nil)
        
        performSegueWithIdentifier(Constants.SegueID.HandymanDrawerToAuditIDSegue, sender: self)
    }
    
    // 点击取消
    func auditCancel() {
        notAuditYetAlert?.dismissViewControllerAnimated(true, completion: nil)
        notAuditYetAlert = nil
    }
    
    func didLogout() {
        UtilBox.clearUserDefaults()
        
        UIView.transitionWithView((UIApplication.sharedApplication().keyWindow)!, duration: 0.5, options: .TransitionCrossDissolve, animations: {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WelcomeVCNavigation")
            UIApplication.sharedApplication().keyWindow?.rootViewController = controller
            }, completion: nil)
    }
    
    @IBAction func drawerToggle(sender: UIBarButtonItem) {
        toDrawer = true
        drawerController?.setDrawerState(KYDrawerController.DrawerState.Opened, animated: true)
    }
    
    func didSelected(index: Int){
        drawerController?.setDrawerState(KYDrawerController.DrawerState.Closed, animated: true)
        
        switch index {
        case 0:
            //UserInfo
            let userInfoVC = UtilBox.getController(Constants.ControllerID.UserInfo) as! UserInfoViewController
            self.navigationController?.showViewController(userInfoVC, sender: self)
            
        case 1:
            let orderListVC = UtilBox.getController(Constants.ControllerID.OrderList) as! OrderListViewController
            self.navigationController?.showViewController(orderListVC, sender: self)
            
        case 2:
            let walletVC = UtilBox.getController(Constants.ControllerID.Wallet) as! WalletViewController
            walletVC.delegate = self
            self.navigationController?.showViewController(walletVC, sender: self)
            
        case 3:
            if Config.Audited == 0 {
                performSegueWithIdentifier(Constants.SegueID.HandymanDrawerToAuditIDSegue, sender: self)
            } else {
                performSegueWithIdentifier(Constants.SegueID.HandymanDrawerToAuditedSegue, sender: self)
            }
            
        case 4:
            let messageCenterVC = UtilBox.getController(Constants.ControllerID.MessageCenter) as! MessageCenterViewController
            self.navigationController?.showViewController(messageCenterVC, sender: self)
            
        case 5:
            let mallVC = UtilBox.getController(Constants.ControllerID.Mall) as! MallViewController
            self.navigationController?.showViewController(mallVC, sender: self)
            
        case 6:
            performSegueWithIdentifier(Constants.SegueID.HandymanDrawerToBlacklistSegue, sender: self)
            
        case 7:
            let projectBidingVC = UtilBox.getController(Constants.ControllerID.ProjectBiding) as! ProjectBidingViewController
            self.navigationController?.showViewController(projectBidingVC, sender: self)
            
        default:    break
        }
    }
    
    func onGetVersionCodeResult(result: Bool, info: String, url: String) {
        if result {
            let alertController = UIAlertController(title: info, message: nil, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "更新", style: .Default, handler: { (UIAlertAction) in
                UIApplication.sharedApplication().openURL(NSURL(string: url)!)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if toDrawer {
            toDrawer = false
            return
        }
        
        mapView.viewWillAppear()
        
        toDrawer = false
        
        mapView.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
        
        gotLocation = false
        locationService.delegate = self
        locationService.startUserLocationService()
        
        if Config.NotToHomePage {
            Config.NotToHomePage = false
            let orderListVC = UtilBox.getController(Constants.ControllerID.OrderList) as! OrderListViewController
            orderListVC.isFromHomePage = false
            self.navigationController?.showViewController(orderListVC, sender: self)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.viewWillDisappear()
        
        if toDrawer {
            return
        }
        
        mapView.delegate = nil // 不用时，置nil
        
        locationService.delegate = nil
        locationService.stopUserLocationService()
    }
    
    func onPullOrderListResult(result: Bool, info: String, orderList: [Order]) {}
    func onPublishOrderResult(result: Bool, info: String) {}
    func onPullGrabOrderListResult(result: Bool, info: String, orderList: [Order]) {}
    func onGrabOrderResult(result: Bool, info: String) {}
    func onCancelOrderResult(result: Bool, info: String) {}
    func onCancelOrderConfirmResult(result: Bool, info: String) {}
}
