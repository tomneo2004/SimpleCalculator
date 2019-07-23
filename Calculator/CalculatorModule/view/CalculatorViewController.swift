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
    
    //MARK: - Clear action
    
    @IBAction func clearPress(_ sender: UIButton) {
        
        MVC_Controller.onClearPress()
    }
    
    //MARK: - Digital action
    @IBAction func digitalPress(_ sender: UIButton) {
        
        MVC_Controller.onDigitalNumberPress(sender.currentTitle!)
    }
    
    //MARK: - Operator action
    @IBAction func operatorPress(_ sender: UIButton) {
        
        MVC_Controller.onOperatorPress(sender.currentTitle!)
    }
    
    //MARK: - Calculate action
    @IBAction func calculatePress(_ sender: UIButton) {
        
        MVC_Controller.onCalculatePress()
    }
    
    //MARK: - Decimal action
    @IBAction func decimalPress(_ sender: UIButton) {
        
        MVC_Controller.onDecimalPress()
    }
    
    func onUpdateCalculatorDisplay(result: String) {
        
        displayLabel.text = result
    }
    
    func onUpdateCalculateSentence(result: String) {
        displaySentenceLabel.text = result
    }
}
