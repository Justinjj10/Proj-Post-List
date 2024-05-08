//
//  DetailServiceRequest.swift
//  Proj_Assesment
//
//  Created by Justin Joseph on 07/05/24.
//

import Foundation


typealias GetPoststResponse = (Result<[Posts], Error>) -> Void

protocol PostsRequestType {
    @discardableResult func getAllPosts(page: Int, completion: @escaping GetPoststResponse) -> URLSessionDataTask?
}

struct PostsServiceRequests: PostsRequestType {
    
    @discardableResult func getAllPosts(page: Int, completion: @escaping GetPoststResponse) -> URLSessionDataTask? {
        let contactRequestModel = APIRequestModel(api: PostsAPI.getPosts(page))
        return WebserviceHelper.requestAPI(apiModel: contactRequestModel) { response in
            switch response {
            case .success(let serverData):
                ResponseDecoder.decodeFrom(serverData, returningModelType: [Posts].self, completion: { (allPosts, error) in
                    if let parserError = error {
                        completion(.failure(parserError))
                        return
                    }
                    
                    if let allPosts = allPosts {
                        completion(.success(allPosts))
                        return
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
