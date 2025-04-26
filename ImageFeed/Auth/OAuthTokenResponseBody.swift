//
//  struct OAuthTokenResponse.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 06.04.2025.
//

import Foundation

public struct OAuthTokenResponseBody: Decodable {
    var accessToken: String
    var tokenType: String
    var scope: String
    var createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
