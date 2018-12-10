//
//  RequestOptionsController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 11/29/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import UIKit
import CoreLocation

class RequestOptionsController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var groupSizePicker: UIPickerView!
    @IBOutlet weak var requesterGenderPicker: UIPickerView!
    @IBOutlet var textView: UITextView!
    let groupSizeData = [1,2,3,4]
    let requesterGender = ["Male", "Female"]
    let commentsPlaceholderText = "Comments (Optional)"
    let locationManager = CLLocationManager()
    var selectedSize = 0
    var selectedGender = ""
    
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
            selectedSize = groupSizeData[row]
        } else if (pickerView == requesterGenderPicker) {
            str = "\(requesterGender[row])"
            selectedGender = requesterGender[row]
        }
        return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func button(){
        let json = getJSON()
        let alert = UIAlertController(title: "Confirm Driver Request", message: "Are u sure u wan a drivey boi?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes please!", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func getJSON() -> Data{
        var data : Data = Data.init()
        guard let location = locationManager.location else {
            print("This ain't it, chief.")
            return data
        }
        let pageData : [String: Any] = [
            "gender": selectedGender,
            "size" : selectedSize,
            "comments" : textView.text,
            "latitude" : location.coordinate.latitude,
            "longitude" : location.coordinate.longitude]
        if  JSONSerialization.isValidJSONObject(pageData) {
            data = try! JSONSerialization.data(withJSONObject: pageData, options: [])
        }
        return data
    }
}
