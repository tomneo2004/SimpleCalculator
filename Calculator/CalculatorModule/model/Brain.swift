//
//  Brain.swift
//  Calculator
//
//  Created by Nelson on 18/7/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

class Brain {
    
    ///get default Brain
    static let sharedBrain : Brain = Brain()
    
    ///tail node which point to last node in list
    private var tailNode : Node?
    
    init() {
        
        reset()
    }
    
    ///give NumberNode when a mathmatical number 0~9 need to be inputed to Brain
    func inputNumberNode(_ newNode:NumberNode, _ completeHandler:(NumberNode)->()){
        
        //try to merge node first, if it fail then try to append node
        //to list
        tailNode?.mergeWithNode(newNode, completeHandler: { (selfNode) in
            
            //merge successful
            logAllNodes()
            completeHandler(findLastNumberNode()!)
            
        }, appendHandler: { (node) in
            
            appendNodeToTailNode(node)
            
            logAllNodes()
            completeHandler(findLastNumberNode()!)
            
        }, replaceHandler: { (node) in
          
            replaceTailNodeWithNode(node)
            completeHandler(findLastNumberNode()!)
        })
        
    }
    
    ///give DecimalNode when a mathmatical decimal need to be inputed to Brain
    func inputDecimalNode(_ newNode:DecimalNode, _ completeHandler:(NumberNode)->()){
        
        //try to merge node first, if it fail then try to append node
        //to list
        tailNode?.mergeWithNode(newNode, completeHandler: { (selfNode) in
            
            //merge successful
            logAllNodes()
            completeHandler(findLastNumberNode()!)
            
        }, appendHandler: { (node) in
            
            //DecimalNode should not be append to list
            completeHandler(findLastNumberNode()!)
            
        }, replaceHandler: { (node) in
            
            //DecimalNode should not replace any node in list
            completeHandler(findLastNumberNode()!)
        })
        
    }
    
    ///give OperatorNode when a mathmatical operator need to be inputed to Brain
    func inputOperatorNode(_ newNode:OperatorNode, _ completeHandler:(NumberNode)->()){
        
        //try to merge node first, if it fail then try to append node
        //to list
        tailNode?.mergeWithNode(newNode, completeHandler: { (selfNode) in
            
            completeHandler(findLastNumberNode()!)
            
        }, appendHandler: { (node) in
            
            appendNodeToTailNode(node)
            
            //this should not be called just a test
            guard let opNode = tailNode as? OperatorNode else{
                fatalError("append operator node at tail but tail is not operator node")
            }
            
            evaluateNodesWithPriority(opNode.operatorPriority())
            completeHandler(findLastNumberNode()!)

        }, replaceHandler: { (node) in
            
            replaceTailNodeWithNode(node)
            
            //this should not be called just a test
            guard let opNode = tailNode as? OperatorNode else{
                fatalError("append operator node at tail but tail is not operator node")
            }
            
            evaluateNodesWithPriority(opNode.operatorPriority())
            completeHandler(findLastNumberNode()!)
        })
    }
    
    ///reset Brain to inital state
    func resetBrain(_ completeHandler:(NumberNode)->()){
        
        guard let tail = tailNode else{
            
            reset()
            return
        }
        
        var preNode = tail.parentNode
        
        //disconnect all nodes
        while(preNode != nil){
            
            tail.dropConnection()
            tailNode = preNode
            preNode = tailNode?.parentNode
        }
        
        reset()
        
        completeHandler(findLastNumberNode()!)
        
        print("Brain reset \(tailNode!.valueInString())")
    }
    
    ///Calculate
    func calculate(_ completeHandler:(NumberNode)->()){
        
        if let opNode = tailNode as? OperatorNode{
            
            //if tail node is double input operator
            if opNode.operatorType() == .DoubleInput{
                
                //get last number node
                guard let lastNumberNode = findLastNumberNode() else{
                    fatalError("No NumberNode in operation sentence")
                }
                
                //create new number node with last number node's value
                let newNumberNode = NumberNode(lastNumberNode.value)
                
                //append to tail node
                appendNodeToTailNode(newNumberNode)
            }
        }
        
        for priority in operatorPriorities{
            
            evaluateNodesWithPriority(priority)
        }
        
        logAllNodes()
        
        completeHandler(findLastNumberNode()!)
    }
 
}

//MARK: - extension for Brain
extension Brain {
    
    ///evaluate each OperatorNode in list with priority
    ///
    ///any OperatorNode has lower than given priority will be
    ///ignored
    ///
    ///Recommend to call this method after an OperatorNode has been add to list
    private func evaluateNodesWithPriority(_ priority:OperatorPriority){
        
        guard let tail = tailNode else{
            return
        }
        
        print("\nbefore evaluation")
        logAllNodes()
        
        var nextOpNode : OperatorNode? = nil
        
        if let opNode = tailNode as? OperatorNode{
            nextOpNode = opNode
        }
        else{
            nextOpNode = findNextOperatorNodeFrom(tailNode!)
        }
        
        while(nextOpNode != nil){
            
            //if priority is lower then find next operator
            if nextOpNode!.operatorPriority().rawValue < priority.rawValue{
                
                nextOpNode = findNextOperatorNodeFrom(nextOpNode!)
                
                continue
            }
            
            var pointToResult = false
            
            if nextOpNode?.parentNode === tailNode!{
                pointToResult = true
            }
            else if nextOpNode?.childNode === tailNode{
                pointToResult = true
            }
            
            //if evaluate successful
            if let numberNode = nextOpNode?.evaluate(){
                
                if tail === nextOpNode || pointToResult{
                    tailNode = numberNode
                }
                
                nextOpNode = findNextOperatorNodeFrom(numberNode)
                continue
            }
            
            nextOpNode = findNextOperatorNodeFrom(nextOpNode!)
        }
        
        print("\nafter evaluation:")
        logAllNodes()
    }
    
    ///find nearest operator node from given node
    ///traverse back to parent
    private func findNextOperatorNodeFrom(_ node:Node) -> OperatorNode?{
        
        var nextNode : Node? = node.parentNode
        
        while(nextNode != nil){
            
            if let opNode = nextNode as? OperatorNode{
                return opNode
            }
            
            nextNode = nextNode?.parentNode
        }
        
        return nil
    }
    
    ///method that can find last NumberNode in list
    func findLastNumberNode() -> NumberNode?{
        
        if let tail = tailNode{
            
            var nextNode : Node? = tail
            
            while(nextNode != nil){
                if let numberNode = nextNode as? NumberNode{
                    return numberNode
                }
                nextNode = nextNode?.parentNode
            }
        }
        
        return nil
    }
    
    ///reset brain to initial state
    ///which is jsut a NumberNode with zero value
    private func reset(_ value : Decimal = Decimal()){
        
        tailNode = NumberNode(value)
    }
    
    ///method which can print arithmetic sentence
    ///mainly for debug purpose
    private func logAllNodes(){
        
        guard let tail = tailNode else{
            
            fatalError("tail node is nil")
        }
        
        var nextNode : Node? = tail
        var log = ""
        while(nextNode != nil){
            log = " "+nextNode!.valueInString()+log
            nextNode = nextNode?.parentNode
        }
        
        print("Operation sentence: \(log)")
    }
    
    func AllNodesInString()->String{
        
        guard let tail = tailNode else{
            
            fatalError("tail node is nil")
        }
        
        var nextNode : Node? = tail
        var log = ""
        while(nextNode != nil){
            log = nextNode!.valueInString()+log+" "
            nextNode = nextNode?.parentNode
        }
        
        return log;
    }
    
    ///append a new Node to tail node and
    ///making tail node point to new Node
    private func appendNodeToTailNode(_ newNode:Node){
        
        if let tail = tailNode{
            
            if tail !== newNode{
                
                newNode.parentNode = tailNode
                tailNode?.childNode = newNode

            }
        }
        
        //point tail to new node
        tailNode = newNode
    }
    
    ///remove tail node's Node and making tail node point to
    ///new Node
    private func replaceTailNodeWithNode(_ newNode:Node){
        
        //if tail node not nil
        if let tail = tailNode{
            
            //make sure tail node is not the same
            //object of new node by comparing with instance
            if tail !== newNode{
                
                //make new node parent and child point
                //to same node as tail node
                newNode.parentNode = tail.parentNode
                newNode.childNode = tail.childNode
                
                tail.dropConnection()
            }
            
        }
        
        //point tail to new node
        tailNode = newNode
    }
    
    ///replace a Node with another Node in list
    ///
    ///do not call this method directly, except OperatorNode
    ///
    ///if includeParent is true then parent node of Node that will be removed will be removed as well
    ///
    ///if includeChild is true then child node of Node that will be removed will be removed as well
    func replaceNode(_ node:Node, _ withNode:Node, _ includeParent:Bool = false, _ includeChild:Bool = false){
        
        withNode.parentNode = nil
        withNode.childNode = nil
        
        var mostLeftNode : Node?
        var mostRightNode : Node?
        
        if includeParent{
            mostLeftNode = node.parentNode?.parentNode
            node.parentNode?.dropConnection()
        }
        else{
            mostLeftNode = node.parentNode
        }
        
        if includeChild{
            mostRightNode = node.childNode?.childNode
            node.childNode?.dropConnection()
        }
        else{
            mostRightNode = node.childNode
        }
        
        if mostLeftNode != nil{
            mostLeftNode?.childNode = withNode
            withNode.parentNode = mostLeftNode
        }
        
        if mostRightNode != nil{
            mostRightNode?.parentNode = withNode
            withNode.childNode = mostRightNode
        }
        
        node.dropConnection()
    }
    
    ///remove a Node in list
    func removeNode(_ node:Node){
        
        let leftNode : Node? = node.parentNode
        let rightNode : Node? = node.childNode
        
        if leftNode != nil && rightNode != nil {
            leftNode?.childNode = rightNode
            rightNode?.parentNode = leftNode
        }
        else{
            leftNode?.childNode = nil
            rightNode?.parentNode = nil
        }
    }
}
