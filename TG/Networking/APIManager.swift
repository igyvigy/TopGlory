//
//  APIManager.swift
//  TopGlory
//
//  Created by Andrii Narinian on 7/10/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PSOperations

public protocol RouterCompatible: URLRequestConvertible {
    var path: String { get }
}

open class TransferObject: NSObject {
    var json: JSON?
    var object: Any?
    var error: TGError?
}

class APIManager {
    fileprivate static let sharedInstance = APIManager()
    fileprivate lazy var operationQueueValue = PSOperationQueue()
    fileprivate lazy var resultHandlerServiceValue = ResultHandlerService()
    static func operationQueue() -> PSOperationQueue {
        return sharedInstance.operationQueueValue
    }
    static func resultHandlerService() -> ResultHandlerService {
        return sharedInstance.resultHandlerServiceValue
    }
}

class BaseRequestOperation: PSOperation {
    var transferObject: TransferObject
    var path: RouterCompatible
    init(transferObject: TransferObject, path: RouterCompatible) {
        self.transferObject = transferObject
        self.path = path
        super.init()
        addObserver(NetworkObserver())
    }
    
    override func execute() {
        Alamofire.request(path)
            .validate({ validation in
                let result = ErrorService.validateAlamofireDataRequest(validation)
                self.transferObject.error = result.1
                return result.0
            })
            .responseJSON { [weak self] response in
                debugPrint(response)
                ErrorService.validateAlamofireJSONResponse(response, onSuccess: { json in
                    self?.transferObject.json = json
                    self?.finish()
                }, onError: { mhError in
                    self?.transferObject.error = mhError
                    self?.finish()
                })
        }
    }
}

class JSONAPIObjectOperation<M: Model>: GroupOperation {
    var completion: (TGResult<M>) -> Void
    var transferObject: TransferObject
    init(with router: RouterCompatible, completion: @escaping (TGResult<M>) -> Void) {
        transferObject = TransferObject()
        self.completion = completion
        let requestOperation = BaseRequestOperation(transferObject: transferObject, path: router)
        let parseOperation = JSONAPIObjectParseOperations<M>(transferObject: transferObject, completion: completion)
        super.init(operations: requestOperation >>> parseOperation )
        addObserver(NetworkObserver())
    }
}

class JSONAPIArrayOperation<M: Model>: GroupOperation {
    var completion: (TGResult<M>) -> Void
    var transferObject: TransferObject
    init(with router: RouterCompatible, completion: @escaping (TGResult<M>) -> Void) {
        transferObject = TransferObject()
        self.completion = completion
        let requestOperation = BaseRequestOperation(transferObject: transferObject, path: router)
        let parseOperation = JSONAPIParseResponseArrayOperation<M>(transferObject: transferObject, completion: completion)
        super.init(operations: requestOperation >>> parseOperation )
        addObserver(NetworkObserver())
    }
}

class JSONAPIObjectParseOperations<M: Model>: PSOperation {
    var completion: (TGResult<M>) -> Void
    var transferObject: TransferObject
    init(transferObject: TransferObject, completion: @escaping (TGResult<M>) -> Void) {
        self.completion = completion
        self.transferObject = transferObject
        super.init()
        addObserver(NetworkObserver())
    }
    override func execute() {
        DispatchQueue.main.async {
            self.completion(TGResult(jsonApiObject: self.transferObject))
        }
        self.finish()
    }
}

class JSONAPIParseResponseArrayOperation<M: Model>: PSOperation {
    var completion: ((TGResult<M>) -> Void)
    var transferObject: TransferObject
    init(transferObject: TransferObject, completion: @escaping ((TGResult<M>) -> Void) ) {
        self.completion = completion
        self.transferObject = transferObject
        super.init()
        addObserver(NetworkObserver())
    }
    override func execute() {
        DispatchQueue.main.async {
            self.completion(TGResult(jsonApiArray: self.transferObject))
        }
        self.finish()
    }
}
