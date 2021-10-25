//
//  SignInAPI.swift
//  SignInWithUserAccount
//
//  Created by haanwave on 2021/10/25.
//

import Foundation
import Alamofire

struct SignInAPI {
    static func signIn(id: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        let url = "https://api.sample.com/account"
        let parameters: Parameters = ["id": id, "password": password]
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let accessToken = response.response?.headers["accessToken"] {
                        completion(accessToken, nil)
                        print("--->[SignInAPI:signIn] Sign In Success")
                    }
                case .failure(let error):
                    print("--->[SignInAPI:signIn] ERROR:", error)
                    completion(nil, error)
                }
            }
    }
}
