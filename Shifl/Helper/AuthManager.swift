//
//  AuthManager.swift
//  Shifl
//
//  Created by Mohammad Sulthan on 25/12/21.
//

import Foundation

enum AuthError: Error {
    case missingToken
}

struct Auth: Codable {
    let token: String
}

final class AuthManager {
    static let shared = AuthManager()
    
    private var refreshingToken = false
    private var currentTime: Int = Int(Date().timeIntervalSince1970)
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var tokenExpirationTime: Int? {
        return UserDefaults.standard.integer(forKey: "expiresAt")
    }
    
    private var accessToken: String? {
//        guard let data = KeychainHelper.shared.read(service: "token", account: "shifl", type: Auth.self) else {
//            return nil
//        }
        guard let data = UserDefaults.standard.string(forKey: "token") else {
            return nil
        }
        return data
    }
    
    public var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationTime else {
            return false
        }
        return expirationDate <= currentTime
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            refreshIsNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        }
    }
    
    public func refreshIsNeeded(completion: ((Bool) -> Void)?) {
        guard let url = URL(string: "\(APIManager.Constants.betaBaseURL)refresh-token") else {
            return
        }
        
        refreshingToken = true
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            
            semaphore.signal()
            
            do {
                let result = try JSONDecoder().decode(LoginModel.self, from: data)
                print(result)
                let expiresAt = Int(Date().timeIntervalSince1970) + result.expiresIn
                let token = result.token
                
                // remove first
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "expiresAt")
                
                // re-assign it
                UserDefaults.standard.set(token, forKey: "token")
                UserDefaults.standard.set(expiresAt, forKey: "expiresAt")
                completion?(true)
            } catch {
                print(error)
                completion?(false)
            }
        })
        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}
