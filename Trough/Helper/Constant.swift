//
//  Constant.swift
//  Trough
//
//  Created by Irfan Malik on 17/12/2020.
//

import Foundation
import UIKit

//DEVICE_TYPE
struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}
struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_XS_MAX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
}
struct AppColor {
    static let tabbarBlueColor = UIColor.init(red: 42/255.0, green: 132/255.0, blue: 239/255.0, alpha: 1.0)
    static let shadowColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
    static let shadowColor2 = UIColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1)
    static let blueAppColor = UIColor.init(red: 33/255.0, green: 129/255.0, blue: 242/255.0, alpha: 1.0)
    static let slotOrangeColor = UIColor.init(rgb: 0xF48C38)
    static let slotRedColor = UIColor.init(rgb: 0xB80F0D)
    static let darkGreenColor = UIColor.init(rgb: 0x1F9E9C)
    static let darkYellowColor = UIColor.init(rgb: 0xBCD32C)
    static let darkBrownColor = UIColor.init(rgb: 0x2F2F2E)
}
struct ProvidersAboutImage {
    static let addressImage = "Address-icon"
    static let webImage = "website-icon"
    static let phoneImage = "phone-icon"
    static let vehicleModel = "vehicle-Model-icon"
    static let vinNumber = "VIN-Number-icon"
}
struct AppFont {
    static let poppinLight = "Poppins-Light"
    static let poppinRegular = "Poppins-Regular"
    static let poppinBold = "Poppins-Bold"
    static let poppinMedium = "Poppins-Medium"
    
}

let KCurrentUser = "currentUser"


