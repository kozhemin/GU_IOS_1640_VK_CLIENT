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

    enum AlertType {
        case error
        case success
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            loginField.layer.borderColor = UIColor.red.cgColor

            passwordField.layer.borderWidth = 1
            passwordField.layer.borderColor = UIColor.red.cgColor

        case .success:
            loginField.layer.borderWidth = 1
            loginField.layer.borderColor = UIColor.green.cgColor

            passwordField.layer.borderWidth = 1
            passwordField.layer.borderColor = UIColor.green.cgColor
        }
    }
}
