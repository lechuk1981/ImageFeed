//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 30.03.2025.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString)!
           urlComponents.queryItems = [
               URLQueryItem(name: "client_id", value: Constants.accessKey),
               URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
               URLQueryItem(name: "response_type", value: "code"),
               URLQueryItem(name: "scope", value: Constants.accessScope)
           ]
           let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    enum WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    } 
}

