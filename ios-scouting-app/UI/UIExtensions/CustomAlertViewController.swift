//
//  CustomAlertViewController.swift
//  Scouting
//
//  Created by DUC LOC on 5/30/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class CustomAlertController : UIViewController {
    var scoutingActivity = ScoutingActivity()
    let stackView = UIStackView()
    let textField = UITextField()
    let textFieldContainer = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureStackView()
        
        self.stackView.addArrangedSubview(self.textFieldContainer)
        configureTextField()
        
        for i in 0..<self.scoutingActivity.commentOptions.count{
            let checkbox = CheckBoxField()
            checkbox.setUpView(data: self.scoutingActivity.commentOptions[i])
            checkbox.backgroundColor = UIColor.white
            checkbox.onTimerStarted()
            checkbox.layer.borderWidth = 1
            checkbox.layer.cornerRadius = 4
            checkbox.layer.borderColor = UIColor.blue.cgColor
            self.stackView.addArrangedSubview(checkbox)
            checkbox.checkBox.titleLabel?.sizeToFit()
        }
        
        self.stackView.addArrangedSubview(self.configureButtonsStackView())
        
        
    }
    
    func configureTextField()  {
        self.textField.placeholder = "Enter a comment"
        
        self.textFieldContainer.layer.borderColor = UIColor.blue.cgColor
        self.textFieldContainer.layer.borderWidth = 1
        self.textFieldContainer.layer.cornerRadius = 4
        
        self.textFieldContainer.addSubview(self.textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: self.textFieldContainer.centerYAnchor).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.textFieldContainer.centerXAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: self.textFieldContainer.widthAnchor, multiplier: 0.8).isActive = true
        textField.heightAnchor.constraint(equalTo: self.textFieldContainer.heightAnchor, multiplier: 0.8).isActive = true
    }
    
    func configureButton(text : String, color : UIColor, tag : Int) -> UIButton{
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(CGFloat(Double(UIScreen.main.bounds.height) * 0.025))
        button.setTitleColor(color, for: .normal)
        button.tag = tag
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(actionHandler(sender:)), for: .touchUpInside)
        return button
    }
    
    func configureButtonsStackView() -> UIStackView{
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        let titles = ["Ok", "Cancel"]
        let colors = [UIColor.blue, UIColor.red]
        for i in 0..<titles.count{
            stackView.addArrangedSubview(self.configureButton(text: titles[i], color: colors[i], tag: i))
        }
        
        return stackView
    }
    
    func configureStackView(){
        self.view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.9).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2.5
    }
    
    @objc func actionHandler(sender : UIButton){
        if (sender.tag == 0){
            //OK
            let alert = UIAlertController(title: "Comment added", message: "", preferredStyle: .alert)
            
            let text = self.textField.text ?? ""
            
            if (text != ""){
                self.scoutingActivity.qrEntry.comment += (text + "_")
                self.scoutingActivity.scoutingView.reloadData()
                
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when){
                    alert.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        } else if (sender.tag == 1){
            self.dismiss(animated: true, completion: nil)
        }
    }
}
