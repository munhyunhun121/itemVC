//
//  SecondViewController.swift
//  scoendP
//
//  Created by 문현권 on 2023/07/06.
//
import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var receivedText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Display the received text in the label
        label.text = receivedText
    }
}
