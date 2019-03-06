//
//  RequestOptionsController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 11/29/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import UIKit
import CoreLocation

class RequestOptionsController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    @IBOutlet var dismissKeyboardTap: UITapGestureRecognizer!
    @IBOutlet weak var groupSizePicker: UIPickerView!
    @IBOutlet weak var requesterGenderPicker: UIPickerView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var phoneNumberField: UITextField!
    @IBOutlet var dismissKeyboardSwipe: UISwipeGestureRecognizer!
    
    let groupSizeData = [1,2,3,4]
    let requesterGender = ["Male", "Female"]
    let commentsPlaceholderText = "Comments (Optional)"
    let locationManager = CLLocationManager()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let textViewOriginY = textView.frame.origin.y
            if textView.frame.origin.y == textViewOriginY && textView.isFirstResponder {
                if textView.frame.origin.y >= keyboardSize.height {
                    self.view.frame.origin.y -= keyboardSize.height/2
                }
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameField { // Real-time validation for name field
            //Prepare a RegEx filter for the name field
            let Test = NSPredicate(format:"SELF MATCHES %@", "[A-z .]") // Matches any letter or space
            
            if (Test.evaluate(with: string)) {
                return true
            }
        }
        if textField == phoneNumberField {
        var fullString = textField.text ?? ""
        fullString.append(string)
        if range.length == 1 {
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
        } else {
            textField.text = format(phoneNumber: fullString)
        }
        return false
        }
        else { return true }
    }
    
    func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)A-z.*#,/+=]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }
        
        return number
    }
    
    
    @IBAction func requestDriver(){
        if(!validateInputs()){ return }//Validate Inputs
        let alert = UIAlertController(title: "Confirm Driver Request", message: "Are you sure you want to dispatch a driver to your current location?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler:{ action in
            DataSourceUtils.sendData(data: self.buildRequest())
            self.performSegue(withIdentifier: "request_sent", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func buildRequest() -> Request{
        let request = Request()
        guard let location = locationManager.location else {
            print("Can't get location.")
            return request
        }
        //Avoid sending placeholder text
        let remarks = textView.textColor == UIColor.black ? textView.text : ""
        var unformattedPhoneNumberField = phoneNumberField.text!
        
        //removing the special characters from the phone number field. There's probably a better way to do this ¯\_(ツ)_/¯
        unformattedPhoneNumberField = unformattedPhoneNumberField.replacingOccurrences(of: "(", with: "")
        unformattedPhoneNumberField = unformattedPhoneNumberField.replacingOccurrences(of: ")", with: "")
        unformattedPhoneNumberField = unformattedPhoneNumberField.replacingOccurrences(of: " ", with: "")
        unformattedPhoneNumberField = unformattedPhoneNumberField.replacingOccurrences(of: "-", with: "")
        
        request.status = Status.Available
        request.gender = selectedGender
        request.groupSize = selectedGroupSize
        request.remarks = remarks!
        request.lat = location.coordinate.latitude
        request.lon = location.coordinate.longitude
        request.name = nameField.text!
        request.phone = unformattedPhoneNumberField
        request.timestamp = Date()
        
        return request
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @IBAction func swipeHandler(_ sender : UISwipeGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
        }
    }

    
    func validateInputs()-> Bool {
        if nameField.text == "" { // Name not empty
            notify("Name is a required field.")
            return false
        }
        else if phoneNumberField.text == "" { //Phone Number not empty
            notify("Phone number is a required field.")
            return false
        }
        else if(phoneNumberField.text!.count != 14){ // Phone number requirements. Takes into account the special characters from formatting
            notify("Invalid Phone Number.")
            return false
        }
        return true
    }
    
    
    func notify(_ message:String){
        let nilNameAlert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        nilNameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(nilNameAlert, animated: true)
    }
}
