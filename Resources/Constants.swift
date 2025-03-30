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
}
