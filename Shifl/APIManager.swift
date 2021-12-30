//
//  APIManager.swift
//  Shifl
//
//  Created by Mohammad Sulthan on 13/12/21.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    
    struct Constants {
        static let betaBaseURL = "https://beta.shifl.com/api/"
        static let frontendBaseUrl = "https://app.shifl.com/"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
//    public func loadDashboardWeb(completion: @escaping (Result<Any, Error>) -> Void) {
//        createRequest(with: URL(string: Constants.frontendBaseUrl + "/shipments"), type: .get) { baseRequest in
//            let _ = URLSession.shared.dataTask(with: baseRequest) { data, response, error in
//                guard let data = data, error == nil else {
//                    print("Error when fetching: \(error!)")
//                    return
//                }
//                completion(.success(data))
//            }
//        }
//    }
    
    public func login(email: String, password: String, completion: @escaping (Result<LoginModel, Error>) -> Void) {
        let url = URL(string: Constants.betaBaseURL + "login")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        let postString = "email=\(email)&password=\(password)";
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            semaphore.signal()
            
            do {
                let result = try JSONDecoder().decode(LoginModel.self, from: data)
                let expiresAt = Int(Date().timeIntervalSince1970) + result.expiresIn
                let token = result.token
                
//                KeychainHelper.shared.save(Data(token.utf8), service: "token", account: "shifl")
                UserDefaults.standard.set(token, forKey: "token")
                UserDefaults.standard.set(expiresAt, forKey: "expiresAt")
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        semaphore.wait()
    }
    
    // MARK: - Private
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
