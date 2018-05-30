//
// Created by heyongjian on 2018/5/18.
// Copyright (c) 2018 heyongjian. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import Result
import Moya

public final class ResultPlugin: PluginType {

    var showHeader: Bool = false

    var showRequest: Bool = false

    var showResponse: Bool = false

    public init(showHeader: Bool = true, showRequest: Bool = true, showResponse: Bool = true) {
        self.showHeader = showHeader
        self.showRequest = showRequest
        self.showResponse = showResponse
    }

    // MARK: Plugin

    public func willSend(_ request: RequestType, target: TargetType) {
    }

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        handleError(result, target: target)
        handleLog(result, target: target)
    }

    private func handleError(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {

        if case .success(let response) = result {

            switch response.statusCode {
            case 200: // 成功，返回正确的数据，已在PrimitiveSequence的Extension中处理
                break

            default: // 其他错误，并展示错误信息
                let json = try? JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                if let dict = (json as? [String: Any]) {
                    if let api = target as? APIManager, api.isShowError, let obj = Mapper<ErrorResponse>().map(JSON: dict) {
                        print("-----error!")
                    } else {
                        print(dict.jsonString() ?? "")
                    }
                }
            }

        } else {

        }
    }

    private func handleLog(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if case .success(let response) = result {

            guard let urlRequset = response.request else {
                return
            }

            if let httpMethod = urlRequset.httpMethod, let url = urlRequset.url {

                print("-----------------------------")
                print("request method=" + httpMethod)

                if let headers = urlRequset.allHTTPHeaderFields, showHeader {
                    print("request header=" + (headers.jsonString(prettify: true) ?? ""))
                }

                print("request url=" + url.absoluteString)

                switch httpMethod {
                case "POST", "PATCH", "PUT", "DELETE":
                    if let body = urlRequset.httpBody, let stringOutput = String(data: body, encoding: .utf8), showRequest {
                        let jsonData: Data = stringOutput.data(using: .utf8)!
                        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                        if let dict = (dict as? [String: Any]) {
                            print("request data=")
                            print(dict.jsonString(prettify: true) ?? "")
                        }
                    }

                case "GET":
                    break
                default:
                    break
                }
            }

            print("response code=" + "\(response.statusCode)")

            if let stringOutput = String(data: response.data, encoding: .utf8), showResponse {
                let jsonData: Data = stringOutput.data(using: .utf8)!
                let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                if let dict = (dict as? [Any]) {
                    print("response data=\n", dict)
                }

                if let dict = (dict as? [String: Any]) {
                    print("response data=\n", dict)
                }
            }

        } else {

        }
    }

}


extension Dictionary {

    public func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }

    public func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }

        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
            return jsonData
        } catch {
            return nil
        }
    }

    public func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }

        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}


struct ErrorResponse: Mappable {

    var message: [String]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        message <- map["message"]
    }
}
