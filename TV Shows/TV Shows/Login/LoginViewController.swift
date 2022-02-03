//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 02.02.2022..

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Private Properties -
    
    private var numberOfClicks = 0
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var flashingColorView: UIView!
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

// MARK: - Extensions -

// MARK: - Setup UI -

private extension LoginViewController {
    
    func setUpUI() {
        setUpTitle()
        setUpView()
    }
    
    func setUpTitle() {
        titleLabel.text = String(numberOfClicks)
    }
    
    func setUpView() {
        flashingColorView.backgroundColor = UIColor.cyan
    }
}

// MARK: - IBAction -

private extension LoginViewController {
    
    @IBAction func incrementAction() {
        numberOfClicks += 1
        titleLabel.text = String(numberOfClicks)
        flashingColorView.backgroundColor =  numberOfClicks % 2 == 0 ? .magenta : .cyan
    }
}
