//
//  ViewController.swift
//  KeyboardHandlerMaster
//
//  Created by Piklu Majumder-401 on 12/11/18.
//  Copyright © 2018 Piklu Majumder-401. All rights reserved.
//



import UIKit
import CoreGraphics

class ViewController: UIViewController {
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var mTextFieldFirst: UITextField!
    @IBOutlet weak var mTextFieldSecond: UITextField!
    @IBOutlet weak var mTextFieldThird: UITextField!
    @IBOutlet weak var mTextFieldFourth: UITextField!
    @IBOutlet weak var mTextFieldFifth: UITextField!
    var activeTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegateForTextFields()
        registerForKeyboardNotifications()

    }

    func setUpDelegateForTextFields() {
        mTextFieldFirst.delegate = self
        mTextFieldSecond.delegate = self
        mTextFieldThird.delegate = self
        mTextFieldFourth.delegate = self
        mTextFieldFifth.delegate = self
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // content view tap recognition
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
    }

    @objc func returnTextView(gesture: UIGestureRecognizer) {
        self.activeTextField?.resignFirstResponder()

    }

    @objc func keyboardWillShow(notification: NSNotification) {

        let kbSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        myScrollView.contentInset = contentInset
        myScrollView.scrollIndicatorInsets = contentInset

        var aRect = self.view.frame
        aRect.size.height -= kbSize.height

        let activeTextFieldSuperViewFrame = (activeTextField?.superview?.frame)!
        let activeTextFieldSuperViewOrigin = activeTextFieldSuperViewFrame.origin
        let activeTextFieldSuperViewHeight = activeTextFieldSuperViewFrame.size.height

        var overLappedOrigin = activeTextFieldSuperViewOrigin
        overLappedOrigin.y += activeTextFieldSuperViewHeight
        if !aRect.contains(overLappedOrigin) {
            DispatchQueue.main.async {
                self.myScrollView.scrollRectToVisible(activeTextFieldSuperViewFrame, animated: true)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.myScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.myScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

extension ViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField?.resignFirstResponder()
        activeTextField = nil
        return true
    }


}

