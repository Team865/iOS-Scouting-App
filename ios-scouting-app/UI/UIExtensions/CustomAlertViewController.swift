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
    let label = UILabel()
    let textField = UITextField()
    
    let textFieldContainer = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view.isOpaque = false
        
        self.configureStackView()
        configureTextField()
        
        for i in 0..<self.scoutingActivity.commentOptions.count{
            let checkbox = CheckBoxField()
            checkbox.setUpView(data: self.scoutingActivity.commentOptions[i])
            checkbox.configureCheckBoxForCommentOptions()
            self.stackView.addArrangedSubview(checkbox)
        }
        
        configureCommentTextField()
        self.stackView.addArrangedSubview(self.configureButtonsStackView())
        
    }
    
    func configureTextField()  {
        self.label.text = "Additional Info"
        self.label.textAlignment = .left
        
        self.textFieldContainer.backgroundColor = UIColor.white
        
        self.stackView.addArrangedSubview(self.textFieldContainer)
        
        self.textFieldContainer.addSubview(self.label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: self.textFieldContainer.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.textFieldContainer.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: self.textFieldContainer.widthAnchor, multiplier: 0.8).isActive = true
        label.heightAnchor.constraint(equalTo: self.textFieldContainer.heightAnchor, multiplier: 0.8).isActive = true
    }
    
    func configureButton(text : String, color : UIColor, tag : Int) -> UIButton{
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(CGFloat(Double(UIScreen.main.bounds.height) * 0.025))
        button.setTitleColor(color, for: .normal)
        button.tag = tag
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(actionHandler(sender:)), for: .touchUpInside)
        return button
    }
    
    func configureButtonsStackView() -> UIStackView{
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        let titles = ["OK", "Cancel"]
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
        stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
    }
    
    func configureCommentTextField(){
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        textField.placeholder = "Comments"
        textField.backgroundColor = UIColor.white
        
        let comment = UIImageView()
        comment.image = UIImage(named: "comments")
        
        textField.leftViewMode = .always
        textField.leftView = comment
        
        self.stackView.addArrangedSubview(view)
        
        view.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
        textField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9).isActive = true
        
        let borderLine = UIView()
        borderLine.backgroundColor = UIColor.black
        
        view.addSubview(borderLine)
        
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        borderLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        borderLine.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
        borderLine.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.01).isActive = true
        borderLine.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        borderLine.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
