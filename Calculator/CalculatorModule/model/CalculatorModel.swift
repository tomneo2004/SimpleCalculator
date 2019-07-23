//
//
//  
//
//  Created by Nelson on 13/7/19.
//

import Foundation

class CalculatorModel : NSObject, CalculatorControllerToModelProtocol{
    
    ///define operator table
    private let operatorGroup : [String:OperatorNode.Type] = [
        
        "+/-": InvertNode.self,
        "%": PercentNode.self,
        "+": AdditionNode.self,
        "-": SubtractNode.self,
        "×": MultiplyNode.self,
        "÷": DivisionNode.self
        
    ]
    
    
    weak var MVC_Controller : CalculatorModelToControllerProtocol!
    
    override init() {
        //init brain
        let _ = Brain.sharedBrain
    }
    
    deinit {
        print("Model deinit")
    }
    
    func addDigitalNumberWith(_ numberString: String) {
        
        DispatchQueue.global(qos: .userInitiated).async{
            
            Brain.sharedBrain.inputNumberNode(NumberNode.NumberNodeFromString(numberString)) { (numberNode) in
                
                DispatchQueue.main.async {
                    
                    self.MVC_Controller.onDigitalNumberAdded(result: numberNode.valueInString())
                    self.MVC_Controller.onNewCalculateSentence(sentence: Brain.sharedBrain.AllNodesInString())
                }
                
            }
        }
    }
    
    func addDecimalSymbol() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            Brain.sharedBrain.inputDecimalNode(DecimalNode()) { (numberNode) in
                
                DispatchQueue.main.async {
                    
                    self.MVC_Controller.onDecimalSymbolAdded(result: numberNode.valueInString())
                    self.MVC_Controller.onNewCalculateSentence(sentence: Brain.sharedBrain.AllNodesInString())
                }
                
            }
        }
    }
    
    func addOperatorWith(_ operatorString: String) {
        
        let opType = operatorGroup[operatorString]
        
        guard let _ = opType else{
            fatalError("\(operatorString) not defined")
        }
        let opInstance : OperatorNode? = opType!.init()
        
        guard let newOperator = opInstance else{
            fatalError("create operator from \(operatorString) fail, operator probably not defined")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            DispatchQueue.main.async {
               
                Brain.sharedBrain.inputOperatorNode(newOperator) { (numberNode) in
                    
                    self.MVC_Controller.onOperatorAdded(result: numberNode.valueInString())
                    self.MVC_Controller.onNewCalculateSentence(sentence: Brain.sharedBrain.AllNodesInString())
                }
            }
            
        }
       
    }
    
    func clearAll() {
        
        DispatchQueue.global(qos: .userInitiated).async {
           
            Brain.sharedBrain.resetBrain { (numberNode) in
                
                DispatchQueue.main.async {
                 
                    self.MVC_Controller.onClearAll(result: numberNode.valueInString())
                    self.MVC_Controller.onNewCalculateSentence(sentence: Brain.sharedBrain.AllNodesInString())
                }
            }
        }
        
    }
    
    func calculateResult() {
        
        DispatchQueue.global(qos: .userInitiated).async{
            
            DispatchQueue.main.async {
                
                Brain.sharedBrain.calculate { (numberNode) in
                    
                    self.MVC_Controller.onCalculate(result: numberNode.valueInString())
                    self.MVC_Controller.onNewCalculateSentence(sentence: Brain.sharedBrain.AllNodesInString())
                }
            }
            
        }
        
    }

}
