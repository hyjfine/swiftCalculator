//
//  PrimitiveSequence+Extension.swift
//  Calculator
//
//  Created by heyongjian on 2018/5/19.
//  Copyright © 2018年 heyongjian. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {

    // MARK: - object

    func mapToObject<T: Mappable>(type: T.Type) -> Single<T> {
        return mapToResponse()
                .map {
                    guard let result = $0, let dict = result as? [String: Any], !dict.isEmpty else {
                        throw MoyaErrorType.notValidData
                    }

                    guard let obj = Mapper<T>().map(JSON: dict) else {
                        throw MoyaErrorType.mappable
                    }

                    return obj
                }

    }

    // MARK: - array

    func mapToArray<T: Mappable>(type: T.Type) -> Single<[T]> {
        return mapToResponse()
                .map {
                    guard let response = $0 as? [Any], let dicts = response as? [[String: Any]] else {
                        throw MoyaErrorType.notValidData
                    }

                    let array = Mapper<T>().mapArray(JSONArray: dicts)
                    return array
                }
    }

    // MARK: - response

    func mapToResponse() -> Single<Any?> {
        return asObservable().map { response in
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: .allowFragments) else {
                throw MoyaErrorType.json
            }
            guard (200 == response.statusCode) else {
                throw MoyaErrorType.fail
            }
            return json
        }.asSingle()
    }
}

/*
 错误定义
 */
public enum MoyaErrorType: String {
    case json = "json解析异常"
    case mappable = "Mapper解析异常"
    case notValidData = "内容无效"
    case fail = "失败"
}

extension MoyaErrorType: Error {

}
