//
//  OperationsExtension.swift
//  TG
//
//  Created by Andrii Narinian on 8/5/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import PSOperations

extension Foundation.BlockOperation {
    public class func createFinishOperation(_ handler: @escaping () -> Void) -> Foundation.BlockOperation {
        let finishOperation = BlockOperation(block: { () -> Void in
            DispatchQueue.main.async {
                handler()
            }
        })
        finishOperation.name = "finishOperation"
        return finishOperation
    }
}

extension GroupOperation {
    public func addOperations(_ operations: [Foundation.Operation]) {
        operations.forEach { addOperation($0) }
    }
}

precedencegroup ChainPrecedence {
    associativity: right
}

infix operator >>> : ChainPrecedence

public func >>> (lhs: Foundation.Operation?, rhs: Foundation.Operation?) -> [Foundation.Operation] {
    if let lhs = lhs, let rhs = rhs {
        rhs.addDependency(lhs)
    }
    return Array.nonNil([lhs, rhs])
}

public func >>> (lhs: Foundation.Operation, rhs: [Foundation.Operation]) -> [Foundation.Operation] {
    if let rhs = rhs.first {
        rhs.addDependency(lhs)
    }
    return [lhs] + rhs
}

public func >>> (lhs: [Foundation.Operation], rhs: Foundation.Operation) -> [Foundation.Operation] {
    if let lhs = lhs.first {
        rhs.addDependency(lhs)
    }
    return lhs + [rhs]
}
