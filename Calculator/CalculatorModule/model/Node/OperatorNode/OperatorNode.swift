//
//  OperatorNode.swift
//  Calculator
//
//  Created by Nelson on 19/7/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

enum OperatorType{
    case SingleInput
    case DoubleInput
}

enum OperatorPriority : Int{
    
    case LowPriority = 1
    case MediumPriority = 2
    case HighPriority = 3
}

let operatorPriorities : [OperatorPriority]  = [
    
    OperatorPriority.HighPriority,
    OperatorPriority.MediumPriority,
    OperatorPriority.LowPriority
]

protocol OperatorNodeProtocol {
    
    ///Tell operator to perform operation
    ///return nil if fail otherwise return a NumberNode
    ///
    ///When success, node will drop connection include nodes
    ///that involve in operation
    func evaluate() -> NumberNode?
    func operatorType() -> OperatorType
    func operatorPriority() -> OperatorPriority
}

class OperatorNode : Node, OperatorNodeProtocol{
    
    func evaluate() -> NumberNode? {
        
        fatalError("Subclass must override this method")
    }
    
    func operatorType() -> OperatorType {
        
        fatalError("Subclass must override this method")
    }
    
    func operatorPriority() -> OperatorPriority {
        
        fatalError("Subclass must override this method")
    }
    
    
}
