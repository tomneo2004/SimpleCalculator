//
//  NumberNode.swift
//  Calculator
//
//  Created by Nelson on 18/7/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

fileprivate func log10(value:Double) -> Double{
    return log(value) / log(10.0)
}

class NumberNode: Node {
    
    ///Return a real value in decimal
    var value : Decimal{
        get{
            return (Decimal(wholeNumber) + fractionNumber) * Decimal(valueOfSign)
        }
    }
    
    ///return value in string for display purpose
    private var displayableValue : String{
        get{
            //nagetive sign or positive
            var result = stringOfSign
            
            result += String(wholeNumber.magnitude)
            
            //if number is decimal
            if isDecimal{
                result += "."
                
                //if we have fraction number
                if fractionOffset > 0{
                    
                    //extract fraction part where is after decimal
                    let absFractionNumber = fractionNumber.magnitude
                    var fractionStr = absFractionNumber.fractionPartInString()
                    
                    //how long is fraction part
                    let fractionLength = absFractionNumber.fractionLength()
                    
                    //find number of empty space between fractionOffset
                    //and fraction current length
                    let count = fractionOffset - fractionLength
                    
                    //try to fill 0 between fractionOfsset and fraction current length
                    //As value 123.189 and fraction offset after decimal is 5 then
                    //it should be display as 123.18900
                    if count > 0{
                        for _ in 1...count{
                            fractionStr += "0"
                        }
                    }
                    
                    result += fractionStr
                }
                
            }
            
            return result
        }
    }
    
    ///sign of number
    private var sign : FloatingPointSign = .plus
    
    ///value of sign either 1 or -1
    private var valueOfSign : Int{
        return sign == FloatingPointSign.plus ? 1 : -1
    }
    
    ///sign in string either "" or "-"
    private var stringOfSign : String{
        
        return sign == FloatingPointSign.plus ? "" : "-"
    }
    
    ///hold part of whole number
    private var wholeNumber : Int = 0
    
    ///offset of whole number e.g 123 offset is 3
    ///if whole number is 0 offset will be 0
    private var wholeOffset : Int = 0
    
    ///is number a decimal or integer
    private var isDecimal : Bool = false
    
    ///hold part of fraction number
    ///use decmial to be more precise
    private var fractionNumber : Decimal = Decimal.zero
    
    ///offset of fraction number e.g 0.0123 offset is 4
    ///if fraction number is 0.0 offset will be 0
    private var fractionOffset : Int = 0
    
    ///max digitals this number can hold
    private let maxDigits = 16
    
    
    //MAKR: - init
    ///convenient way to create a NumberNode
    ///
    ///init will decompose value in decimal you given and turn it into
    ///value NumberNode needed. NumberNode have 3 components Sign, WholeNumber
    ///and FractionNumber
    ///
    ///Sign: is either negative or positive
    ///
    ///WholeNumber: is where NumberNode store integer part
    ///
    ///FracionNumber is where NumberNode store decimal part
    convenience init(_ inValue : Decimal) {
        self.init()
        
        //sign
        self.sign = inValue < Decimal(0.0) ? .minus : .plus
        
        //get absolute value
        let absValue = inValue.magnitude
        
        //is value an integer
        let isInt = inValue.isInteger()
        
        //get whole part
        wholeNumber = absValue.roundDown().integerPart()
        
        //if whole number is not 0 then find out wholeOffset
        if wholeNumber != 0{
            
            //whole offset
            //use log base of 10 with whole number to get number of times
            //10 should multiply itself to reach or close to whole number
            //floor down number
            //Example 123456 after log base of 10 will be 5
            //because it is 6 digitals so shuold plus 1

            wholeOffset = Int( floor(log10(Double(wholeNumber))) )+1
        }
        else{
            wholeOffset = 0
        }
        
        //if number is Integer
        if isInt{
            
            fractionNumber = Decimal.zero
            fractionOffset = 0
            isDecimal = false
        }
        else{// it is decimal
            
            //get fraction part
            fractionNumber = absValue.fractionPart()
            
            //find out fraction offset
            let fractionLength = fractionNumber.fractionLength()
            fractionOffset = fractionLength
            isDecimal = true
        }
        
    }
    
    //MARK: - override from parent
    override func mergeWithNode(_ node:Node,
                                completeHandler:(Node)->(),
                                appendHandler:(Node)->(),
                                replaceHandler:(Node)->()) {
        
        
        //merge with number node
        if let numberNode = node as? NumberNode{
            
            //if digitals over or equal max
            //dot not allow more digitals
            if wholeOffset + fractionOffset >= maxDigits{
                print("\nNumberNode digits reach max")
                print("number of current digits \(wholeOffset+fractionOffset) in \(maxDigits)")
                completeHandler(self)
                return
            }
            
            //if this number is not a decimal
            //we deal with whole number
            if !isDecimal{
                
                wholeOffset += 1
                var newWholeNumber = wholeNumber
                let absWholeNumber = wholeNumber.magnitude
                newWholeNumber = Int(absWholeNumber * 10 + UInt(numberNode.value.doubleValue()))
                
                wholeNumber = newWholeNumber
            }
            else{ //if this number's value is decimal
                
                fractionOffset += 1
                var newFractionNumber = fractionNumber
                let absFractionNumber = fractionNumber.magnitude
                let newFraction = numberNode.value / pow(Decimal(10.0), fractionOffset)
                newFractionNumber  = absFractionNumber + newFraction
                
                fractionNumber = newFractionNumber
            }
            
            completeHandler(self)
            
            return
        }
        
        //merge with decimal node
        if let _ = node as? DecimalNode{
            
            //was no decimal
            if !isDecimal{
                isDecimal = true
                fractionOffset = 0
                
            }
            
            completeHandler(self)
            return
        }
        
        //when other node can not be merged
        //we notify to append
        appendHandler(node)
    }
    
    override func valueInString() -> String{
        
        return displayableValue
    }
}

//MARK: - extension to NumberNode
extension NumberNode{
    
    //An easy way to create NumberNode from string
    static func NumberNodeFromString(_ numStr : String) -> NumberNode{
        
        guard let decimalNum = Decimal(string: numStr) else{
            
            fatalError("\(numStr) can not convert to decimal")
        }
        
        return NumberNode(decimalNum)
    }
    
    ///Invert sign of this NumberNode
    func invertSign(){
        sign = sign == .plus ? .minus : .plus
    }
}


//MARK: - extension to Decimal
extension Decimal{
    
    ///extension to decimal
    ///
    ///return double value
    func doubleValue()->Double{
        return NSDecimalNumber(decimal: self).doubleValue
    }
    
    ///extension to decimal
    ///
    ///return strin value
    func stringValue()->String{
        return NSDecimalNumber(decimal: self).stringValue
    }
    
    ///extension to decimal
    ///
    ///return true if decimal only have integer part otherwise false
    func isInteger() -> Bool{
        return self.exponent >= 0
    }
    
    ///extension to decimal
    ///
    ///return decimal that been floored
    func roundDown() -> Decimal{
        var floorDecimal = Decimal()
        var thisDecimal = self
        NSDecimalRound(&floorDecimal, &thisDecimal, 0, .down)
        return floorDecimal
    }
    
    ///extension to decimal
    ///
    ///return integer part of decimal
    func integerPart() -> Int{
//        return NSDecimalNumber(decimal: self).intValue
        let sign = self < Decimal(0.0) ? Decimal(-1) : Decimal(1)
        return NSDecimalNumber(decimal: self.magnitude.roundDown() * sign).intValue
    }
    
    ///extension to decimal
    ///
    ///return fraction part of decimal
    func fractionPart() -> Decimal{
        
        let floorDecimal = self.roundDown()
        let fraction = self - floorDecimal
        
        return fraction
    }
    
    ///extension to decimal
    ///
    ///return how many places in fraction part in decimal
    func fractionLength() -> Int{
        return self.exponent < 0 ? Int(self.exponent.magnitude) : 0
    }
    
    ///extension to decimal
    ///
    ///return string that represent fraction part of decimal
    ///only the part after decimal
    ///
    ///e.g 0.123 return "123"
    func fractionPartInString() -> String{
        
        if self.fractionLength() > 0{
            let fractionPart = self.fractionPart().stringValue().split(separator: ".")[1]
            return String(fractionPart)
        }
        
        return ""
    }
    
    ///extension to decimal
    ///
    ///return the sign in integer of decimal
    ///either -1 or 1
    func signInt() -> Int{
        
        return self < Decimal.zero ? -1 : 1
    }
    
    ///extension to decimal
    ///
    ///return the sign in decimal
    ///either -1(Decimal) or 1(Decimal)
    func signDecimal() -> Decimal{
        
        return self < Decimal.zero ? Decimal(sign: .minus, exponent: 0, significand: 1) : Decimal(sign: .plus, exponent: 0, significand: 1)
    }
    
    ///extension to decimal
    ///
    ///return decimal that has been trimed
    func trimToLength(_ len:UInt) -> Decimal{
        
        if self == Decimal(0.0){
            return self
        }
        
        let sign = self < Decimal(0.0) ? Decimal(-1.0) : Decimal(1.0)
        let cLen = self.fractionLength()
        
        if cLen >= len{
            
            let decimalPartStr = self.magnitude.fractionPart().stringValue()
            let range = ..<decimalPartStr.index(decimalPartStr.endIndex, offsetBy: Int(len) - cLen)
            let trimStr = decimalPartStr[range]
            
            guard let trimDecimal = Decimal(string: String(trimStr)) else{
                
                fatalError("Trim decimal fail")
            }
            
            return trimDecimal * sign
        }
        
        fatalError("Fraction length is \(cLen) can not trim to \(len)")
    }
}

//MARK: - extension to Int
extension Int{
    
    ///extension to Int
    ///
    ///return length of Int
    func intLength() -> Int{
        return Int( floor(log10(Double(self.magnitude))) )+1
    }
    
    ///extension to Int
    ///
    ///return Int that has been trimed
    func trimToLength(_ len:UInt) -> Int{
        
        if self == 0{
            return self
        }
        
        let sign =  self < 0 ? -1 : 1
        let cLen = self.intLength()
        
        if cLen >= len{
            
            let trim = Decimal(sign: .plus, exponent: (cLen - Int(len)) * -1, significand: Decimal(self.magnitude))
            let intPart = trim.integerPart()
            return intPart * sign
        }
        
        fatalError("Integer length is \(cLen) can not trim to \(len)")
    }
}
