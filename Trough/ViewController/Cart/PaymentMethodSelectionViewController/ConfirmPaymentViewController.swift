//
//  ConfirmPaymentViewController.swift
//  Trough
//
//  Created by Imed on 08/07/2021.
//

import UIKit
import GoogleMaps
import CoreLocation


class ConfirmPaymentViewController: BaseViewController,UITextFieldDelegate, ConfirmPaymentDelegate{
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var DeliveryAddress: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cashView: UIView!
    @IBOutlet weak var cardViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var cashViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    
    var cart = [GetCartDetails]()
    
    var lat:Double = 0.0
    var lng:Double = 0.0
    var locationTitle:String = ""
    var locationManager = CLLocationManager()
    
    var paymentId = 0
    var isCod = false
    
    var id = 0
    var evntId = 0
    
    var cardList = [PaymentMethodViewModel].init()
    
    var event :EventViewModel?
   
    var addedCode = ""
    
    var time = Date().string(with: .DATE_TIME_FORMAT_ISO8601)
    
    var errorMessage = ""
    
    var addressOFEvent = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.tableView.sizeToFit()
        self.map()
        self.navigationController?.isNavigationBarHidden = true
        self.total()
        DeliveryAddress.delegate = self
        self.cardView.isHidden = true
        self.cashView.isHidden = true
        self.event?.address = addressOFEvent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllPaymentListRequest()
    }
 
    func  map(){
        self.eventAddressLabel.text = self.event?.address!
        self.addressOFEvent  = self.event?.address! ?? ""
        if self.evntId > 0{
            print(" hidden ")
            self.DeliveryAddress.isHidden = true
            self.DeliveryAddress.addConstraint(DeliveryAddress.heightAnchor.constraint(equalToConstant: 0))
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.isEqual(DeliveryAddress){
            getLocation()
            self.view.endEditing(true)
            return false
        }
        return false
    }
    
    func total(){
        var price = 0
        for i in 0...(self.cart.count) - 1 {
            price += (self.cart[i].price!)
        }
        self.totalAmount.text = "$ \(price)"
    }
    
    func getLocation(){
        
        let sb = UIStoryboard(name: "Settings", bundle: nil)
        if #available(iOS 13.0, *) {
            let vc = sb.instantiateViewController(identifier: "mapViewController") as! mapViewController
            vc.delegate = self
            //            present(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
    func configure(){
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        self.locationManager.delegate = self
        
    }
    func isValidate() -> Bool {
        
        var isValid = true

        if self.evntId == 0{
            if !self.DeliveryAddress.isValidInput(){
                    errorMessage = "Address is required!"
                    isValid = false
                }
        }
//    if !self.DeliveryAddress.isValidInput(){
//            errorMessage = "Email is required!"
//            isValid = false
//        }
        return isValid

    }
    
    
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        //        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionNewPayment(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Cart", bundle: nil)
        if #available(iOS 13.0, *) {
            let vc = sb.instantiateViewController(identifier: "PaymentMethodSelectionViewController") as! PaymentMethodSelectionViewController
            vc.delegate = self
            //            present(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController( vc, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func actionPromo(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "PromotionViewController") as! PromotionViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func paymentAction(_ sender: UIButton) {
        
        if self.evntId > 0{
            print("u have done it")
            self.AddPreOrder()
        }
        else if self.evntId == 0 {
//        else if self.isValidate(){
            self.AddOrder()
        }else{
            self.simpleAlert(title: "Alert", msg: "Add delivery address")
        }
    }
    
    func designview() {
        if(isCod != false && paymentId == 0 ){
            self.cashView.isHidden = false
            self.cardView.isHidden = true
            self.cardViewHeightConstraints.constant = 1
        }
        else{
            self.cashView.isHidden = true
            self.cardView.isHidden = false
            self.cashViewHeightConstraint.constant = 1
        }
    }
}
extension ConfirmPaymentViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! ConfirmPaymentTableViewCell
        cell.cartlist(cart: self.cart[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK:- Location Delegate
extension ConfirmPaymentViewController: GMSMapViewDelegate,CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        if location.coordinate.latitude != 0.0{
            self.locationManager.stopUpdatingLocation()
        }
        
        let marker1 = GMSMarker()
        let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker1.position = currentLocation
        marker1.title = "Map"
        marker1.snippet = "My Location"
    }
    
}
extension ConfirmPaymentViewController: LOCATIONSELECT{
    func locationSelect(address: String, latitude: Double, lognitude: Double) {
        self.DeliveryAddress.text = address
        self.lat = latitude
        self.lng = lognitude
    }
}

extension ConfirmPaymentViewController{
    
    
    
    func AddOrder(){
        let params =
            [
                "isDeliveryRequired" : false,
                                "deliveryAddress"    : self.DeliveryAddress.text ?? "",
//                "deliveryAddress" : event?.address ?? "",
                "instructions"       : "",
                "otherPhoneNumber"   :  "",
                "deliveryCharges"    : 0,
                "isCOD"              : self.isCod,
                "paymentId"          : self.paymentId,
                "pickUpTime" : self.time,
                "promoCode"          :      self.addedCode
            ] as [String : Any]
        print(params)
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.PlaceOrder(params: params) {  (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        self.stopActivity()
                        let alert = UIAlertController(title: "Success", message: "Order has been placed", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) in
                            let vc = self.storyboard?.instantiateViewController(identifier: "CartAnimationViewController") as! CartAnimationViewController
                            self.navigationController?.pushViewController(vc, animated: true)
//                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                case .Failure :
                    GCD.async(.Main) {
                        let alert = UIAlertController(title: "Failed", message: "\(serviceResponse.message)--Order wasn't placed", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) in
                        }))
                        self.present(alert, animated: true, completion: nil)
                        print("Not Found!,Failed")
                    }
                default :
                    GCD.async(.Main) {
                        print("Not Found!")
                    }
                }
            }
        }
    }
    
    func cardSelect(paymentId: Int) {
        self.paymentId = paymentId
        print(self.paymentId)
        self.designview()
        self.isCod = false
    }
    func cashSelect(isCod: Bool) {
        self.isCod = isCod
        print(self.isCod)
        self.designview()
        self.paymentId = 0
    }
}

extension ConfirmPaymentViewController{
    
    func getAllPaymentListRequest(){
        let params =
            [:] as [String : Any]
        let service = ProposalServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.getAllPaymentRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let card = serviceResponse.data as? [PaymentMethodViewModel] {
                            self.cardList = card
                            if card[0].card?.brand != "" &&  card[0].card?.brand != nil{
                                self.cardView.isHidden = false
                                self.cardLabel.text = card[0].card?.brand ?? ""
                                self.cardNumberLabel.text = card[0].card?.last4 ?? ""
                                self.cashViewHeightConstraint.constant = 1
                                self.paymentId = card[0].paymentId ?? 0
                            }
//                            else{
//                                self.designview()
//                            }
                            self.tableView.reloadData()
                            self.stopActivity()
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        self.tableView.reloadData()
                        self.simpleAlert(title: "Alert", msg: serviceResponse.message)
                    }
                default :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert", msg: serviceResponse.message)
                    }
                }
            }
        }
    }
}
extension ConfirmPaymentViewController : PromotionDelegate{
    func didAddCode(code: String) {
        self.addedCode = code
        print(addedCode)
    }
}




extension ConfirmPaymentViewController{
    
    func AddPreOrder(){
        let params =
            [
                "eventId": self.evntId,
                "isDeliveryRequired" : false,
//                "deliveryAddress"    : self.DeliveryAddress.text ?? "",
                "deliveryAddress" : addressOFEvent ?? "",
                "instructions"       : "",
                "otherPhoneNumber"   :  "",
                "deliveryCharges"    : 0,
                "isCOD"              : self.isCod,
                "paymentId"          : self.paymentId,
                "pickUpTime" : self.time,
                "promoCode"          :      self.addedCode
            ] as [String : Any]
        print(params)
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.PlacePreOrder(params: params) {  (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        self.stopActivity()
                        let alert = UIAlertController(title: "Success", message: "Pre Order has been placed", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) in
                            let vc = self.storyboard?.instantiateViewController(identifier: "CartAnimationViewController") as! CartAnimationViewController
                            self.navigationController?.pushViewController(vc, animated: true)
//                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                case .Failure :
                    GCD.async(.Main) {
                        let alert = UIAlertController(title: "Failed", message: "\(serviceResponse.message)--Order wasn't placed", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) in
                        }))
                        self.present(alert, animated: true, completion: nil)
                        print("Not Found!,Failed")
                    }
                default :
                    GCD.async(.Main) {
                        print("Not Found!")
                    }
                }
            }
        }
    }
}
