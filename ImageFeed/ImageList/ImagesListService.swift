//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 06.07.2025.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let created: String?
    //"updated_at": "2016-07-10T11:00:01-05:00",
    let width: Int
    let height: Int
    
//    "color": "#60544D",
//    "blur_hash": "LoC%a7IoIVxZ_NM|M{s:%hRjWAo0",
//    "likes": 12,
    let urls: UrlsResult
    let likedByUser: Bool
    let description: String?
//    "user": {
//      // ...
//    },
    enum CodingKeys: String, CodingKey {
            case id, width, height, description, urls
            case created = "created_at"
            case likedByUser = "liked_by_user"
        }
}

struct UrlsResult: Decodable {
    let tumb: String
    let full: String
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

final class ImagesListService {
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    private var photos: [Photo] = []

}
