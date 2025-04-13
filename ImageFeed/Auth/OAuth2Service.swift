//
//  Untitled.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 06.04.2025.
//

import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private init() {}
    
    var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            fatalError("Invalid base URL")
        }
        let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"         // Используем знак ?, чтобы начать перечисление параметров запроса
            + "&&client_secret=\(Constants.secretKey)"    // Используем &&, чтобы добавить дополнительные параметры
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL                           // Опираемся на основной или базовый URL, которые содержат схему и имя хоста
        )!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        print(">>>", request)
        return request
    }
    
    func fetchAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let completionOnMainQueue: (Result<String, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let request = makeOAuthTokenRequest(code: code)
        let task = fetchOAuthTokenResponse(for: request) { [weak self] result in
            guard let self else { fatalError("Unable to create fetch") }
            switch result {
            case .success(let body):
                self.authToken = body.accessToken
                completionOnMainQueue(.success(body.accessToken))
            case .failure(let error):
                completionOnMainQueue(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchOAuthTokenResponse(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
}
