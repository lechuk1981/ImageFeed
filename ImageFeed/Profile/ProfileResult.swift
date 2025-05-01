//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 01.05.2025.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}
