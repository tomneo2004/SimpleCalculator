//
//  SingleOpNode.swift
//  Calculator
//
//  Created by Nelson on 19/7/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

class InvertNode: OperatorNode {
    
    
    override func mergeWithNode(_ node:Node,
                                completeHandler:(Node)->(),
                                appendHandler:(Node)->(),
                                replaceHandler:(Node)->()) {
        
        //we dont accept number node
        //we absorb node
        if let _ = node as? NumberNode{
            completeHandler(self)
            return
        }
        
        //we dont accept decimal node
        //we absorb node
        if let _ = node as? DecimalNode{
            completeHandler(self)
            return
        }
        
        //other operator node shoud replace this node
        replaceHandler(node)
    }
    
    override func valueInString() -> String {
        
        return "+/-"
    }
    
    override func evaluate() -> NumberNode? {
        
        guard let leftHandNode = self.parentNode else{
            fatalError("Invert node must have parent node")
        }
        
        if let numberNode = leftHandNode as? NumberNode{
            
            //inverse sign of number node
            numberNode.invertSign()
            
            //tell brain remove this node
            Brain.sharedBrain.removeNode(self)
            
            return numberNode
        }
        
        fatalError("Invert node's parent node is not a number node")
    }
    
    override func operatorType() -> OperatorType {
        return .SingleInput
    }
    
    override func operatorPriority() -> OperatorPriority {
        
        return .HighPriority
    }
}
