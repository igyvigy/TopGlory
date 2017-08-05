//
//  ErrorService.swift
//  meter-management
//
//  Created by Andrii Narinian on 5/25/17.
//  Copyright © 2017 Lukas Krauter. All rights reserved.
//

import Alamofire
import UIKit
import SwiftyJSON

typealias Completion = () -> Void
typealias Handler = () -> Void
typealias ErrorCompletion = (TGError) -> Void
typealias JSONCompletion = (JSON) -> Void
typealias StringCompletion = (String) -> Void
typealias DateCompletion = (Date) -> Void
typealias MatchesCompletion = ([Match]) -> Void
typealias ModelsCompletion = ([Model]) -> Void
typealias MatchCompletion = (Match) -> Void


enum TGError: Error {
    case critical(error: NSError)
    case warning(error: NSError)
    case serialization(error: NSError)
//    case errorModels(errorModels: [ErrorModel])
    case custom(text: String)
    case unknown(error: NSError)
    
    var description: String {
        switch self {
        case .critical(let error), .warning(let error), .serialization(let error), .unknown(let error):
            return "\(String(describing: self)) - \(error.localizedDescription)\n\(String(describing: error.localizedFailureReason))\n\(String(describing: error.localizedRecoverySuggestion))"
        case .custom(let text):
            return text
        }
    }
}

//class ErrorModel: Model {
//    enum Fields: String {
//        case code, status, title, detail
//    }
//    
//    var code = ""
//    var status = ""
//    var title = ""
//    var detail = ""
//    
//    override func decode(_ json: JSON, onlyData: Bool = true, jSONStructure: JSONStructure = .jSONApi, jsonApiIncludes: JSON? = nil) {
//        let data = onlyData ? json : json["data"]
//        code = data[Fields.code.rawValue].stringValue
//        status = data[Fields.status.rawValue].stringValue
//        title = data[Fields.title.rawValue].stringValue
//        detail = data[Fields.detail.rawValue].stringValue
//    }
//    
//    override func encode() -> JSON {
//        let returnValue: JSON = [
//            Fields.code.rawValue: code,
//            Fields.status.rawValue: status,
//            Fields.title.rawValue: title,
//            Fields.detail.rawValue: detail
//        ]
//        return returnValue
//    }
//    
//    var infoString: String {
//        return "\(detail) code:\(code)"
//    }
//}

enum TGResultType {
    case jsonApiObject, jsonApiArray
}

struct TGResult<M: Model> {
    var type: TGResultType = .jsonApiObject
    var value: M?
    var values: [M]?
    var error: TGError?

    init (jsonApiArray transferObject: TransferObject) {
        type = .jsonApiArray
        if let error = transferObject.error {
            self.error = error
        } else if let json = transferObject.json {
            var responseObjects: [M] = []
            let jsonObjects = json["data"]
            for (_, objectJSON):(String, JSON) in jsonObjects {
                let object = M(json: objectJSON, included: json["included"].arrayValue.map({ Model(json: $0) }))
                responseObjects.append(object)
            }
            values = responseObjects
        } else {
            self.error = .custom(text: "jsonApiArray - no json")
        }
    }
    
    init (jsonApiObject transferObject: TransferObject) {
        type = .jsonApiObject
        if let error = transferObject.error {
            self.error = error
        } else if let json = transferObject.json {
            value = M(json: json["data"], included: json["included"].arrayValue.map({ Model(json: $0) }))
        } else {
            self.error = .custom(text: "jsonApiObject - no json")
        }
    }
}

class ResultHandlerService {

    var isPresentingLoader = false
    
    var loaderQueue = [String?]()
    
    func completionForObject<M: Model>(withOwner
                                       owner: TGOwner? = nil,
                                       loaderMessage: String? = nil,
                                       control: Control? = nil,
                                       shouldBlockUI: Bool = false,
                                       onSuccess: @escaping (M) -> Void,
                                       onError: Completion? = nil) -> (TGResult<M>) -> Void {
        
        if isPresentingLoader { loaderQueue.append(loaderMessage) }
        let vc = owner ?? UIViewController.presentedVC()
        isPresentingLoader = true
        control?.isControlEnabled = false
        if shouldBlockUI { vc?.view.isUserInteractionEnabled = false }
        if let loaderMessage = loaderMessage {
            vc?.navigationController?.showLoader(message: loaderMessage)
        }
        return { result in
            ErrorService.unwrapResult(forObject: result, withOwner: owner, onSuccess: { model in
                vc?.navigationController?.hideCurrentWhisper {
                    if !self.loaderQueue.isEmpty {
                        self.loaderQueue.removeFirst()
                        self.isPresentingLoader = !self.loaderQueue.isEmpty
                    } else {
                        self.isPresentingLoader = false
                    }
                    control?.isControlEnabled = !self.isPresentingLoader
                    if shouldBlockUI { vc?.view.isUserInteractionEnabled = true }
                }
                onSuccess(model)
            }, onError: { errorString in
                vc?.navigationController?.hideCurrentWhisper {
                    self.loaderQueue = []
                    self.isPresentingLoader = false
                    vc?.showError(message: errorString) {
                        control?.isControlEnabled = true
                        if shouldBlockUI { vc?.view.isUserInteractionEnabled = true }
                    }
                }
                onError?()
            })
        }
    }
    
    func completionForArray<M: Model>(withOwner
                                      owner: TGOwner? = nil,
                                      loaderMessage: String? = nil,
                                      control: Control? = nil,
                                      shouldBlockUI: Bool = false,
                                      onSuccess: @escaping ([M]) -> Void,
                                      onError: Completion? = nil) -> (TGResult<M>) -> Void {
        
        if isPresentingLoader { loaderQueue.append(loaderMessage) }
        let vc = owner ?? UIViewController.presentedVC()
        isPresentingLoader = true
        control?.isControlEnabled = false
        if shouldBlockUI { vc?.view.isUserInteractionEnabled = false }
        if let loaderMessage = loaderMessage {
            vc?.navigationController?.showLoader(message: loaderMessage)
        }
        return { result in
            ErrorService.unwrapResult(forArray: result, withOwner: owner, onSuccess: { models in
                vc?.navigationController?.hideCurrentWhisper {
                    if !self.loaderQueue.isEmpty {
                        self.loaderQueue.removeFirst()
                        self.isPresentingLoader = !self.loaderQueue.isEmpty
                    } else {
                        self.isPresentingLoader = false
                    }
                    control?.isControlEnabled = !self.isPresentingLoader
                    if shouldBlockUI { vc?.view.isUserInteractionEnabled = true }
                }
                onSuccess(models)
            }, onError: { errorString in
                vc?.navigationController?.hideCurrentWhisper {
                    self.loaderQueue = []
                    self.isPresentingLoader = false
                    vc?.showError(message: errorString) {
                        control?.isControlEnabled = true
                        if shouldBlockUI { vc?.view.isUserInteractionEnabled = true }
                    }
                }
                onError?()
            })
        }
    }
}

class ErrorService {
    static func validateAlamofireDataRequest(_ validation: (URLRequest?, HTTPURLResponse, Data?)) -> (Alamofire.Request.ValidationResult, TGError?) {
        if 200..<300 ~= validation.1.statusCode {
            return (.success, nil)
        }
//        else if let data = validation.2 {
//            let jsonError: JSON = JSON(data)["errors"]
//            var errorModels = [ErrorModel]()
//            let jsonObjects = ErrorModel.jsonPath().isEmpty ? jsonError : jsonError[ErrorModel.jsonPath()]
//            for (_, objectJSON):(String, JSON) in jsonObjects {
//                let object = ErrorModel(json: objectJSON)
//                errorModels.append(object)
//            }
//            return (.success, .errorModels(errorModels: errorModels))
//        }
        else {
            let error = NSError(domain: "TG", code: validation.1.statusCode, userInfo: [NSLocalizedDescriptionKey: "unrecognized error"])
            return (.failure(error), .unknown(error: error))
        }
    }
    
    static func validateAlamofireJSONResponse(_ dataResponce: DataResponse<Any>, onSuccess: JSONCompletion, onError: ErrorCompletion) {
        if let object = dataResponce.result.value {
            let json = JSON(object)
            if json != .null {
                onSuccess(json)
            } else {
                let error = NSError(domain: "TG", code: 333, userInfo: [NSLocalizedDescriptionKey: "json value is missing"])
                onError(.serialization(error: error))
            }
        } else if let error = dataResponce.error {
            onError(.critical(error: error as NSError))
        } else {
            let error = NSError(domain: "TG", code: 334, userInfo: [NSLocalizedDescriptionKey: "unknown error"])
            onError(.unknown(error: error))
        }
    }
    
    static func unwrapResult<M: Model>(forObject result: TGResult<M>, withOwner owner: TGOwner?, onSuccess: @escaping (M) -> Void, onError: StringCompletion? = nil) {
        switch result.type {
        case .jsonApiObject:
            DispatchQueue.main.async {
                if let error = result.error {
                    onError?(error.description)
                } else if let value = result.value {
                    onSuccess(value)
                } else {
                    onError?("\(String(describing: result.type.self)) unwrap result: value is missing")
                }
            }
        default:
            DispatchQueue.main.async {
                onError?("result type missmatch")
            }
        }
    }
    
    static func unwrapResult<M: Model>(forArray result: TGResult<M>, withOwner owner: TGOwner?, onSuccess: @escaping ([M]) -> Void, onError: StringCompletion? = nil) {
        switch result.type {
        case .jsonApiArray:
            DispatchQueue.main.async {
                if let error = result.error {
                    onError?(error.localizedDescription)
                } else if let values = result.values {
                    onSuccess(values)
                } else {
                    onError?("\(String(describing: result.type.self)) unwrap result: values are missing")
                }
            }
        default:
            DispatchQueue.main.async {
                onError?("result type missmatch")
            }
        }
    }
}
