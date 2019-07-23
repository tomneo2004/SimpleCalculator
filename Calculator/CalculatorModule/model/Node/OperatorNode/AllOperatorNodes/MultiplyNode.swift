//
//  MutiplyNode.swift
//  Calculator
//
//  Created by Nelson on 20/7/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

class MultiplyNode: OperatorNode {
    
    
    override func mergeWithNode(_ node:Node,
                                completeHandler:(Node)->(),
                                appendHandler:(Node)->(),
                                replaceHandler:(Node)->()) {
        
        //we accept number node to be our child node/ right hand side
        //we absorb node
        if let _ = node as? NumberNode{
            appendHandler(node)
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
        
        return "x"
    }
    
    override func evaluate() -> NumberNode? {
        
        guard let leftHandNode = self.parentNode else{
            fatalError("MultiplyNode must have parent node")
        }
        
        guard let rightHandNode = self.childNode else{
            return nil
        }
        
        guard let leftNumber = leftHandNode as? NumberNode else{
            fatalError("MultiplyNode left hand/parent node is not a NumberNode")
        }
        
        guard let rightNumber = rightHandNode as? NumberNode else{
            fatalError("MultiplyNode right hand/child node is not a NumberNode")
        }
        
        let leftValue = leftNumber.value
        let rightValue = rightNumber.value
        let newValue = leftValue * rightValue
        let newNumberNode = NumberNode(newValue)
        
        //tell brain to replace this node and it's parent and child
        //with newNumberNode
        //addtion work on left/parent and right/child node, so parent
        //and child are included
        Brain.sharedBrain.replaceNode(self, newNumberNode, true, true)
        
        return newNumberNode
    }
    
    override func operatorType() -> OperatorType {
        return .DoubleInput
    }
    
    override func operatorPriority() -> OperatorPriority {
        
        return .MediumPriority
    }
}
