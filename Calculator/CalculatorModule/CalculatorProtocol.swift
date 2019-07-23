//
//
//  
//
//  Created by Nelson on 13/7/19.
//

import Foundation

protocol CalculatorViewToControllerProtocol : class{
    
    ///when user press digital button
    func onDigitalNumberPress(_ numberString:String)
    
    ///when user press decimal button
    func onDecimalPress()
    
    ///when user press operator button
    func onOperatorPress(_ operatorString:String)
    
    ///when user press clear button
    func onClearPress()
    
    ///when user press calculate button
    func onCalculatePress()
}

protocol CalculatorControllerToViewProtocol : class{
    
    ///update view
    func onUpdateCalculatorDisplay(result : String)
    
    func onUpdateCalculateSentence(result : String)
}

protocol CalculatorControllerToModelProtocol : class{
    
    ///add a digital number
    func addDigitalNumberWith(_ numberString:String)
    
    ///add a decimal
    func addDecimalSymbol()
    
    ///add a operator
    func addOperatorWith(_ operatorString:String)
    
    ///clear all
    func clearAll()
    
    ///calculate final result
    func calculateResult()
}

protocol CalculatorModelToControllerProtocol : class{
    
    ///call when number added
    ///
    ///return a number in string
    func onDigitalNumberAdded(result:String)
    
    ///call when decimal added
    ///
    ///return a number in string
    func onDecimalSymbolAdded(result:String)
    
    ///call when operator added
    ///
    ///return a number in string
    func onOperatorAdded(result:String)
    
    ///call when clear
    ///
    ///return a number in string
    func onClearAll(result:String)
    
    ///call when calculate
    ///
    ///return a calcuate result in string
    func onCalculate(result:String)
    
    func onNewCalculateSentence(sentence:String)
}
