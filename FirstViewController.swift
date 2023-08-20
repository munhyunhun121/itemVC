//
//  FirstViewController.swift
//  scoendP
//
//  Created by 문현권 on 2023/07/06.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        textField.delegate = self
    }
    
    // Hide the keyboard when the "Done" button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Prepare to pass data to SecondViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSecondViewController" {
            let secondVC = segue.destination as! SecondViewController
            secondVC.receivedText = textField.text
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showSecondViewController", sender: self)
    }
    
    
    @IBAction func quiz(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "quiz") else {return}
        self.present(nextVC, animated: true)
      }
}
