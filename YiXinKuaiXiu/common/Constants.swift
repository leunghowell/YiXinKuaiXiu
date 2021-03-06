//
//  Constants.swift
//  Networking
//
//  Created by 梁浩 on 15/12/12.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

class Constants {
    static let Types = ["紧急维修", "打包维修", "预约服务"]
    static let Status = ["待发单", "待抢单", "进行中", "待评价", "已完成", "取消中"]
    
    static let RefreshTimer: Double = 2
    
    struct ControllerID {
        static let PayPopover = "payPopover"
        
        static let Wallet = "walletController"
        static let ChooseLocation = "chooseLocationController"
        static let MessageCenter = "messageCenterController"
        
        static let CustomerOrderList = "customerOrderListTableViewController"
        static let HandymanOrderList = "handymanOrderListTableViewController"
        
        static let Rating = "ratingController"
        static let OrderList = "orderListController"
        
        static let UserInfo = "userInfoController"
        static let PartsMall = "partsMallController"
        
        static let GoPayMFee = "goPayMFeeController"
        
        static let Mall = "mallController"
        
        static let Coupon = "couponController"
        
        static let PartsMallSearch = "partsMallSearchController"
        
        static let BlackList = "blackListController"
        static let ProjectBiding = "projectBidingController"
    }
    
    struct UserDefaultKey {
        static let TelephoneNum = "telephoneNum"
        static let VerifyCode = "verifyCode"
        static let Aid = "aid"
        static let Role = "role"
    }
    
    struct Tag {
        static let CustomerDrawerTitle = 1
        static let CustomerDrawerImage = 7
        static let CustomerDrawerBadge = 31
        
        static let CustomerDrawerName = 48
        static let CustomerDrawerTelephone = 49
        
        static let OrderTypeCellImage = 2
        static let OrderTypeCellTitle = 3
        static let OrderTypeCellDesc = 4
        static let OrderPublishConfirmDesc = 5
        static let OrderPublishConfirmAddress = 6
        
        static let CustomerOrderListCellType = 8
        static let CustomerOrderListCellDesc = 9
        static let CustomerOrderListCellMaintenanceType = 10
        static let CustomerOrderListCellStatus = 11
        static let CustomerOrderListCellReminder = 12
        static let CustomerOrderListCellLeftButton = 13
        static let CustomerOrderListCellRightButton = 14
        
        static let PartsMallLeftCellLabel = 15
        static let PartsMallLeftCellSeperator = 16
        static let PartsMallLeftTableView = 17
        static let PartsMallLeftFooterSeperator = 19
        static let PartsMallRightTableView = 18
        static let PartsMallRightTitle = 20
        static let PartsMallRightPrice = 21
        static let PartsMallRightNum = 22
        static let PartsMallRightAdd = 23
        static let PartsMallRightReduce = 24
        
        static let HandymanDrawerBadgeImage = 25
        static let HandymanDrawerBadgeTitle = 26
        static let HandymanDrawerBadge = 27
        static let HandymanDrawerLabelImage = 28
        static let HandymanDrawerLabelTitle = 29
        static let HandymanDrawerLabel = 30
        
        static let OrderGrabCellType = 31
        static let OrderGrabCellDesc = 32
        static let OrderGrabCellMaintenanceType = 33
        static let OrderGrabCellFee = 34
        static let OrderGrabCellFeeImg = 35
        static let OrderGrabCellDistance = 36
        static let OrderGrabCellTime = 37
        static let OrderGrabCellButton = 38
        
        static let HandymanOrderListCellType = 39
        static let HandymanOrderListCellDesc = 40
        static let HandymanOrderListCellMaintanceType = 41
        static let HandymanOrderListCellStatus = 42
        static let HandymanOrderListCellReminder = 43
        static let HandymanOrderListCellLeftButton = 44
        static let HandymanOrderListCellRightButton = 45
        
        static let HandymanChooseMaintenanceTypeCellTitle = 46
        static let HandymanChooseMaintenanceTypeCellCheck = 47
        
        static let CustomerChooseFeeCellButton = 50
        
        static let MessageCenterCellTitle = 51
        static let MessageCenterCellDate = 52
        static let MessageCenterCellDesc = 53
        
        static let CustomerD2DAccountCellWeek = 54
        static let CustomerD2DAccountCellDate = 55
        static let CustomerD2DAccountCellFee = 56
        static let CustomerD2DAccountCellType = 57
        static let CustomerD2DAccountCellStatus = 58
        
        static let HandymanDrawerName = 1
        static let HandymanDrawerTelephone = 2
    }
    
    struct SegueID {
        static let PubilshOrderSegue = "pubilshOrderSegue"
        static let EditPriceSegue = "editPriceSegue"
        static let ChooseMaintenanceTyeSegue = "chooseMaintenanceTyeSegue"
        static let ChooseLocationSegue = "chooseLocationSegue"
        static let CustomerDrawerToOrderListSegue = "customerDrawerToOrderListSegue"
        static let CustomerDrawerToPersonalInfoSegue = "customerDrawerToPersonalInfoSegue"
        static let CustomerDrawerToMessageCenterSegue = "customerDrawerToMessageCenterSegue"
        static let CustomerDrawerToMallSegue = "customerDrawerToMallSegue"
        static let CustomerDrawerToProjectBidingSegue = "customerDrawerToProjectBidingSegue"
        
        static let ShowPartsMallSegue = "showPartsMallSegue"
        static let ShowCustomerRatingSegue = "showCustomerRatingSegue"
        static let ShowCustomerOrderDetail = "showCustomerOrderDetail"
        static let ShowHandymanInfoSugue = "showHandymanInfoSugue"
        
        static let ShowOrderPublishConfirmSegue = "showOrderPublishConfirmSegue"
        
        static let HandymanMainSegue = "handymanMainSegue"
        static let CustomerMainSegue = "customerMainSegue"
        
        static let ShowGrabListSegue = "showGrabListSegue"
        static let ShowOrderGrabDetailSegue = "showOrderGrabDetailSegue"
        
        static let HandymanDrawerToOrderListSegue = "handymanDrawerToOrderListSegue"
        static let HandymanDrawerToWalletSegue = "handymanDrawerToWalletSegue"
        static let HandymanDrawerToAuditIDSegue = "handymanDrawerToAuditIDSegue"
        static let HandymanDrawerToMessageCenterSegue = "handymanDrawerToMessageCenterSegue"
        static let HandymanDrawerToAuditedSegue = "handymanDrawerToAuditedSegue"
        static let HandymanDrawerToBlacklistSegue = "handymanDrawerToBlacklistSegue"
        
        static let ShowHandymanOrderDetailSegue = "showHandymanOrderDetailSegue"
        static let ShowHandymanD2DAccountSegue = "showHandymanD2DAccountSegue"
        
        static let ShowHandymanChooseMaintenanceTypeSegue = "showHandymanChooseMaintenanceTypeSegue"
        static let ShowHandymanChooseLocationSegue = "showHandymanChooseLocationSegue"
        
        static let ModifyUserInfoSefue = "modifyUserInfoSegue"
        static let CustomerChoosePersonInfoLocationSefue = "customerChoosePersonInfoLocationSefue"
        
        static let ShowD2DAccountSegue = "showD2DAccountSegue"
        static let ShowChangePasswordSegue = "showChangePasswordSegue"
        static let ShowWithDrawSegue = "showWithDrawSegue"
        static let ShowRechargeSegue = "showRechargeSegue"
        static let ShowBindBankCardSegue = "showBindBankCardSegue"
        static let ShowBoundBankCardSegue = "showBoundBankCardSegue"
        static let ShowReceiptSegue = "showReceiptSegue"
        
        static let WithDrawToBindBankCardSegue = "withDrawToBindBankCardSegue"
        static let WithDrawToBoundBankCardSegue = "withDrawToBoundBankCardSegue"
        
        static let ChooseFeeSegue = "chooseFeeSegue"
        
        static let GoPayMFeeSegue = "goPayMFeeSegue"
    }
    
    struct Color {
        static let Primary = UIColor(red: 211/255, green: 68/255, blue: 68/255, alpha: 1.0)
        static let Orange = UIColor(red: 253/255, green: 114/255, blue: 0/255, alpha: 1.0)
        static let Green = UIColor(red: 46/255, green: 204/255, blue: 139/255, alpha: 1.0)
        static let Gray = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        static let Blue = UIColor(red: 38/255, green: 135/255, blue: 253/255, alpha: 1.0)
        static let BlackBackground = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 0.9)
    }
    
    struct Key {
        static let BaiDuMapAK = "Z4AmKrzsUPYk25BPoXhvGHGVqfNfGtWW"
        static let UMAppKey = "56fc95ec67e58eb5ca0009f4"
        static let BuglyAppKey = "FQxNsqd5EzvoM5ct"
        static let BuglyAppID = "900024596"
        static let WechatAppID = "wxe50122ae776cd502"
        static let BeeCloudAppID = "4829b534-625a-4e47-aa66-f511628e1eff"
        static let BeeCloudAppSecret = "e0e435bf-6522-4dd9-8721-4b1be57e82a4"
//        static let WechatAppID = "wxf1aa465362b4c8f1"
//        static let BeeCloudAppID = "c5d1cba1-5e3f-4ba0-941d-9b0a371fe719"
//        static let BeeCloudAppSecret = "39a7a518-9ac8-4a9e-87bc-7885f33cf18c"

    }
    
    struct Role {
        static let Customer = "0"
        static let Handyman = "1"
    }
    
    struct DateFormat {
        static let YMD = "YYYY年MM月dd日"
        static let MDHm = "MM-dd HH:mm"
        static let MD = "MM-dd"
        static let Full = "YYYY-MM-dd HH:mm"
    }
    
    struct ImageSize {
        static let Portrait = 1000 * 1024
        static let Order = 1000 * 1024
    }
   
    static let Success = 0
    static let Failed = 0
}
