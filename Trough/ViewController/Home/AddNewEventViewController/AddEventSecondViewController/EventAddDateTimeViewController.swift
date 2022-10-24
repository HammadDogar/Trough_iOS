//
//  EventAddDateTimeViewController.swift
//  Trough
//
//  Created by Imed on 26/08/2021.
//

import UIKit

class EventAddDateTimeViewController: BaseViewController  {
    
    @IBOutlet weak var selectEventDateTextField: UITextField!
    @IBOutlet weak var selectEventTimeTextField: UITextField!
    @IBOutlet weak var selectEventEndTimeTextField: UITextField!

    
    @IBOutlet weak var eventTitleTextField: UITextField!
    
    
    
    var newEventModel = CreateEventViewModel()
    
    let myPickerView = UIPickerView()
    var currentList:[String] = []
    var activeTextField:UITextField!
   
    var dateString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
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
    
    func configure(){
        
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        
        let pickerDate = UIDatePicker()
        pickerDate.datePickerMode = .date
        pickerDate.minimumDate = Date()
        if #available(iOS 13.4, *) {
            pickerDate.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        self.selectEventDateTextField.inputView = pickerDate
        pickerDate.addTarget(self, action: #selector(dateIsChanged(sender:)), for: .valueChanged)
        
        let pickerTime = UIDatePicker()
        pickerTime.datePickerMode = .time
        pickerTime.locale = Locale.init(identifier: "en_gb")
        
        if #available(iOS 13.4, *) {
            pickerTime.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.selectEventTimeTextField.inputView = pickerTime
        
        pickerTime.addTarget(self, action: #selector(TimeIsChanged(sender:)), for: .valueChanged)
        
        let pickerEndTime = UIDatePicker()
        pickerEndTime.datePickerMode = .time
        pickerEndTime.locale = Locale.init(identifier: "en_gb")
        
        if #available(iOS 13.4, *) {
            pickerEndTime.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.selectEventEndTimeTextField.inputView = pickerEndTime
        pickerEndTime.addTarget(self, action: #selector(EndTimeIsChanged(sender:)), for: .valueChanged)
        
    }
    
    @objc func dateIsChanged(sender: UIDatePicker){
        print("date is selected")
        let convertedDate = sender.date.string(with: .DATE_TIME_FORMAT_ISO8601)
        
        self.dateString = convertedDate
        
        let onlyDate = sender.date.string(with: .DATE_FORMAT_M)
        
        self.selectEventDateTextField.text = onlyDate
        print("Date: ", convertedDate)
        //        self.newEventModel.EventSlots.startDate = convertedDate
    }
    
    @objc func TimeIsChanged(sender: UIDatePicker){
        print("Time is selected")
        
        let convertedTime = sender.date.string(with: .TIME_FORMAT_24)
        self.selectEventTimeTextField.text = convertedTime
        print("Time: ", convertedTime)
        //        self.newEventModel.EventSlots[0].startTime = convertedTime
        
    }
    
    @objc func EndTimeIsChanged(sender: UIDatePicker){
        print("Time is selected")
        let convertedTime = sender.date.string(with: .TIME_FORMAT_24)
        self.selectEventEndTimeTextField.text = convertedTime
        print("Time: ", convertedTime)
        //        self.newEventModel.EventSlots[0].endTime = convertedTime
        
    }
    
    @IBAction func addDate(_ sender: Any) {
        if selectEventDateTextField.text == "Select Date" {
            let onlyDate = Date().string(with: .DATE_FORMAT_M)
            self.selectEventDateTextField.text = onlyDate
        }

    }
    
    @IBAction func addTime(_ sender: Any) {
        if selectEventTimeTextField.text == "Select Time"{
            let time = Date().string(with: .TIME_FORMAT_24)
            self.selectEventTimeTextField.text = time
        }

    }
    
    @IBAction func addEndTime(_ sender: Any) {
        if selectEventEndTimeTextField.text == "Select Time"{
            let converted = Date().string(with: .TIME_FORMAT_24)
            self.selectEventEndTimeTextField.text = converted
        }
    }
    
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionNext(_ sender: UIButton) {
        
        let vc =  UIStoryboard.init(name: StoryBoard.AddEvent.rawValue, bundle: nil) .instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
        
        self.newEventModel.EventSlots.removeAll()
        self.newEventModel.EventSlots.append(NewEventSlotsViewModel(sDate: dateString, sTime: self.selectEventTimeTextField.text!, eTime: self.selectEventEndTimeTextField.text!))
        
        if self.newEventModel.EventSlots[0].startDate == ""{
            simpleAlert(title: "Alert", msg: "Date is Required")
            return
        }
        if self.newEventModel.EventSlots[0].startTime == "Select Time" || self.newEventModel.EventSlots[0].endTime == "Select Time"{
            simpleAlert(title: "Alert", msg: "Time is Required")
            return
        }
       
        vc.newEventModel = self.newEventModel
        
        self.mainContainer.currenController?.pushViewController(vc, animated: true)
        
    }
}
extension EventAddDateTimeViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.currentList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.currentList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}
