//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 06.07.2025.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let urls: UrlsResult
    let likedByUser: Bool
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id, width, height, description, urls
        case createdAt = "created_at"
        case likedByUser = "liked_by_user"
    }
}

struct UrlsResult: Decodable {
    let thumb: String
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
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var loading = false
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private static let dateFormatter = ISO8601DateFormatter()
    
    func fetchPhotosNextPage() {
        guard !loading else { return }
        loading = true
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        let urlString = "https://api.unsplash.com/photos?page=\(nextPage)&per_page=\(15)"
        guard let url = URL(string: urlString) else {
            loading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(Constants.accessKey)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            self.loading = false
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let photoResults = try decoder.decode([PhotoResult].self, from: data)
                    let newPhotos = photoResults.map { result in
                        Photo(
                            id: result.id,
                            size: CGSize(width: result.width, height: result.height),
                            createdAt: Self.dateFormatter.date(from: result.createdAt ?? ""),
                            welcomeDescription: result.description,
                            thumbImageURL: result.urls.thumb,
                            largeImageURL: result.urls.full,
                            isLiked: result.likedByUser
                        )
                    }
                    DispatchQueue.main.async {
                        self.photos.append(contentsOf: newPhotos)
                        self.lastLoadedPage = nextPage
                        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            } else if let error = error {
                print("Loading error: \(error)")
            }
        }
        task.resume()
    }
    
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = OAuth2TokenStorage().token else {
            print("Error: Token is nil")
            return
        }
        
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            print("Error:URL is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   (200..<300).contains(response.statusCode) {
                    completion(.success(()))
                } else {
                    print("[ImagesListService]: Error: Invalid request status code")
                }
            }
        }
        task.resume()
    }
    
    func cleanData() {
        photos = []
        OAuth2TokenStorage.shared.token = nil
        task?.cancel()
        task = nil
    }
}
