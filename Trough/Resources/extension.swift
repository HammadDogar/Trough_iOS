//
//  extension.swift
//  Trough
//
//  Created by Irfan Malik on 17/12/2020.
//

import Foundation
import UIKit
import SDWebImage


private var __maxLengths = [UITextField: Int]()

extension UIView {
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    func setShadow(offset : CGSize,color : UIColor,radius : CGFloat,opacity : Float){
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowColor = color.cgColor
        let backgroundCGColor = layer.backgroundColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    func setShadowTop(offset : CGSize,color : UIColor,radius : CGFloat,opacity : Float){
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                     y:  layer.shadowRadius,
                                                     width: bounds.width,
                                                     height:bounds.minY - layer.shadowRadius)).cgPath
        let backgroundCGColor = layer.backgroundColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }
    func setShadowBottom(offset : CGSize,color : UIColor,radius : CGFloat,opacity : Float){
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                     y: bounds.maxY - layer.shadowRadius,
                                                     width: bounds.width + 40,
                                                     height: layer.shadowRadius)).cgPath
        let backgroundCGColor = layer.backgroundColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }
    
    func setBorder(color : UIColor,borderWidth : CGFloat,cornerRadius : CGFloat){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        
    }
    
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = String((t!.prefix(maxLength)))
    }
    
    func isValidInput() -> Bool {
        if text == "" || text == nil {
            return false
        }
        let text1 = text?.replacingOccurrences(of: " ", with: "")
        if text1 == "" || text1 == nil {
            return false
        }
        return true
    }
    func isEmailValid() -> Bool {
               let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
               let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
               return emailPredicate.evaluate(with: self.text)
                 
             }
    func isTextFieldEmpty() -> Bool
          {
            return self.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty ?? true
          }
}

extension UIImageView{
    func setImage(url:URL)  {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_imageIndicator?.startAnimatingIndicator()
        
        self.sd_setImage(with: url) { (img, err, cahce, URI) in
            self.sd_imageIndicator?.stopAnimatingIndicator()
            if err == nil{
                self.image = img
            }else{
                self.image = UIImage(named: "PlaceHolder2")
            }
        }
    }
    
    
    func roundCorner() {
        self.layoutIfNeeded()
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = true
    }
    
//    func set(url: URL, placeholder: String = "placeholder") {
//        self.kf.setImage(with: url,placeholder: UIImage(named: placeholder))
//    }
//
//    func set(urlString: String, placeholder: String = "placeholder") {
//        if let url = URL(string: urlString.replacingOccurrences(of: " ", with: "%20")) {
//            set(url: url, placeholder: placeholder)
//        }else {
//            self.image = UIImage(named: placeholder)
//        }
//    }
//
//    func getImage(urlString: String, completionHandler: @escaping (_ imageSize: CGSize?) -> Void) {
//        if let url = URL(string: urlString) {
//            self.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil) { (result) in
//                switch result {
//                case .success(let value):
//                    let imageSize = value.image.size
//                    completionHandler(imageSize)
//                    break
//                case .failure(_):
//                    completionHandler(nil)
//                    break
//                }
//            }
//        }
//    }
//
//    func set(url: URL, completion: @escaping () -> Void) {
//        self.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil) { (result) in
//            switch result {
//            case .success(_):
//                completion()
//                break
//            case .failure(_):
//                completion()
//                break
//            }
//        }
//    }
}
extension UIView {
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius1: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.gray.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 0.5),
                   shadowOpacity: Float = 0.5,
                   shadowRadius: CGFloat = 2.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
extension Encodable {
    var convertToJSONString: String? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
