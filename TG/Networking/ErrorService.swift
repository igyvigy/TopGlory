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
typealias MatchesCompletion = ([VMatch]) -> Void
typealias ModelsCompletion = ([VModel]) -> Void
typealias MatchCompletion = (VMatch) -> Void
typealias RosterCompletion = (Roster) -> Void


enum TGError: Error {
    case critical(error: NSError)
    case warning(error: NSError)
    case serialization(error: NSError)
    case errorModels(errorModels: [ErrorModel])
    case custom(text: String)
    case unknown(error: NSError)
    
    var description: String {
        switch self {
        case .critical(let error), .warning(let error), .serialization(let error), .unknown(let error):
            return "\(String(describing: self)) - \(error.localizedDescription)\n\(String(describing: error.localizedFailureReason))\n\(String(describing: error.localizedRecoverySuggestion))"
        case .custom(let text):
            return text
        case .errorModels(let errorModels):
            guard errorModels.count > 0 else { return "empty error model" }
            
            return errorModels.map({ $0.infoString }).reduce("", { $0 == "" ? $1 : $0 + "," + $1 })
        }
    }
}

class ErrorModel {
    enum Fields: String {
        case title
    }
    
    var title = ""
    
    static func from(json: [String: Any]) -> ErrorModel {
        let errorModel = ErrorModel()
        errorModel.title = json[Fields.title.rawValue] as? String ?? ""
        return errorModel
    }
    
    var json: [String: Any] {
        let returnValue: [String: Any] = [
            Fields.title.rawValue: title
        ]
        return returnValue
    }
    
    var infoString: String {
        return "error: \(title)"
    }
}

enum TGResultType {
    case jsonApiObject, jsonApiArray
}

struct TGResult<M: VModel> {
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
            
            var jsonObjects = [JSON]()
            
            if let arrayValue = json["data"].array {
                jsonObjects = arrayValue
            } else {
                jsonObjects = json.arrayValue
            }

            for objectJSON in jsonObjects {
                let object = M(json: objectJSON, included: json["included"].arrayValue.map({ VModel(json: $0) }))
                responseObjects.append(object)
            }
            values = responseObjects
        }
    }
    
    init (jsonApiObject transferObject: TransferObject) {
        type = .jsonApiObject
        if let error = transferObject.error {
            self.error = error
        } else if let json = transferObject.json {
            value = M(json: json["data"], included: json["included"].arrayValue.map({ VModel(json: $0) }))
        }
    }
}

class ResultHandlerService {

    var isPresentingLoader = false
    
    var loaderQueue = [String?]()
    
    func completionForObject<M: VModel>(withOwner
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
    
    func completionForArray<M: VModel>(withOwner
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
        else if let data = validation.2 {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let errors = json?["errors"] as? [[String: Any]] {
                    return (.success, .errorModels(errorModels: errors.map({ ErrorModel.from(json: $0) })))
                }
            }
        }
        let error = NSError(domain: "TG", code: validation.1.statusCode, userInfo: [NSLocalizedDescriptionKey: "unrecognized error"])
        return (.failure(error), .unknown(error: error))
        
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
    
    static func unwrapResult<M: VModel>(forObject result: TGResult<M>, withOwner owner: TGOwner?, onSuccess: @escaping (M) -> Void, onError: StringCompletion? = nil) {
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
    
    static func unwrapResult<M: VModel>(forArray result: TGResult<M>, withOwner owner: TGOwner?, onSuccess: @escaping ([M]) -> Void, onError: StringCompletion? = nil) {
        switch result.type {
        case .jsonApiArray:
            DispatchQueue.main.async {
                if let error = result.error {
                    onError?(error.description)
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
