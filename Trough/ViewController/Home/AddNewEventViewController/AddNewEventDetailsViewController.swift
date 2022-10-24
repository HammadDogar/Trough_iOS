//
//  AddNewEventViewController.swift
//  Trough
//
//  Created by Irfan Malik on 28/12/2020.
//

import UIKit
import MobileCoreServices

class AddNewEventDetailsViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var eventDetailsTextView: UITextView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var btnCameraImage: UIButton!
    @IBOutlet weak var imageContainView: UIView!
    
    var isImageAdded : Bool = false


    var newEventModel = CreateEventViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    func configure(){
        self.imageContainView.clipsToBounds = false
        self.eventDetailsTextView.delegate = self
        self.eventDetailsTextView.text = "Event Details..."
        self.eventDetailsTextView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.eventDetailsTextView.textColor == UIColor.lightGray {
            self.eventDetailsTextView.text = ""
            self.eventDetailsTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.eventDetailsTextView.text == "" {
            self.eventDetailsTextView.text = "Placeholder text ..."
            self.eventDetailsTextView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func actionCamera(_ sender: UIButton){
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (action) in
            self.chooseFromLibrary(presentFrom: sender)
        }))
        alert.addAction(UIAlertAction(title: "Capture", style: .default, handler: { (action) in
            self.capturePhoto(presentFrom: sender)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionBack(_ sender: Any){
        self.mainContainer.currenController?.popViewController(animated: true)
    }
    
    @IBAction func actionNext(_ sender: Any){
        let vc =  UIStoryboard.init(name: StoryBoard.AddEvent.rawValue, bundle: nil) .instantiateViewController(withIdentifier: "InviteTruckViewController") as!
            InviteTruckViewController
         
        
        self.newEventModel.eventType = "public"
        self.newEventModel.EventName = self.eventTitleTextField.text!
        self.newEventModel.Description = self.eventDetailsTextView.text!
        
        if isImageAdded == false{
            simpleAlert(title: "Alert", msg: "Please add Event Image")
            return
        }
        if self.newEventModel.EventName == ""{
            simpleAlert(title: "Alert", msg: "Please add Event name")
            return

        }
        vc.newEventModel = self.newEventModel
        self.mainContainer.currenController?.pushViewController(vc, animated: true)
    }
}

extension AddNewEventDetailsViewController{
    
    func chooseFromLibrary(presentFrom sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.modalPresentationStyle = .formSheet
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func capturePhoto(presentFrom sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .formSheet
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension AddNewEventDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker:  UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                self.eventImageView.image = image
                self.newEventModel.ImageFile = image
                self.isImageAdded = true
                
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
