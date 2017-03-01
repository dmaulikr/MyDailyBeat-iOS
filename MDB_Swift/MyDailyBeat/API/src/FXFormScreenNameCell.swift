//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  FXFormScreenNameCell.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 9/21/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import FXForms
class FXFormScreenNameCell: FXFormDefaultCell, UITextFieldDelegate {
    var textField: UITextField!
    var isReturnKeyOverridden: Bool = false


    override func setUp() {
        self.selectionStyle = .none
        self.textLabel?.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin, .flexibleRightMargin]
        self.textField.textAlignment = .right
        self.textField = UITextField(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(200), height: CGFloat(21)))
        self.textField.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin, .flexibleLeftMargin]
        self.textField.font = UIFont.systemFont(ofSize: CGFloat((self.textLabel?.font?.pointSize)!))
        self.textField.textColor = UIColor(red: CGFloat(0.275), green: CGFloat(0.376), blue: CGFloat(0.522), alpha: CGFloat(1.000))
        self.textField.delegate = self
        self.contentView.addSubview(self.textField)
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self.textField, action: NSSelectorFromString("becomeFirstResponder")))
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: self.textField)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        self.textField.delegate = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var labelFrame: CGRect = (self.textLabel?.frame)!
        let size = self.textLabel?.sizeThatFits(CGSize.zero)
        let temp = max((size?.width)!, 97)
        labelFrame.size.width = min(temp, 240)
        self.textLabel?.frame = labelFrame
        var textFieldFrame: CGRect = self.textField.frame
        textFieldFrame.origin.x = (self.textLabel?.frame.origin.x)! + max(97, (self.textLabel?.frame.size.width)!) + 5
        textFieldFrame.origin.y = (self.contentView.bounds.size.height - textFieldFrame.size.height) / 2
        textFieldFrame.size.width = (self.textField.superview?.frame.size.width)! - textFieldFrame.origin.x - 10
        if self.textLabel?.text?.characters.count == 0 {
            textFieldFrame.origin.x = 10
            textFieldFrame.size.width = self.contentView.bounds.size.width - 10 - 10
        }
        else if self.textField.textAlignment == .right {
            textFieldFrame.origin.x = (self.textLabel?.frame.origin.x)! + (labelFrame.size.width) + 5
            textFieldFrame.size.width = (self.textField.superview?.frame.size.width)! - textFieldFrame.origin.x - 10
        }

        self.textField.frame = textFieldFrame
    }

    override func update() {
        self.textLabel?.text = self.field.title
        self.textField.placeholder = (self.field.placeholder as! NSObject).fieldDescription()
        self.textField.text = self.field.fieldDescription()
        self.textField.autocorrectionType = .no
        self.textField.autocapitalizationType = .none
        self.textField.keyboardType = .default
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //welcome to hacksville, population: you
        if !self.isReturnKeyOverridden {
                //get return key type
            var returnKeyType: UIReturnKeyType = .done
            let nextCell: FXFormBaseCell? = self.nextCell as? FXFormBaseCell
            if (nextCell?.canBecomeFirstResponder)! {
                returnKeyType = .next
            }
            self.textField.returnKeyType = returnKeyType
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textField.selectAll(nil)
    }

    func textDidChange() {
        self.updateFieldValue()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.textField.returnKeyType == .next {
            self.nextCell.becomeFirstResponder()
        }
        else {
            self.textField.resignFirstResponder()
        }
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateFieldValue()
        if let action = self.field.action {
            action(self)
        }
    }

    func updateFieldValue() {
        self.field.value = self.textField.text
    }

    override func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return self.textField.resignFirstResponder()
    }
}
