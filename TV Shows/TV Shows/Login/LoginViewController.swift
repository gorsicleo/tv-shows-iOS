//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 02.02.2022..
//

import Foundation

import UIKit

class LoginViewController: UIViewController {
    
    var numberOfClicks = 0
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flashingColorView: UIView!
    
    @IBAction func touchUpAction(_ sender: Any) {
        numberOfClicks += 1
        titleLabel.text = String(numberOfClicks)
        changeRectangleColor(for: numberOfClicks)
    }
    
    func changeRectangleColor(for number: Int) {
        let color: UIColor
        
        if number % 2 == 0 {
            color = UIColor.cyan
        } else {
            color = UIColor.magenta
        }
        
        flashingColorView.backgroundColor = color
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initializing ui components
        titleLabel.text = String(numberOfClicks)
        flashingColorView.backgroundColor = UIColor.cyan
    }
}
