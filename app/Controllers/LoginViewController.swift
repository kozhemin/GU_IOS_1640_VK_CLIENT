//
//  ViewController.swift
//  app
//
//  Created by Егор Кожемин on 13.08.2021.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var loginField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    
    enum AlertType {
        case error
        case success
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // Присваиваем его UIScrollVIew
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    @IBAction func login(_: Any) {
        if isValid() {
            showAlert(type: .success)
            print("Успешная авторизация!")
        } else {
            showAlert(type: .error)
        }
    }

    func isValid() -> Bool {
        loginField.text == "admin" && passwordField.text == "admin"
    }

    private func showAlert(type: AlertType) {
        switch type {
        case .error:
            loginField.layer.borderWidth = 1
            loginField.layer.borderColor = UIColor.systemPink.cgColor

            passwordField.layer.borderWidth = 1
            passwordField.layer.borderColor = UIColor.systemPink.cgColor

        case .success:
            loginField.layer.borderWidth = 1
            loginField.layer.borderColor = UIColor.green.cgColor

            passwordField.layer.borderWidth = 1
            passwordField.layer.borderColor = UIColor.green.cgColor
        }
    }
    
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    


}
