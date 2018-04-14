//
//  REST.swift
//  Carangas
//
//  Created by Usuário Convidado on 14/04/18.
//  Copyright © 2018 Eric Brito. All rights reserved.
//

import Foundation

enum CarError {
    case url
    case noResponse
    case noData
    case invalidJSON
    case taskError(error: NSError)
    case responseStatusCode(code: Int)
    case invalidJSONModel
}

enum RESTOperation {
    case update
    case delete
    case save
    case get
}

class REST {
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true //permite 3/4 G
        config.httpAdditionalHeaders = ["Content-Type" : "application/json"]
        config.timeoutIntervalForRequest = 30
        config.httpMaximumConnectionsPerHost = 4
        return config
    }()
    private static let session = URLSession(configuration: configuration)
    
    class func applyOperation<T: Codable>(url: String, body: T?, operation: RESTOperation, onComplete: @escaping([T]) -> Void, onError: @escaping(CarError) -> Void) {
        
        var httpMethod = ""
        switch operation {
        case .save:
            httpMethod = "POST"
        case .delete:
            httpMethod = "DELETE"
        case .update:
            httpMethod = "PUT"
        case .get:
            httpMethod = "GET"
        }
        guard let url = URL(string: url) else {
            onError(.url)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        if body != nil {
            request.httpBody = try! JSONEncoder().encode(body!)
        }
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                onError(.taskError(error: error! as NSError))
            }
            else {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    if httpMethod == "GET" {
                        let items = try! JSONDecoder().decode([T].self, from: data)
                        onComplete(items)
                    } else {
                        let item = try! JSONDecoder().decode(T.self, from: data)
                        onComplete([item])
                    }
                    
                }
                else {
                    onError(.responseStatusCode(code: response.statusCode))
                }
            }
        }
        dataTask.resume()
    }
}
