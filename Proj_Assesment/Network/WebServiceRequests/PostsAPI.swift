//
//  DetailsAPI.swift
//  Proj_Assesment
//
//  Created by Justin Joseph on 07/05/24.
//

import Foundation

///  This API will hold all APIs related to restaurant
enum PostsAPI {
    case getPosts(_ page: Int)
}

extension PostsAPI: APIProtocol {
    func httpMthodType() -> HTTPMethodType {
        var methodType = HTTPMethodType.get
        switch self {
        case .getPosts(_):
            methodType = .get
        }
        return methodType
    }

    func apiEndPath() -> String {
        var apiEndPath = ""
        switch self {
        case .getPosts(let page):
            apiEndPath += WebserviceConstants.detailsAPI + "page=\(page)&limit=10"
        }
        return apiEndPath
    }

    func apiBasePath() -> String {
        switch self {
        case .getPosts(_):
            return WebserviceConstants.baseURL
        }
    }
}
