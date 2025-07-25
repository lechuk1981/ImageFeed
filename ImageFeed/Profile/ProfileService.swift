//
//  Untitled.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 01.05.2025.
//

import  Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private(set) var profile: ProfileResult?
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        
        task?.cancel()
        lastToken = token
        guard var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET") else {
            print("[ProfileService] Failed to make HTTP request")
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let profileResult):
                self.profile = profileResult
                completion(.success(profileResult))
                self.task = nil
            case .failure(let error):
                print("[ProfileService] Profile fetch failed: \(error)")
                completion(.failure(error))
                self.lastToken = nil
            }
        }
        self.task = task
        
        task.resume()
    }
    
    func cleanData() {
        profile = nil
        task?.cancel()
        task = nil
    }
}
