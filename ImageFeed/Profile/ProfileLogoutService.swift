//
//  Untitled.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 06.07.2025.
//

import Foundation
import WebKit
import SwiftKeychainWrapper

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        ProfileService.shared.cleanData()
        ProfileImageService.shared.cleanData()
        ImagesListService.shared.cleanData()
        KeychainWrapper.standard.removeObject(forKey: "token")
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

