//
//  Hash.swift
//  todo-online
//
//  Created by Majid Jamali on 1/21/25.
//

import Foundation
import CryptoKit

extension SHA256 {
    
    static func hashPassword(_ password: String) -> String? {
        guard let data = password.data(using: .utf8) else {
            return nil
        }
        return SHA256.hash(data: data).description.replacing("SHA256 digest: ", with: "")
    }
}
