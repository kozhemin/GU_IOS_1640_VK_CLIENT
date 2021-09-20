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
    @IBOutlet var loadingView: loadingIndicatorView!

    lazy var navigationAnimator = Animator()
    
    enum AlertType {
        case error
        case success
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        
        // Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        // Присваиваем его UIScrollVIew
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
        // Запуск анимации индикатора
        loadingView.indicatorAnimation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func login(_: Any) {
        if isValid() {
            showAlert(type: .success)
            let navController = UIStoryboard(
                name: "Main",
                bundle: nil)
                .instantiateViewController(withIdentifier: "MainNavController")
            navController.transitioningDelegate = self
            present(navController, animated: true)
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
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }

    // Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification _: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }

    @objc func hideKeyboard() {
        scrollView?.endEditing(true)
    }
}

extension LoginViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        navigationAnimator.presenting = true
        return navigationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        navigationAnimator.presenting = false
        return navigationAnimator
    }
}
