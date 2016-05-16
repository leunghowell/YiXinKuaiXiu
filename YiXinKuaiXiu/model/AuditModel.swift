//
//  AuditModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class AuditModel: AuditProtocol {
    var auditDelegate: AuditDelegate?
    
    init(auditDelegate: AuditDelegate) {
        self.auditDelegate = auditDelegate
    }
    
    func doAudit(mTypeIDString: String, location: String, locationInfo: CLLocation, IDNum: String, picture: String, contactsName: String, contactNum: String) {
        let parameters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "fld0": "lxs", "val0": mTypeIDString, "fld1": "sfz", "val1": IDNum, "fld2": "phe", "val2": contactNum, "fld3": "adr", "val3": location]
        
        AlamofireUtil.doRequest(Urls.Audit, parameters: parameters) { (result, response) in
            print(response)
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "lot": locationInfo.coordinate.longitude.description, "lat": locationInfo.coordinate.latitude.description]
                    AlamofireUtil.doRequest(Urls.UpdateLocationInfo, parameters: paramters, callback: { (result, response) in
                        print(response)
                        if result {
                            let json = JSON(UtilBox.convertStringToDictionary(response)!)
                            
                            let ret = json["ret"].intValue

                            if ret == 0 {
                                self.auditDelegate?.onAuditResult(true, info: "")
                            } else if ret == 1 {
                                self.auditDelegate?.onAuditResult(false, info: "认证失败")
                            } else if ret == 1 {
                                self.auditDelegate?.onAuditResult(false, info: "失败")
                            }
                        } else {
                            self.auditDelegate?.onAuditResult(false, info: "申请失败")
                        }
                    })
                } else if ret == 1 {
                    self.auditDelegate?.onAuditResult(false, info: "认证失败")
                } else if ret == 2 {
                    self.auditDelegate?.onAuditResult(false, info: "字段错误")
                } else if ret == 3 {
                    self.auditDelegate?.onAuditResult(false, info: "失败")
                }
            } else {
                self.auditDelegate?.onAuditResult(false, info: "申请失败")
            }
        }
    }
}

protocol AuditDelegate {
    func onAuditResult(result: Bool, info: String)
}