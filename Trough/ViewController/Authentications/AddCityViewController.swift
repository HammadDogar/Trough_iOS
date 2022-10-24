//
//  AddCityViewController.swift
//  Trough
//
//  Created by Mateen Nawaz on 17/10/2022.
//

import UIKit

class AddCityViewController: BaseViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var selectedCity = ""
    
    var cityList = [ServicesCitesModel]()
    
    
   let dataSource = ["Apple", "Microsoft", "Samsung", "Android", "Google"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        getCityList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func actionSaveCity(_ sender: Any) {
        addCity()
    }
    
    @IBAction func actionFindCity(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestForCityViewController") as! RequestForCityViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension AddCityViewController :  UIPickerViewDelegate, UIPickerViewDataSource  {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if cityList[row].name == "Didn't find your city" {
//            print("bdf")
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestForCityViewController") as! RequestForCityViewController
//            self.present(vc, animated: true, completion: .none)
//        }else {
        cityLabel.text = cityList[row].name
        self.selectedCity = cityList[row].name
//        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return cityList[row].name
        
    }

}



extension AddCityViewController{
    
    
    func getCityList(){
        var params: [String:Any] = [String:Any]()
        params = [:]
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.getServicesCitesList(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let cityList = serviceResponse.data as? [ServicesCitesModel] {
                            self.cityList = cityList
                            var city = ServicesCitesModel()
//                            city.name = "Didn't find your city"
//                            self.cityList.append(city)
                            self.pickerView.reloadComponent(0)
                    }
                    else {
                        print("No City Found!")
                    }
                    self.pickerView.reloadComponent(0)
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("No City Found!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No City Found!")
                    }
                }
            }
        }
    }
    
    
    func addCity(){
        let params =
            [
                "ServicesCity"        : self.selectedCity
//                "userRoleId"        : 3
            ] as [String : Any]
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        print(params)
        let service = UserServices()
        GCD.async(.Default) {
            service.addServicesCity(params: params, ServicesCity:  self.selectedCity) { serviceResponse in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)
                            let alert = UIAlertController(title: "Success", message: "Your city was added", preferredStyle: UIAlertController.Style.alert)
                            
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { (_) in
                      
                            self.moveToHome(isFromNotification: false)
    
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            print("Error adding city")
                        }

                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Error adding city")
                    }
                default :
                    GCD.async(.Main) {
                        print("Error adding city")
                        
                    }
                }
            }
        }
    }
}
