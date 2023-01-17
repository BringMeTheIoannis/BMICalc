//
//  BMIResultViewController.swift
//  BMICalc
//
//  Created by Ivan Kuzmenkov on 1.11.22.
//

import UIKit

class BMIResultViewController: UIViewController {
    
    
    @IBOutlet weak var bmiLabel: UILabel!
    
    var bmiIndex: Double = 0
    var indexText = ""
    var age = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor(red: 3/255, green: 3/255, blue: 3/255, alpha: 0.9).cgColor
        coloredLabelText()
        print(age)
    }
    
    func coloredLabelText() {
        var colorOfBmi: UIColor {
            var color = UIColor.red
            let arrayOfAge = [19...24, 25...34, 35...44, 45...54, 55...64, 65...120]
            let arrayOfBMI = [19...24, 20...25, 21...26, 22...27, 23...28, 24...29]
            
            for i in 0 ..< arrayOfAge.count {
                if arrayOfAge[i].contains(age) && arrayOfBMI[i].contains(Int(bmiIndex)) {
                    color = .green
                }
            }
            return color
        }
        
        let bmiText = "Your BMI: \(String(bmiIndex))"
        let range = (bmiText as NSString).range(of: String(bmiIndex))
        let coloredText = NSMutableAttributedString.init(string: bmiText)
        coloredText.addAttribute(.foregroundColor, value: colorOfBmi, range: range)
        bmiLabel.attributedText = coloredText
    }
    
    @IBAction func closePageButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
