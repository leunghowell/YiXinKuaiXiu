//
//  UtilBox.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/14.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import Foundation
import UIKit
import Photos

class UtilBox {
    // 验证是否为手机号
    static func isTelephoneNum(input: String) -> Bool {
        let regex:NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: "^[1][35789][0-9]{9}$", options: NSRegularExpressionOptions.CaseInsensitive)
            
            let  matches = regex.matchesInString(input, options: NSMatchingOptions.ReportCompletion , range: NSMakeRange(0, input.characters.count))
            
            if matches.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    // 验证是否为身份证号
    static func isIDNum(input: String) -> Bool {
        //let regex:NSRegularExpression
       //do {
//            regex = try NSRegularExpression(pattern: "d{15}|d{18}", options: NSRegularExpressionOptions.CaseInsensitive)
//            
//            let matches = regex.matchesInString(input, options: NSMatchingOptions.ReportCompletion , range: NSMakeRange(0, input.characters.count))
//            
//            if matches.count > 0 {
//                return true
//            } else {
//                return false
//            }
            
            if input.characters.count == 15 || input.characters.count == 18 {
                return true
            } else {
                return false
            }
//        } catch {
//            return false
//        }
    }
    
    // 判断是否为数字
    static func isNum(input: String, digital: Bool) -> Bool {
        let regex:NSRegularExpression
        do {
            if input == "" {
                return true
            }
            
            if digital {
                regex = try NSRegularExpression(pattern: "^[0123456789.]$", options: NSRegularExpressionOptions.CaseInsensitive)
            } else {
                regex = try NSRegularExpression(pattern: "^[0123456789]$", options: NSRegularExpressionOptions.CaseInsensitive)
            }
            
            let  matches = regex.matchesInString(input, options: NSMatchingOptions.ReportCompletion , range: NSMakeRange(0, input.characters.count))
            
            if matches.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    // 判断是否为银行卡号
    static func isBankCardNum(input: String) -> Bool {
        if input.characters.count >= 15 && input.characters.count <= 22 {
            return true
        } else {
            return false
        }
    }
    
    // 字符串转Dic
    static func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    // 设置图片阴影
    static func setShadow(imageView: UIImageView, opacity: Float) {
        imageView.layer.shadowOpacity = opacity
        imageView.layer.shadowColor = UIColor.blackColor().CGColor
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    // 清除用户数据
    static func clearUserDefaults() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        let dictionary = userDefault.dictionaryRepresentation()
        
        for key in dictionary.keys {
            userDefault.removeObjectForKey(key)
            userDefault.synchronize()
        }
        
        Config.Role = nil
        Config.Aid = nil
        Config.TelephoneNum = nil
        Config.VerifyCode = nil
        Config.Location = nil
        Config.LocationInfo = nil
        Config.Company = nil
        Config.Money = nil
        Config.Sex = nil
        Config.IDNum = nil
        Config.MType = nil
        Config.Password = nil
        Config.BankName = nil
        Config.BankNum = nil
        Config.BankOwner = nil
        Config.TotalStar = nil
        Config.MaintenanceNum = nil
        Config.Audited = nil
        Config.PortraitUrl = nil
        Config.ContactName = nil
        Config.ContactTelephone = nil
        Config.Messages = []
        Config.MessagesNum = 0
        Config.OrderNum = 0
        Config.CouponList = []
        Config.ReceiptList = []
    }
    
    // PHAsset转UIImage
    static func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    // 时间戳转字符串
    static func getDateFromString(date: String, format: String) -> String {
        let outputFormat = NSDateFormatter()
        // 格式化规则
        outputFormat.dateFormat = format
        // 定义时区
        outputFormat.locale = NSLocale(localeIdentifier: "shanghai")
        // 发布时间
        let pubTime = NSDate(timeIntervalSince1970: Double(date)!)
        return outputFormat.stringFromDate(pubTime)
    }
    
    // 字符串转时间戳
    static func stringToDate(date: String, format: String) -> NSTimeInterval {
        
        let outputFormatter = NSDateFormatter()
        
        outputFormatter.dateFormat = format
        
        return outputFormatter.dateFromString(date)!.timeIntervalSince1970
    }
    
    static func stringToWeek(date: String) -> String {
        let weekday = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        
        let newDate = NSDate(timeIntervalSince1970: Double(date)!)
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let components = calendar?.component(NSCalendarUnit.Weekday, fromDate: newDate)
        
        return weekday[components! - 1]
    }
    
    // 压缩图片
    static func compressImage(image: UIImage!, maxSize: Int) -> NSData {
        var compression: CGFloat = 1.0
        let maxCompression: CGFloat = 0.1
        
        var imageData = UIImageJPEGRepresentation(image, compression)
        
        while (imageData?.length > maxSize && compression >= maxCompression) {
            compression -= 0.4
            imageData = UIImageJPEGRepresentation(image, compression)
        }
        
        var scale: CGFloat = 0.5
        while(imageData?.length > maxSize && scale >= 0.1) {
            let newSize = CGSizeMake(image.size.width * scale, image.size.height * scale)
            UIGraphicsBeginImageContext(newSize)
            
            image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            imageData = newImage!.asData()
            
            scale -= 0.2
        }
        
        return imageData!
    }
    // MD5加密
    static func MD5(string: String) -> String {
//        let data = string.dataUsingEncoding(NSUTF8StringEncoding)!
//        let c_data = data.bytes
//        var md: [UInt8] = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
//        CC_MD5(c_data, CC_LONG(data.length), UnsafeMutablePointer<UInt8>(md))
//        
//        var ret: String = ""
//        for index in 0 ..< Int(CC_MD5_DIGEST_LENGTH) {
//            ret += String(format: "%.2X", md[index])
//        }
//        return ret
        
        return "a"
    }
    
    // 弹出提示对话框
    static func alert(vc: UIViewController, message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(okAction)
        
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // 弹出提示对话框
    static func funcAlert(vc: UIViewController, message: String, okAction: UIAlertAction?, cancelAction: UIAlertAction?) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        if cancelAction != nil {
            alertController.addAction(cancelAction!)
        }
        if okAction != nil {
            alertController.addAction(okAction!)
        }
        
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // 弹出自定义对话框
    static func showAlertView(parentController: UIViewController, alertViewController: OYSimpleAlertController, message: String, cancelButtonTitle: String, cancelButtonAction: Selector, confirmButtonTitle: String, confirmButtonAction: Selector) {
        
        let alertView = UIView.loadFromNibNamed("AlertView") as! AlertView
        
        alertView.messageLabel.text = message
        
        alertView.cancelButton.setTitle(cancelButtonTitle, forState: .Normal)
        alertView.cancelButton.addTarget(parentController, action: cancelButtonAction, forControlEvents: UIControlEvents.TouchUpInside)
        
        alertView.confirmButton.setTitle(confirmButtonTitle, forState: .Normal)
        alertView.confirmButton.addTarget(parentController, action: confirmButtonAction, forControlEvents: UIControlEvents.TouchUpInside)
        
        alertViewController.initView(alertView)
        
        parentController.presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    // 弹出输入密码对话框
    static func showPwdAlertView(parentController: UIViewController, alertViewController: OYSimpleAlertController, cancelButtonTitle: String, cancelButtonAction: Selector, confirmButtonTitle: String, confirmButtonAction: Selector) {
        
        let alertView = UIView.loadFromNibNamed("EnterPasswordAlertView") as! EnterPasswordAlertView
        
        alertView.cancelButton.setTitle(cancelButtonTitle, forState: .Normal)
        alertView.cancelButton.addTarget(parentController, action: cancelButtonAction, forControlEvents: UIControlEvents.TouchUpInside)
        
        alertView.confirmButton.setTitle(confirmButtonTitle, forState: .Normal)
        alertView.confirmButton.addTarget(parentController, action: confirmButtonAction, forControlEvents: UIControlEvents.TouchUpInside)
        
        alertViewController.initView(alertView)
        
        parentController.presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    // 通过ID查找维修类别名
    static func findMTypeNameByID(id: String) -> String? {
        for mType in Config.MTypes! {
            if mType.id == id {
                return mType.name
            }
        }

        return "找不到这个"
    }
    
    // 通过维修类别名查找ID
    static func findMTypeIDByName(name: String) -> String? {
        
        for mType in Config.MTypes! {
            if mType.name == name {
                return mType.id
            }
        }
        
        return "0"
    }
    
    // 通过配件名查找ID
    static func findPartIDByName(name: String) -> Int? {
        for part in Config.Parts {
            if part.name == name {
                return part.id
            }
        }
        
        return 0
    }
    
    // 通过配件ID查找配件
    static func findPartByID(id: Int) -> Part? {
        for part in Config.Parts {
            if part.id == id {
                return part
            }
        }
        
        return Part(id: 0, name: "没有配件名", num: 0, price: 0, desc: "找不到这个配件", categoryID: 0)
    }
    
    // 通过ID获取vc
    static func getController(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
    // 获取空白页背景
    static func getEmptyView(text: String) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 200))
        label.textAlignment = .Center
        label.textColor = UIColor.lightGrayColor()
        label.text = text
        
        return label
    }
    
    static func reportBug(message: String) {
        Bugly.reportError(NSError(domain: "domain", code: 101, userInfo: ["msg": message]))
    }
    
    static func makeCall(viewController: UIViewController, telephoneNum: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(
            title: "呼叫" + telephoneNum,
            style: .Default)
        { (action: UIAlertAction) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string :"tel://" + telephoneNum)!)
            }
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}

extension Int {
    func toString() -> String {
        let myString = String(self)
        return myString
    }
}

extension UIView {
    class func loadFromNibNamed(nibName:String,bundle : NSBundle? = nil) -> UIView? {
        return UINib(nibName: nibName, bundle: bundle).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}
