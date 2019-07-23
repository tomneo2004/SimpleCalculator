//
//  
//  
//
//  Created by Nelson on 13/7/19.
//

import Foundation

class CalculatorController : NSObject{
    
    weak var MVC_View : CalculatorControllerToViewProtocol!
    var MVC_Model : CalculatorControllerToModelProtocol!
    
    deinit {
        print("Controller deinit")
    }
}


//MARK: - CalculatorViewToControllerProtocol
extension CalculatorController : CalculatorViewToControllerProtocol{
    
    func onDigitalNumberPress(_ digitString: String) {
        
        //tell model to add a number
        MVC_Model.addDigitalNumberWith(digitString)
    }
    
    func onDecimalPress() {
        
        //tell model to add a decimal
        MVC_Model.addDecimalSymbol()
    }
    
    func onOperatorPress(_ operatorString: String) {
        
        //tell model to add a operator
        MVC_Model.addOperatorWith(operatorString)
    }
    
    func onClearPress() {
        
        //tell model to clear all
        MVC_Model.clearAll()
    }
    
    func onCalculatePress() {
        
        //tell model to calculate
        MVC_Model.calculateResult()
    }
}

//MARK: - CalculatorModelToControllerProtocol
extension CalculatorController : CalculatorModelToControllerProtocol{
    
    
    func onDigitalNumberAdded(result: String) {
        
        MVC_View.onUpdateCalculatorDisplay(result: result)
    }
    
    func onDecimalSymbolAdded(result: String) {
        
        MVC_View.onUpdateCalculatorDisplay(result: result)
    }
    
    func onOperatorAdded(result: String) {
        
        MVC_View.onUpdateCalculatorDisplay(result: result)
    }
    
    func onClearAll(result: String) {
        
        MVC_View.onUpdateCalculatorDisplay(result: result)
    }
    
    func onCalculate(result: String) {
        
        MVC_View.onUpdateCalculatorDisplay(result: result)
    }
    
    func onNewCalculateSentence(sentence: String) {
        
        MVC_View.onUpdateCalculateSentence(result: sentence)
    }
}
