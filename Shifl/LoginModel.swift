//
//  LoginModel.swift
//  Shifl
//
//  Created by Mohammad Sulthan on 06/12/21.
//

import Foundation

struct LoginModel: Codable {
    let expiresIn: Int
    let message: String
    let token: String
}
