//
//  Node.swift
//  Calculator
//
//  Created by Nelson on 18/7/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

protocol NodeProtocol {
    
    ///merge this node with different node
    ///
    ///completeHandler call when merge successful or given node has been absorb by node you called on
    ///and it return a node which is the node you called on
    ///
    ///appendHandler call when merge fail and recommend to add given node to list.
    ///return a node which you given
    ///
    ///replaceHandler call when merge fail and recommend to replace current node with node you given
    ///return a node which you given
    func mergeWithNode(_ node:Node,
                       completeHandler:(Node)->(),
                       appendHandler:(Node)->(),
                       replaceHandler:(Node)->())
    
    ///return value of node in string
    func valueInString() -> String
}

class Node : NodeProtocol{
    
    
    var parentNode : Node?
    var childNode : Node?
    
    required init(){
        
    }
    
    deinit {
        
    }
    
    ///remove node's parent and child
    func dropConnection(){
        
        parentNode = nil
        childNode = nil
    }
    
    func mergeWithNode(_ node:Node,
                       completeHandler:(Node)->(),
                       appendHandler:(Node)->(),
                       replaceHandler:(Node)->()) {
        
        fatalError("Subclass must override this method")
    }
    
    func valueInString() -> String {
        
        fatalError("Subclass must override this method")
    }

}
