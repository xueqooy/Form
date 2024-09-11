//
//  ViewController.swift
//  Example
//
//  Created by xueqooy on 2024/9/10.
//

import UIKit
import Form

class ViewController: UIViewController {

    private let formView = FormView(contentInset: .init(top: 40, left: 20, bottom: 20, right: 20))
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: .init(systemName: "person.crop.circle"))
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.text = "App ID"
        
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Please enter your credentials to log in. If you don't have an account, you can create one for free."
        
        return label
    }()
    
    private let idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email or Phone Number"

        return textField
    }()
    
    private let pswTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        
        return textField
    }()
    
    private let loginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Login"
        
        return UIButton(configuration: config)
    }()
    
    private let signUpButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.title = "Sign Up"
        
        return UIButton(configuration: config)
    }()
    
    private let forgotPswButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.title = "Forgot Password?"
        
        return UIButton(configuration: config)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
            
        formView.populate {
            FormRow(imageView, height: 80)
                .settingCustomSpacingAfter(20)
            
            FormRow(titleLabel, alignment: .center)
                .settingCustomSpacingAfter(20)
            
            FormRow(detailLabel)
                .settingCustomSpacingAfter(40)
            
            FormSection(backgroundView: FieldBackgroundView(), contentInset: .init(top: 20, left: 20, bottom: 20, right: 20), itemSpacing: 15) {
                FormRow(idTextField)
                
                FormSeparator()
                    
                FormRow(pswTextField)
            }
            .settingCustomSpacingAfter(10)
            
            FormRow {
                signUpButton
                
                UIView()
                
                forgotPswButton
            }
        
            FormSpacer(50)
            
            FormRow(loginButton, insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        }
        
        view.addSubview(formView)
        formView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let endEditingGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Self.endEditingGestureAction))
        view.addGestureRecognizer(endEditingGestureRecognizer)
    }
    
    @objc func endEditingGestureAction() {
        view.endEditing(true)
    }
}


class FieldBackgroundView: UIView {
    init() {
        super.init(frame: .zero)
        
        layer.backgroundColor = UIColor.systemGroupedBackground.cgColor
        layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
