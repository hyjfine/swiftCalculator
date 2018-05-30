//
// Created by heyongjian on 2018/5/18.
// Copyright (c) 2018 heyongjian. All rights reserved.
//
//

import Foundation
import UIKit
import Moya
import Alamofire
import ObjectMapper

// MARK: - Provider setup

let mResultPlugin = ResultPlugin()

private let requestClosure = {
    (endpoint: Endpoint, done: MoyaProvider<APIManager>.RequestResultClosure) in

    do {
        var urlRequest = try endpoint.urlRequest()
        urlRequest.timeoutInterval = 10
        done(.success(urlRequest))
    } catch MoyaError.requestMapping(let url) {
        done(.failure(MoyaError.requestMapping(url)))
    } catch MoyaError.parameterEncoding(let error) {
        done(.failure(MoyaError.parameterEncoding(error)))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

// 开发时可以开启，用于mock api
private let stubClosure: (_ type: APIManager) -> Moya.StubBehavior = { type in
    switch type {
            /*
             Mock数据
             return Moya.StubBehavior.delayed(seconds: 1)
             */
    default:
        return Moya.StubBehavior.never
    }
}

private let endpointClosure = { (target: APIManager) -> Endpoint in
    var url = target.baseURL.absoluteString + "\(target.path)"

    let endpoint: Endpoint = Endpoint(url: url,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers)

    return endpoint
}

private let manager = Manager(
        configuration: URLSessionConfiguration.default,
        serverTrustPolicyManager: ServerTrustPolicyManager(policies: ["kezaihui.com": .disableEvaluation])
)

// 网络请求时更新界面的loading indicator状态
private let networkActivityPlugin = NetworkActivityPlugin {
    (change, target) -> () in
    switch (change) {
    case .ended:
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    case .began:
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
}

let APIProvider = MoyaProvider<APIManager>(endpointClosure: endpointClosure,
        requestClosure: requestClosure,
        stubClosure: stubClosure,
        manager: manager,
        plugins: [networkActivityPlugin, mResultPlugin])

enum APIManager {
    case getNewsLatest // 获取最新消息

    case getNewsDetails(Int) // 获取新闻详情

    func getTargetType() -> BaseTargetType {
        switch self {
        case .getNewsLatest:
            return BaseTargetType(
                    method: .get,
                    path: "4/news/latest"
            )

        case .getNewsDetails(let id):
            return BaseTargetType(
                    method: .get,
                    path: "4/news/\(id)"
            )

        }
    }
}

extension APIManager: TargetType {
    var baseURL: URL {
        return getTargetType().baseURL
    }

    var path: String {
        return getTargetType().path
    }

    var method: Moya.Method {
        return getTargetType().method
    }

    var sampleData: Data { // 可以在这里设置mock数据
        return Data()
    }

    var task: Task {
        return getTargetType().task
    }

    var headers: [String: String]? {
        return getTargetType().headers
    }

    var isShowError: Bool {
        return getTargetType().isShowError
    }

}

struct BaseTargetType {
    var method: Moya.Method

    var path: String

    var task: Task

    var headers: [String: String]?

    var baseURL: URL

    var query: [String: Any]?


    var isShowError: Bool

    init(method: Moya.Method = .get,
         path: String,
         urlParameters: [String: Any] = [:],
         bodyData: [String: Any] = [:],
         isJWT: Bool = true,
         baseURLString: String = "https://news-at.zhihu.com/api/",
         isShowError: Bool = true // respCode非200是否弹框展示错误信息
    ) {
        self.method = method
        self.path = path
        if method == .get {
            self.task = .requestCompositeData(bodyData: Data(), urlParameters: urlParameters)
        } else {
            self.task = .requestParameters(parameters: bodyData, encoding: JSONEncoding.default)
        }
        self.headers = ["Content-Type": "application/json"]
        self.baseURL = URL(string: baseURLString)!
        self.isShowError = isShowError
    }
}

extension BaseTargetType {
    static func getPlatform() -> String {
        return "iOS"
    }

    static func getPushChannel() -> String {
        return "getui"
    }

    static func getAPPName() -> String {
        guard let bundleID = Bundle.main.bundleIdentifier else {
            return ""
        }
        return bundleID
    }
}

