//
//  ViewController.swift
//  app
//
//  Created by Егор Кожемин on 13.08.2021.
//

import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var loginField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var loadingView: loadingIndicatorView!
    private var handler: AuthStateDidChangeListenerHandle?

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

        handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if user != nil {
                let navController = UIStoryboard(
                    name: "Main",
                    bundle: nil
                )
                .instantiateViewController(withIdentifier: "MainNavController")
                navController.transitioningDelegate = self
                self?.present(navController, animated: true)
            }
        }
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

    // MARK: firebase user - admin@admin.com / admin123

    @IBAction func login(_: Any) {
        guard
            let username = loginField.text,
            let password = passwordField.text,
            !username.isEmpty,
            !password.isEmpty
        else { return showAlert(type: .error, message: "Incorrect login or password") }

        Auth.auth().signIn(
            withEmail: username,
            password: password
        ) { [weak self] _, authError in
            if let error = authError {
                self?.showAlert(type: .error, message: error.localizedDescription)
            }
        }
    }

    private func showAlert(type: AlertType, message: String) {
        switch type {
        case .error:
            loginField.layer.borderWidth = 1
            loginField.layer.borderColor = UIColor.systemPink.cgColor

            passwordField.layer.borderWidth = 1
            passwordField.layer.borderColor = UIColor.systemPink.cgColor

            let alertController = UIAlertController(
                title: "Ошибка авторизации",
                message: message,
                preferredStyle: .alert
            )

            let alertItem = UIAlertAction(
                title: "Принял",
                style: .cancel
            ) { _ in
                self.passwordField.text = ""
            }

            alertController.addAction(alertItem)
            present(alertController,
                    animated: true,
                    completion: nil)

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
        forPresented _: UIViewController,
        presenting _: UIViewController,
        source _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        navigationAnimator.presenting = true
        return navigationAnimator
    }

    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        navigationAnimator.presenting = false
        return navigationAnimator
    }
}
