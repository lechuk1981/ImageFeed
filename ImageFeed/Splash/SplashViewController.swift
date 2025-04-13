//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 13.04.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let oauth2Service = OAuth2Service.shared
    private let showAuthenticationSegue = "Authentication"
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oauth2TokenStorage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationSegue, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            let tabBarController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "TabBarViewController")
            window.rootViewController = tabBarController
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == showAuthenticationSegue {
            guard
              let navigationController = segue.destination as? UINavigationController,
              let viewController = navigationController.viewControllers[0] as? AuthViewController else {
              preconditionFailure("Error with \(showAuthenticationSegue)")
            }
            viewController.delegate = self
          } else {
            super.prepare(for: segue, sender: sender)
          }
        }

        func fetchAuthToken(with code: String) {
            oauth2Service.fetchAuthToken(with: code) { [weak self] result in
            guard let self else { preconditionFailure("Cannot make weak link") }
            switch result {
            case .success(let result):
              print("ITS LIT \(result)")
              dismiss(animated: true)
              self.switchToTabBarController()
            case .failure(let error):
              print("The error \(error)")
            }
          }
        }
      }

      extension SplashViewController: AuthViewControllerDelegate {
        func authViewController(_ viewController: AuthViewController, didAuthenticateWithCode code: String) {
          fetchAuthToken(with: code)
        }
      }

