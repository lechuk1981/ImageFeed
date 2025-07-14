//
//  Constants.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 30.03.2025.
//
import Foundation

public enum Constants {
    public static let accessKey: String = "Kuu9cN4KaYduMfhdABO5usg2Gdt0fS5yplnUcJ9X0eg"
    public static let secretKey: String = "lJVR4Oh8__7xGMOQaoC1A7NXDZ_4LhsmT1uorrUL7E0"
    public static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    public static let accessScope: String = "public+read_user+write_likes"
    public static let defaultBaseURL  = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: Constants.accessKey,
                                     secretKey: Constants.secretKey,
                                     redirectURI: Constants.redirectURI,
                                     accessScope: Constants.accessScope,
                                     authURLString: Constants.unsplashAuthorizeURLString,
                                     defaultBaseURL: Constants.defaultBaseURL)
        }
}
