//
//  APIRequestLoader.swift
//  Demo
//
//  Created by Thinh Vo Duc on 22/04/2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

class APIRequestLoader<T: APIRequestProtocol> {

    let request: T
    let session: URLSession

    init(request: T, session: URLSession = URLSession.shared) {
        self.request = request
        self.session = session
    }

    func loadRequest(requestData: T.ResquestDataType?, completionHandler: @escaping (T.ResponseDataType?, Error?) -> Void) {
        do {
            let urlRequest = try request.createRequest(requestData)
            let dataTask = session.dataTask(with: urlRequest) { (data, urlResponse, error) in
                guard let data = data else {
                    completionHandler(nil, error)
                    return
                }

                do {
                    let responseData = try self.request.parseResponse(data)
                    completionHandler(responseData, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }
            dataTask.resume()
        } catch {
            completionHandler(nil, error)
        }
    }
}
