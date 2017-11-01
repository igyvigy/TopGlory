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

class TransferObject<M: Model, V: VModel>: NSObject {
    var json: JSON?
    var object: Any?
    var error: TGError?
    var result: TGResult<M, V>?
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

class BaseRequestOperation<M: Model, V: VModel>: PSOperation {
    var transferObject: TransferObject<M, V>
    var path: RouterCompatible
    init(transferObject: TransferObject<M, V>, path: RouterCompatible) {
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

class JSONAPIObjectOperation<M: Model, V: VModel>: GroupOperation {
    var completion: (TGResult<M, V>) -> Void
    var transferObject: TransferObject<M, V>
    init(with router: RouterCompatible, owner: TGOwner?, completion: @escaping (TGResult<M, V>) -> Void) {
        transferObject = TransferObject<M, V>()
        self.completion = completion
        let requestOperation = BaseRequestOperation(transferObject: transferObject, path: router)
        let notifyOperation = NotifyUserOperation(owner: owner, transferObject: transferObject)
        let parseOperation = JSONAPIObjectParseOperations<M, V>(transferObject: transferObject, completion: completion)
        
        super.init(operations: requestOperation >>> notifyOperation >>> parseOperation )
        addObserver(NetworkObserver())
    }
}

class JSONAPIArrayOperation<M: Model, V: VModel>: GroupOperation {
    var completion: (TGResult<M, V>) -> Void
    var transferObject: TransferObject<M, V>
    init(with router: RouterCompatible, owner: TGOwner?, completion: @escaping (TGResult<M, V>) -> Void) {
        transferObject = TransferObject<M, V>()
        self.completion = completion
        let requestOperation = BaseRequestOperation(transferObject: transferObject, path: router)
        let notifyOperation = NotifyUserOperation(owner: owner, transferObject: transferObject)
        let parseOperation = JSONAPIParseResponseArrayOperation<M, V>(transferObject: transferObject, completion: completion)
        
        super.init(operations: requestOperation >>> notifyOperation >>> parseOperation )
        addObserver(NetworkObserver())
    }
}

class JSONAPIObjectParseOperations<M: Model, V: VModel>: PSOperation {
    var completion: (TGResult<M, V>) -> Void
    var transferObject: TransferObject<M, V>
    init(transferObject: TransferObject<M, V>, completion: @escaping (TGResult<M, V>) -> Void) {
        self.completion = completion
        self.transferObject = transferObject
        super.init()
        addObserver(NetworkObserver())
    }
    override func execute() {
        let result: TGResult<M, V> = TGResult(jsonApiObject: self.transferObject)
        self.transferObject.object = result.value
        self.completion(result)
        self.finish()
    }
}

class NotifyUserOperation<M: Model, V: VModel>: PSOperation {
    var transferObject: TransferObject<M, V>
    weak var owner: TGOwner?
    
    init(owner: TGOwner?, transferObject: TransferObject<M, V>) {
        self.owner = owner
        self.transferObject = transferObject
        super.init()
    }
    
    override func execute() {
        if transferObject.json != nil {
            DispatchQueue.main.async { [unowned self] in
                self.owner?.navigationController?.showLoader(message: "building data")
            }
        }
        
        self.finish()
    }
}

class JSONAPIParseResponseArrayOperation<M: Model, V: VModel>: PSOperation {
    var completion: ((TGResult<M, V>) -> Void)
    var transferObject: TransferObject<M, V>
    init(transferObject: TransferObject<M, V>, completion: @escaping ((TGResult<M, V>) -> Void) ) {
        self.completion = completion
        self.transferObject = transferObject
        super.init()
        addObserver(NetworkObserver())
    }
    override func execute() {
        let result: TGResult<M, V> = TGResult(jsonApiArray: self.transferObject)
        transferObject.result = result
        if let models = result.values {
            models.forEach { model in FirebaseHelper.save(model: model) }
        }
        self.completion(result)
        self.finish()
    }
}


//class FirebaseUpdateArrayOperation<M: VModel>: PSOperation {
//    var transferObject: TransferObject
//    var completion: (TGResult<M>) -> Void
//    init(transferObject: TransferObject, completion: @escaping ((TGResult<M>) -> Void) ) {
//        self.transferObject = transferObject
//        super.init()
//        addObserver(NetworkObserver())
//    }
//    override func execute() {
//        
//        completion
//        self.finish()
//    }
//}
