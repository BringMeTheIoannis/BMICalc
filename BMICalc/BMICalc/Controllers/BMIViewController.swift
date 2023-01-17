//
//  ViewController.swift
//  BMICalc
//
//  Created by Ivan Kuzmenkov on 27.10.22.
//

import UIKit
import DropDown

class BMIViewController: UIViewController {

    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var maleCheckMark: UIImageView!
    @IBOutlet weak var femaleCheckMark: UIImageView!
    @IBOutlet weak var weightDataView: UIView!
    @IBOutlet weak var heightDataView: UIView!
    @IBOutlet weak var ageDataView: UIView!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var weightDropDownButton: UIButton!
    @IBOutlet weak var heightDropDownButton: UIButton!
    
    
    
    var isSelectedMaleView = false
    var isSelectedFemaleView = false
    var weight = 80
    var height = 175
    var age = 25
    var viewYOrigin = CGFloat(0)
    let optionsForWeightDropDown = ["kg", "lb"]
    let optionsForHeightDropDown = ["cm", "ft"]
    var isWeightDropdownTouched = false

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGenderView(gender: .male, view: maleView)
        setGenderView(gender: .female, view: femaleView)
        setDataView(view: [weightDataView, weightDropDownButton, heightDataView, heightDropDownButton, ageDataView])
        setupTextField()
        weightTextField.delegate = self
        heightTextField.delegate = self
        ageTextField.delegate = self
        setupHideKeyboardOnTap()
        addDoneButtonToKeyboard()
        moveContentAboveKeyboard()  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewYOrigin = self.view.frame.origin.y
    }
    
    func setGenderView(gender: GenderEnum, view: UIView) {
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 10
        switch gender {
        case .male:
            let maleViewTap = UITapGestureRecognizer(target: self, action: #selector(tapMaleView))
            view.addGestureRecognizer(maleViewTap)
        case .female:
            femaleView.isUserInteractionEnabled = true
            let femaleViewTap = UITapGestureRecognizer(target: self, action: #selector(tapFemaleView))
            view.addGestureRecognizer(femaleViewTap)
        }
    }
    
    
    func setupTextField() {
        weightTextField.text = String(weight)
        heightTextField.text = String(height)
        ageTextField.text = String(age)
    }
    
    func moveContentAboveKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == viewYOrigin {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != viewYOrigin {
            self.view.frame.origin.y = viewYOrigin
        }
    }
    
    func setDataView(view: [UIView]) {
        for index in 0..<view.count{
            view[index].layer.cornerRadius = 10
        }
    }
    
    func colorIfMaleSelected() {
        if isSelectedMaleView {
            maleView.layer.borderWidth = 2
            maleView.layer.borderColor = UIColor.green.cgColor
            maleCheckMark.tintColor = .green
            femaleView.layer.borderColor = UIColor.clear.cgColor
            femaleCheckMark.tintColor = .white
        }
    }
    
    func colorIfFemaleSelected() {
        if isSelectedFemaleView {
            femaleView.layer.borderWidth = 2
            femaleView.layer.borderColor = UIColor.green.cgColor
            femaleCheckMark.tintColor = .green
            maleView.layer.borderColor = UIColor.clear.cgColor
            maleCheckMark.tintColor = .white
        }
    }
    
    @objc func tapMaleView(sender: UITapGestureRecognizer) {
        isSelectedMaleView = true
        isSelectedFemaleView = !isSelectedMaleView
        colorIfMaleSelected()
    }
    
    @objc func tapFemaleView(sender: UITapGestureRecognizer) {
        isSelectedFemaleView = true
        isSelectedMaleView = !isSelectedFemaleView
        colorIfFemaleSelected()
    }
    
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    func addDoneButtonToKeyboard() {
        let doneToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolBar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneToolBarItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonOnKeyboardAction))
        doneToolBar.items = [flexSpace, doneToolBarItem]
        doneToolBar.sizeToFit()
        weightTextField.inputAccessoryView = doneToolBar
        heightTextField.inputAccessoryView = doneToolBar
        ageTextField.inputAccessoryView = doneToolBar
    }
    
    func setDropDown(sender: UIButton, dataSource: [String]) {
        let dropdownObject = DropDown()
        dropdownObject.dataSource = dataSource
        dropdownObject.anchorView = sender
        dropdownObject.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height - 2)
        dropdownObject.clipsToBounds = true
        dropdownObject.layer.cornerRadius = 10
        dropdownObject.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        dropdownObject.show()
        dropdownObject.selectionAction = { [weak self] (index: Int, item: String) in
              guard let _ = self else { return }
              sender.setTitle(item, for: .normal)
        }
    }
    
    @IBAction func weightDropDownAction(_ sender: UIButton) {
        isWeightDropdownTouched = !isWeightDropdownTouched
        setDropDown(sender: sender, dataSource: optionsForWeightDropDown)
    }
    
    @IBAction func heightDropDownAction(_ sender: UIButton) {
        setDropDown(sender: sender, dataSource: optionsForHeightDropDown)
    }
    @objc func doneButtonOnKeyboardAction() {
        weightTextField.resignFirstResponder()
        heightTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
    }
    
    @IBAction func weightPlusButton(_ sender: Any) {
        weight = Int(weightTextField.text ?? "0") ?? 0
        if weight + 1 > 999 {
            return
        }
        weight += 1
        weightTextField.text = String(weight)
    }
    
    @IBAction func weightMinusButton(_ sender: Any) {
        weight = Int(weightTextField.text ?? "0") ?? 0
        if weight - 1 < 0 {
            return
        }
        weight -= 1
        weightTextField.text = String(weight)
    }
    
    @IBAction func heightPlusButton(_ sender: Any) {
        height = Int(heightTextField.text ?? "0") ?? 0
        if height + 1 > 999 {
            return
        }
        height += 1
        heightTextField.text = String(height)
    }
    
    @IBAction func heightMinusButton(_ sender: Any) {
        height = Int(heightTextField.text ?? "0") ?? 0
        if height - 1 < 0 {
            return
        }
        height -= 1
        heightTextField.text = String(height)
    }
    @IBAction func agePlusButton(_ sender: Any) {
        age = Int(ageTextField.text ?? "0") ?? 0
        if age + 1 > 999 {
            return
        }
        age += 1
        ageTextField.text = String(age)
    }
    @IBAction func ageMinusButton(_ sender: Any) {
        age = Int(ageTextField.text ?? "0") ?? 0
        if age - 1 < 0 {
            return
        }
        age -= 1
        ageTextField.text = String(age)
    }
    @IBAction func calculateButton(_ sender: Any) {
//        var bmiIndex: Double = 0.0
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if isSelectedMaleView == false, isSelectedFemaleView == false {
            let alert = UIAlertController(title: "", message: "You should choose gender", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true)
        }
        
        if weightTextField.text == "0" {
            weight = 0
        } else {
            weight = Int(weightTextField.text ?? "0") ?? 0
        }
        if heightTextField.text == "0" {
            height = 0
        } else {
            height = Int(heightTextField.text ?? "0") ?? 0
        }
        if ageTextField.text == "0" {
            age = 0
        } else {
            age = Int(ageTextField.text ?? "0") ?? 0
        }
        
        let heightInMeters = Double(height) / 100
        var bmiIndex = Double(weight) / Double(heightInMeters * heightInMeters) * 100
        bmiIndex = Double (round(bmiIndex) / 100)
        print(height, weight)
        print(bmiIndex)
        let bmiVC = storyboard.instantiateViewController(withIdentifier: String(describing: BMIResultViewController.self)) as? BMIResultViewController
        guard let bmiVC = bmiVC else  { return }
        bmiVC.bmiIndex = bmiIndex
        bmiVC.age = age
//        navigationController?.pushViewController(bmiVC, animated: true)
        navigationController?.present(bmiVC, animated: true)
    }
}

extension UIViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let futureText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let allowCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if string.count < 1, string.count > 3 {
            return true
        }
        return allowCharacters.isSuperset(of: characterSet) && futureText.count <= 3
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "0"
        }
    }
}


