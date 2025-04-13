//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 13.04.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    
//    private let oauth2Service = OAuth2Service()
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
}
