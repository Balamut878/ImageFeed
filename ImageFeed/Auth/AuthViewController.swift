//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Александр Дудченко on 25.12.2024.
//

import UIKit
import ProgressHUD

// MARK: - Protocol
protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

// MARK: - AuthViewController
final class AuthViewController: UIViewController {
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate?
    
    private let showWebViewSegueIdentifier = "ShowWebView"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
   
    // MARK: - Настройка кнопки назад
    private func configureBackButton() {
        if let navigationController = navigationController {
            navigationController.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
            navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        }
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButtonItem.tintColor = UIColor(named: "YP Black")
        navigationItem.backBarButtonItem = backButtonItem
    }

    // MARK: - Подготовка к переходу на WebView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showWebViewSegueIdentifier else {
            super.prepare(for: segue, sender: sender)
            return
        }

        guard !UIBlockingProgressHUD.isDisplayed(),
              let webViewViewController = segue.destination as? WebViewViewController else {
            assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
            return
        }

        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        
        webViewViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewViewController
        webViewViewController.delegate = self
    }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)

        UIBlockingProgressHUD.show()

        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()

            switch result {
            case .success(let token):
                self.oauth2TokenStorage.token = token
                print("Успешно получен токен: \(token)")

                self.delegate?.didAuthenticate(self, didAuthenticateWithCode: token)
                self.restartAppAfterLogin()

            case .failure(let error):
                print("Ошибка авторизации: \(error.localizedDescription)")
                self.showAuthErrorAlert()
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Показ алерта об ошибке авторизации
    private func showAuthErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true)
    }

    // MARK: - Перезапуск приложения после входа
    private func restartAppAfterLogin() {
        guard let window = UIApplication.shared.windows.first else { return }

        let splashVC = SplashViewController()
        window.rootViewController = splashVC
        window.makeKeyAndVisible()
    }
}
