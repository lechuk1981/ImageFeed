//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 30.03.2025.
//

import UIKit

final class AuthViewController: UIViewController {
    private let showAuthViewControllerIdentifier = "ShowWebView"
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        configureBackButton()
//        
//    }
//    
//    private func configureBackButton() {
//        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backward_black") // 1
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backward_black") // 2
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // 3
//        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack") // 4
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthViewControllerIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthViewControllerIdentifier)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO: process code
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
