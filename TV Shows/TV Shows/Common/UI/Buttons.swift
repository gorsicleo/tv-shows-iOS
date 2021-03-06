//
//  Buttons.swift
//  TV Shows
//
//  Created by Leo Goršić on 06.02.2022..
//
import UIKit

final class CustomButton: UIButton {
    
    enum ButtonState {
        case normal
        case disabled
    }
    
    private var disabledBackgroundColor: UIColor?
    private var defaultBackgroundColor: UIColor? {
        didSet {
            backgroundColor = defaultBackgroundColor
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled, let color = defaultBackgroundColor {
                backgroundColor = color
            } else if let color = disabledBackgroundColor{
                backgroundColor = color
            }
        }
    }
    
    func setBackgroundColor(_ color: UIColor?, for state: ButtonState) {
        switch state {
        case .disabled:
            disabledBackgroundColor = color
        case .normal:
            defaultBackgroundColor = color
        }
    }
}
