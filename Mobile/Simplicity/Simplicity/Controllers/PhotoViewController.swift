//
//  PhotoViewController.swift
//  Simplicity
//
//  Created by Tanya A on 11/16/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PhotoViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    var imageView : UIImageView!
    let categories = ["Food","Housing","Entertainment"]
    var categoryTextField : UITextField!
    var descriptionTextField : UITextField!
    
    init(capturedImage : UIImageView?) {
        super.init(nibName: nil, bundle: nil)
        self.imageView = capturedImage
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayTextFields()
        displayDropdown()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let mainNavigationBar = MainNavigationBar(frame: view.frame, title: "Add")
        view.addSubview(mainNavigationBar)
        
        imageView.frame = CGRect(x:0, y:144, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height-144)
        self.view.addSubview(imageView)
    
        displaySaveButton()
    }
    
    func displaySaveButton() {
        view.backgroundColor = UIColor.white
        let verticalBottom: CGFloat = UIScreen.main.bounds.maxY
        let horizontalCenter: CGFloat = UIScreen.main.bounds.midX
        
        let saveButton = UIButton(type: .roundedRect)
        saveButton.backgroundColor = UIColor(displayP3Red: 134/256, green: 182/256, blue: 81/256, alpha: 100)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.frame = CGRect(x: self.view.frame.size.width - 20, y: 42, width: 100, height: 40)
        saveButton.center = CGPoint(x: horizontalCenter, y: verticalBottom-40)
        saveButton.setTitle("Save Image", for: UIControlState.normal)
        saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        self.view.addSubview(saveButton)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        // may be useful: textField.resignFirstResponder()
        return true
    }
    
    func displayTextFields() {
        descriptionTextField =  UITextField(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 40))
        descriptionTextField.placeholder = "Enter receipt description here"
        descriptionTextField.font = UIFont.systemFont(ofSize: 15)
        descriptionTextField.borderStyle = UITextBorderStyle.roundedRect
        descriptionTextField.autocorrectionType = UITextAutocorrectionType.no
        descriptionTextField.keyboardType = UIKeyboardType.default
        descriptionTextField.returnKeyType = UIReturnKeyType.done
        descriptionTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        descriptionTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        descriptionTextField.delegate = self
        self.view.addSubview(descriptionTextField)
        
        categoryTextField =  UITextField(frame: CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: 40))
        categoryTextField.placeholder = "Enter category of expense here"
        categoryTextField.font = UIFont.systemFont(ofSize: 15)
        categoryTextField.borderStyle = UITextBorderStyle.roundedRect
        categoryTextField.autocorrectionType = UITextAutocorrectionType.no
        categoryTextField.keyboardType = UIKeyboardType.default
        categoryTextField.returnKeyType = UIReturnKeyType.done
        categoryTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        categoryTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        categoryTextField.delegate = self
        self.view.addSubview(categoryTextField)
    }
    
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row]
        self.view.endEditing(true)
    }
    
    func displayDropdown() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        categoryTextField.inputView = pickerView
    }

    @objc func saveImage() {
        print("Current description \(String(describing: descriptionTextField.text))")
        let description = descriptionTextField.text
        let category = categoryTextField.text
        //send to backend
        let imageData: NSData = UIImageJPEGRepresentation(self.imageView.image!, 0.4)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        DataManager.sharedInstance.postReceiptImgAsync(categoryField: category!, descriptionField: description!, imageData: strBase64, onSuccess: {suggestedTransaction in
            let amount = suggestedTransaction[0].amount
            let transactionId = suggestedTransaction[0].transactionId
            let newAlert = UIAlertController(title: "Confirm Transaction", message: String("Total expense is $"+String(amount)+". Is this correct?"), preferredStyle: UIAlertControllerStyle.alert)
            let confirmAmount = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                let cameraVC = CameraViewController()
                
                DispatchQueue.main.async {
                    self.present(cameraVC, animated: true, completion: nil)
                }
            })
            newAlert.addAction(confirmAmount)
            let denyAmount = UIAlertAction(title: "No", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            newAlert.addAction(denyAmount)
            self.present(newAlert, animated: true, completion: nil)
        }, onFailure: {error in
            print("[PhotoVC][Error] Error in getting data")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
