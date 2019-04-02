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
    @IBOutlet var commentsTextView: UITextView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var phoneNumberField: UITextField!
    @IBOutlet var dismissKeyboardSwipe: UISwipeGestureRecognizer!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var submitButton: MyButton!
    
    let groupSizeData = [1,2,3,4]
    let requesterGender = ["Male", "Female"]
    let commentsPlaceholderText = "Comments (Optional)"
    let locationManager = CLLocationManager()
    var selectedGroupSize: Int = 0
    var selectedGender: String = ""
    var requestKey: String!
    var requestData: Request!
    var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupSizePicker.delegate = self
        groupSizePicker.dataSource = self
        groupSizePicker.setValue(UIColor.white, forKeyPath: "textColor")
        requesterGenderPicker.delegate = self
        requesterGenderPicker.dataSource = self
        requesterGenderPicker.setValue(UIColor.white, forKeyPath: "textColor")
        commentsTextView.delegate = self
        commentsTextView.text = commentsPlaceholderText
        commentsTextView.textColor = UIColor.lightGray
        locationManager.delegate = self
        nameField.delegate = self
        phoneNumberField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        scrollView.contentInset.bottom = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)!.cgRectValue.height
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
    }
    
    
    //Handles Placeholder Text for comments field
    func textViewDidBeginEditing(_ textView: UITextView) {
        if  textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.becomeFirstResponder()
        }
    }
    
    
    //Handles Placeholder Text for comments field
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = commentsPlaceholderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    //Dismiss keyboard for comments field when enter is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            commentsTextView.resignFirstResponder()
            return false
        }
        return true
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
    
    
    //Return button function for text fields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == nameField){
            phoneNumberField.becomeFirstResponder()
            return false
        }
        self.view.endEditing(true)
        return false
    }
    
    
    //Live validation for text field edits
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameField {
            return isValidNameInput(string)
        }
        
        if textField == phoneNumberField && isValidPhoneNumberInput(string){
            replaceTextFieldRange(textField: textField, range: range, replacementString: string)
            phoneNumberField.text = SystemUtils.format(phoneNumber: phoneNumberField.text!)
            return false
        }
        return true
    }
    
    
    private func isValidNameInput(_ string: String) -> Bool{
        guard !(string == "") else { return true }
        let Test = NSPredicate(format:"SELF MATCHES %@", "[A-z .]") // Matches any letter or space
        return Test.evaluate(with: string)
    }
    
    
    private func replaceTextFieldRange(textField: UITextField, range: NSRange, replacementString string: String){
        let rangeStart = textField.position(from: textField.beginningOfDocument, offset: range.location)!
        let rangeEnd = textField.position(from: rangeStart, offset: range.length)!
        let textRange = textField.textRange(from: rangeStart, to: rangeEnd)!
        textField.replace(textRange, withText: string)
    }
    
    
    private func isValidPhoneNumberInput(_ string: String) -> Bool{
        guard !(string == "") else { return true }
        let Test = NSPredicate(format:"SELF MATCHES %@", "\\d") // Matches any digit
        return Test.evaluate(with: string)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if hasValidInputs() {
            submitButton.color = submitButton.goodColor
        } else {
            submitButton.color = submitButton.defaultColor
        }
    }
    
    
    @IBAction func requestDriver(){
        guard validateInputs() else { return }
        
        let alert = UIAlertController(title: "Confirm Driver Request", message: "Are you sure you want to dispatch a driver to your current location?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler:{ action in
            self.submitDriverRequest()
        }))
        
        self.present(alert, animated: true)
    }
    
    
    private func submitDriverRequest() {
        self.requestData = self.buildRequest()
        self.requestKey = DataSourceUtils.sendData(data: self.requestData)
        self.performSegue(withIdentifier: "request_sent", sender: self)
    }
    
    
    func buildRequest() -> Request{
        let request = Request()
        guard let location = locationManager.location else {
            print("Can't get location.")
            return request
        }
        
        var phoneNumber = phoneNumberField.text!
        SystemUtils.removeNonNumbers(&phoneNumber)
        request.status = Status.Available
        request.gender = selectedGender
        request.groupSize = selectedGroupSize
        request.remarks = commentsTextView.textColor == UIColor.black ? commentsTextView.text : ""
        request.lat = location.coordinate.latitude
        request.lon = location.coordinate.longitude
        request.name = nameField.text!
        request.phone = phoneNumber
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
    
    
    func hasValidInputs() -> Bool {
        if nameField.text == "" { // Name not empty
            return false
        }
        else if phoneNumberField.text == "" { //Phone Number not empty
            return false
        }
        else if(phoneNumberField.text!.count != 14){ // Phone number requirements. Takes into account the special characters from formatting
            return false
        }
        return true
    }
    
    
    func notify(_ message:String){
        let nilNameAlert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        nilNameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(nilNameAlert, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "request_sent" else { return }
        let statusView = segue.destination as! RideStatusViewController
        statusView.requestKey = self.requestKey
        statusView.requestData = self.requestData
    }
}
