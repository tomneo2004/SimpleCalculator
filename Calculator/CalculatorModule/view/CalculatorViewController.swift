//
// 
//  
//
//  Created by Nelson on 13/7/19.
//

import UIKit
import Foundation

class CalculatorViewController : UIViewController, CalculatorControllerToViewProtocol{
    
    var MVC_Controller : CalculatorViewToControllerProtocol!
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var displaySentenceLabel: UILabel!
    
    private lazy var initModule: Void = {
        
        //wire view and controller
        let newController = CalculatorController()
        newController.MVC_View = self
        self.MVC_Controller = newController
        
        //wire model and controller
        let newModel = CalculatorModel()
        newModel.MVC_Controller = newController
        newController.MVC_Model = newModel
        
        print("Wire MVC complete")
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let _ = self.initModule
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let _ = self.initModule
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let _ = self.initModule
    }
    
    
    deinit {
        print("View deinit")
    }
    
    ///operator button pressed
    ///only allow to be set nil and buttons that are
    ///"x", "+", "-", "÷"
    ///because these buttons cahnge their scale once they are pressed
    ///and return original scale when other button pressed
    ///this property is used to track which buttons "x", "+", "-", "÷" pressed
    var operatorPressedButton : UIButton? {
        didSet{
            
            if let oldValue = oldValue{
                
                CATransaction.begin()
                
                let springAnimate = CASpringAnimation(keyPath: "transform.scale")
                springAnimate.duration = 0.1
                
                guard oldValue.layer.transform.m11 == oldValue.layer.transform.m22 else{
                    fatalError("layer was not scale properly")
                }
                springAnimate.fromValue = oldValue.layer.transform.m11
                springAnimate.toValue = 1.0
                oldValue.layer.add(springAnimate, forKey: nil)
                
                CATransaction.setCompletionBlock {
                    oldValue.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
                }
                
                CATransaction.commit()
            }
        }
    }
    
    //MARK: - Clear action
    
    @IBAction func clearPress(_ sender: UIButton) {
        
        MVC_Controller.onClearPress()
        
        operatorPressedButton = nil
        buttonScaleAnim(sender)
    }
    
    //MARK: - Digital action
    @IBAction func digitalPress(_ sender: UIButton) {
        
        MVC_Controller.onDigitalNumberPress(sender.currentTitle!)
        
        operatorPressedButton = nil
        buttonScaleAnim(sender)
    }
    
    //MARK: - Operator action
    @IBAction func operatorPress(_ sender: UIButton) {
        
        MVC_Controller.onOperatorPress(sender.currentTitle!)
        
        if sender.currentTitle == "+/-" || sender.currentTitle == "%"{
            operatorPressedButton = nil
            buttonScaleAnim(sender)
        }
        else{
            operatorPressedButton = sender
            buttonScaleAnim(sender, 1.0, 0.8, 0.8, false)
        }
    }
    
    //MARK: - Calculate action
    @IBAction func calculatePress(_ sender: UIButton) {
        
        MVC_Controller.onCalculatePress()
        
        operatorPressedButton = nil
        buttonScaleAnim(sender)
    }
    
    //MARK: - Decimal action
    @IBAction func decimalPress(_ sender: UIButton) {
        
        MVC_Controller.onDecimalPress()
        
        operatorPressedButton = nil
        buttonScaleAnim(sender)
    }
    
    func onUpdateCalculatorDisplay(result: String) {
        
        displayLabel.text = result
    }
    
    func onUpdateCalculateSentence(result: String) {
        displaySentenceLabel.text = result
    }
}

extension CalculatorViewController{
    
    ///Apply a spring animation to button
    func buttonScaleAnim(_ button:UIButton, _ fromScale:CGFloat = 1.0, _ toScale:CGFloat = 0.8, _ settleScale:CGFloat = 1.0, _ autoreverses:Bool = true){
        
        CATransaction.begin()
        
        let springAnimate = CASpringAnimation(keyPath: "transform.scale")
        springAnimate.duration = 0.1
        springAnimate.fromValue = 1.0
        springAnimate.toValue = 0.5
        springAnimate.autoreverses = autoreverses
        button.layer.add(springAnimate, forKey: nil)
        
        CATransaction.setCompletionBlock {
            
            button.layer.transform = CATransform3DMakeScale(settleScale, settleScale, 1.0)
        }
        
        CATransaction.commit()
    }
}
