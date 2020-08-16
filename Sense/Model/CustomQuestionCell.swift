//
//  QuestionCell.swift
//  Sense
//
//  Created by Bob Yuan on 2019/11/19.
//  Copyright © 2019 Bob Yuan. All rights reserved.
//

import UIKit
import ChameleonFramework

class CustomQuestionCell: UITableViewCell {

    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var numberOne: UILabel!
    @IBOutlet weak var numberTwo: UILabel!
    @IBOutlet weak var questionButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //var colors : Dictionary<UIColor,UIColor> = [UIColor.flatYellow: UIColor.flatYellowDark, UIColor.flatPowderBlue: UIColor.flatPowderBlueDark]
        
        // Aug 3, Bob add:
        
        questionView.layer.cornerRadius = 15
        
        questionView.backgroundColor = .flatPowderBlue()
        
        
        questionView.layer.shadowColor = UIColor.flatPowderBlueDark().cgColor
        questionView.layer.shadowOffset = CGSize(width: 1, height: 1)
        questionView.layer.shadowOpacity = 0.7
        questionView.layer.shadowRadius = 4.0
        
    }
    
    override  func layoutSubviews() {
        super.layoutSubviews()
        //_print("questionCell.swift in layoutSubviews bounds/cell.frame/contendview.frame---self.bound: \(self.bounds) \(questionView.frame) \(self.contentView.frame) \(self.frame)")
        //questionView.frame = CGRect(x: 0,y: 0, width: 375, height: 80)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func QuestionButtonPressed(_ sender: Any) {
        
        if questionButton.titleLabel?.text == "?" {
            
            let str_result = String(Int(numberOne!.text!)! * Int(numberTwo!.text!)!);
            questionButton.setTitle(str_result, for: .normal);
            //let str = numberOne!.text! + " times " + numberTwo!.text! + " equals " + str_result;
            let str = numberOne!.text! + " " + numberTwo!.text! + " is " + str_result;
            
            //Speak out str
            //get ViewController to get func speechMessage()
            if let vc = self.superview?.parentViewController as? LearnViewController {
                vc.speechMessage(message: str);

            }
            else{
                _print("error in customQuestionCell\n")
            }
            _print("yay");
        }
        else {
            questionButton.setTitle("?", for: .normal)
        }
        
    }
    
    //Tim
    /*
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.x += 15
            frame.size.width -= 2*15
            super.frame = frame
        }
    }*/
}
