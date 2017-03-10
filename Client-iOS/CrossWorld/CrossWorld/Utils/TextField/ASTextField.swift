//
//  ASTextField.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

@IBDesignable class ASTextField: UITextField {
    
    // MARK: - IBInspectable
    
    /// Color of border when Inactive
    @IBInspectable var inactiveBorderColor: UIColor = UIColor.white {
        didSet {
            updateBorder()
        }
    }
    
    /// Color of border when Active
    @IBInspectable var activeBorderColor: UIColor = UIColor.orange {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable var activePlaceholderColor: UIColor? {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable var inactiveBorderThickness: CGFloat = 0.5 {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable var activeBorderThickness: CGFloat = 2 {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 1 {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable var title: String = "" {
        didSet {
            placeholderLabel.text = title
            updatePlaceholder()
        }
    }
    
    @IBInspectable var isDropdown: Bool = false {
        didSet {
            self.rightViewMode = .always
            self.rightView?.addSubview(UIImageView.init(image: #imageLiteral(resourceName: "ic_dropdown")))
        }
    }
    
    // MARK: - Declare
    
    override open var text: String? {
        didSet {
            if let text = text, !text.isEmpty && isFirstResponder {
                animateViewsForTextEntry()
            } else {
                animateViewsForTextDisplay()
            }
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }
    
    public enum AnimationType: Int {
        case textEntry
        case textDisplay
    }
    
    public typealias AnimationCompletionHandler = (_ type: AnimationType)->()
    
    var animationCompletionHandler: AnimationCompletionHandler?
    private let inactiveBorderLayer = CALayer()
    private let activeBorderLayer = CALayer()
    private let placeholderLabel = UILabel()
    private let placeholderInsets = CGPoint(x: 0, y: -3)
    private let textFieldInsets = CGPoint(x: 0, y: -3)
    private var activePlaceholderPoint: CGPoint = CGPoint.zero
    private var placeholderString: String?
    
    override var placeholder: String? {
        didSet {
            placeholderString = placeholder
        }
    }
    
    // MARK: - Draw
    private func drawViewsForRect(_ rect: CGRect) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        updatePlaceholder()
        updateBorder()
        self.layer.addSublayer(inactiveBorderLayer)
        self.layer.addSublayer(activeBorderLayer)
        self.addSubview(placeholderLabel)
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize)
        return smallerFont
    }
    
    private func updateBorder() {
        inactiveBorderLayer.frame = rectForBorder(inactiveBorderThickness, isFilled: true)
        inactiveBorderLayer.backgroundColor = inactiveBorderColor.cgColor
        
        activeBorderLayer.frame = rectForBorder(activeBorderThickness, isFilled: false)
        activeBorderLayer.backgroundColor = activeBorderColor.cgColor
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = title
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder || !text!.isEmpty {
            animateViewsForTextEntry()
            placeholderLabel.textColor = activePlaceholderColor
        } else {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    private func layoutPlaceholderInTextRect() {
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: placeholderInsets.y,
                                        width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
        activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x, y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height + placeholderInsets.y + 2)
        
    }
    
    private func rectForBorder(_ thickness: CGFloat, isFilled: Bool) -> CGRect {
        if isFilled {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: 0, height: thickness))
        }
    }
    
    // MARK: - animate
    func animateViewsForTextEntry() {
        if text!.isEmpty {
            UIView.animate(withDuration: 3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: ({
                self.placeholderLabel.frame.origin = CGPoint(x: 0, y: self.placeholderLabel.frame.origin.y)
                self.placeholderLabel.alpha = 1
                self.placeholderLabel.font = UIFont.init(name: self.font!.fontName, size: self.font!.pointSize * self.placeholderFontScale)
            }), completion: { _ in
                self.animationCompletionHandler?(.textEntry)
            })
        }
        
        layoutPlaceholderInTextRect()
        placeholderLabel.frame.origin = activePlaceholderPoint
        
        UIView.animate(withDuration: 2, animations: {
            self.placeholderLabel.alpha = 1
        }) { (isSuccess) in
            self.placeholderLabel.textColor = self.activePlaceholderColor
        }
        
        activeBorderLayer.frame = rectForBorder(activeBorderThickness, isFilled: true)
    }
    
    func animateViewsForTextDisplay() {
        if true {
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: ({
                if let clearText = self.text, clearText.isEmpty {
                    self.layoutPlaceholderInTextRect()
                    self.placeholderLabel.font = UIFont.init(name: self.font!.fontName, size: self.font!.pointSize)
                }
                if let clearText = self.text, clearText.isEmpty {
                    self.placeholderLabel.alpha = 1
                    self.placeholderLabel.textColor = self.placeholderColor
                } else {
                    self.placeholderLabel.alpha = 0.55
                    self.placeholderLabel.textColor = self.placeholderColor
                }
                self.activeBorderLayer.frame = self.rectForBorder(self.activeBorderThickness, isFilled: false)
            }), completion: { _ in
                self.animationCompletionHandler?(.textDisplay)
            })
        }
    }
    
    // MARK: - UITextfield
    override func drawPlaceholder(in rect: CGRect) {
        // Dont use default placehoder
    }
    
    override func draw(_ rect: CGRect) {
        drawViewsForRect(rect)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }
    
    open func textFieldDidBeginEditing() {
        animateViewsForTextEntry()
        if let clearText = text, clearText.isEmpty {
            placeholder = placeholderString
        } else {
            placeholder = ""
        }
    }
    
    open func textFieldDidEndEditing() {
        animateViewsForTextDisplay()
    }
    
    // MARK: - Interface Builder
    
    override open func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
    
    override open func willMove(toSuperview newSuperview: UIView!) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
            
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
}
