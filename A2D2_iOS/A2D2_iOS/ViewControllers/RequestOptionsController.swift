//
//  RequestOptionsController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 11/29/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class RequestOptionsController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    @IBOutlet var dismissKeyboardTap: UITapGestureRecognizer!
    @IBOutlet weak var groupSizePicker: UIPickerView!
    @IBOutlet weak var requesterGenderPicker: UIPickerView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var phoneNumberField: UITextField!
    let groupSizeData = [1,2,3,4]
    let requesterGender = ["Male", "Female"]
    let commentsPlaceholderText = "Comments (Optional)"
    let locationManager = CLLocationManager()
    var ref : DatabaseReference!
    var selectedGroupSize: Int = 0
    var selectedGender: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupSizePicker.delegate = self
        groupSizePicker.dataSource = self
        groupSizePicker.setValue(UIColor.white, forKeyPath: "textColor")
        requesterGenderPicker.delegate = self
        requesterGenderPicker.dataSource = self
        requesterGenderPicker.setValue(UIColor.white, forKeyPath: "textColor")
        textView.delegate = self
        textView.text = commentsPlaceholderText
        textView.textColor = UIColor.lightGray
        locationManager.delegate = self
        nameField.delegate = self
        phoneNumberField.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if  textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.becomeFirstResponder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = commentsPlaceholderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == groupSizePicker){
            return groupSizeData.count
        } else if (pickerView == requesterGenderPicker) {
            return requesterGender.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var str = ""
        if(pickerView == groupSizePicker){
            str = "\(groupSizeData[row])"
            selectedGroupSize = groupSizeData[row]
        } else if (pickerView == requesterGenderPicker) {
            str = "\(requesterGender[row])"
            selectedGender = requesterGender[row]
        }
        return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    
    @IBAction func button(){
        let alert = UIAlertController(title: "Confirm Driver Request", message: "Are you sure you want to dispatch a driver to your current location?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler:{ action in
            self.sendToFirebase(self.buildRequest())
            self.performSegue(withIdentifier: "request_sent", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func buildRequest() -> [String : Any]{
        guard let location = locationManager.location else {
            print("Can't get location.")
            return [:]
        }
        //Avoid sending placeholder text
        let remarks = textView.textColor == UIColor.black ? textView.text : ""
   
        let request = ["status" : "",
                       "gender" : selectedGender,
                       "groupSize" : selectedGroupSize,
                       "remarks" : remarks!,
                       "lat" : location.coordinate.latitude,
                       "lon" : location.coordinate.longitude,
                       "name" : nameField.text!,
                       "phone" : phoneNumberField.text!,
                       "timestamp" : Date().description] as [String : Any]
                        //Format for timestamp is subject to change
        return request
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    func sendToFirebase(_ request: [String : Any]){
        ref = Database.database().reference()
        let key = ref.child("requests").childByAutoId().key!
        ref.child("requests").child(key).setValue(request)
    }
}
