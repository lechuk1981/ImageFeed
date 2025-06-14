//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 06.04.2025.
//
import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStorageProtocol {
    var token: String? { get set }
}

private enum Keys: String {
    case token
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let newValue else {
                assertionFailure("invalid token")
                return
            }
            KeychainWrapper.standard.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
