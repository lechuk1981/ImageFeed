//
//  Untitled.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 06.04.2025.
//

import UIKit

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private var task: URLSessionTask?
    private var lastCode: String?
    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    private init() {}
    
    var authToken: String? {
        get {OAuth2TokenStorage().token}
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            fatalError("Invalid base URL")
        }
        let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        )!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        print(">>>", request)
        return request
    }
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let completionOnMainQueue: (Result<String, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            assertionFailure("Failed to make request")
            return
        }
        
        let task = fetchOAuthTokenResponse(for: request) { [weak self] result in
            guard let self else { fatalError("Unable to create fetch") }
            switch result {
            case .success(let body):
                self.authToken = body.accessToken
                completionOnMainQueue(.success(body.accessToken))
            case .failure(let error):
                self.lastCode = nil
                completionOnMainQueue(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    
    func fetchOAuthTokenResponse(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try self.decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
}
