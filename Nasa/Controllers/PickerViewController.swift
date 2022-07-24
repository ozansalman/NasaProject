//
//  PickerViewController.swift
//  Nasa
//
//  Created by Ozan Salman on 24.07.2022.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var chooseLabel: UILabel!
    
    let const = Const()
    var singleArray: [String] = ["FHAZ","RHAZ","MAST","CHEMCAM","MAHLI","MARDI","NAVCAM","PANCAM","MINITES"]
    var selectedRow = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        const.viewMainCustomWithShadow(view: viewMain)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choseLabelTapped))
        chooseLabel.isUserInteractionEnabled = true
        chooseLabel.addGestureRecognizer(tapGestureRecognizer)
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @objc func choseLabelTapped() {
        Const.singlePicker.selectValue.selectedValue = singleArray[selectedRow]
        NotificationCenter.default.post(name: Notification.Name("singlePickerSelect"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return singleArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return singleArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }


}
