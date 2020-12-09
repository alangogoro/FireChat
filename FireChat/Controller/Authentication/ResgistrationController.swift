//
//  ResgistrationController.swift
//  FireChat
//
//  Created by usr on 2020/12/6.
//

import UIKit

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: InputContainerView = {
        let containerView = InputContainerView(image: UIImage(systemName: "envelope"),
                                               textField: emailTextField)
        return containerView
    }()
    private lazy var fullnameContainerView: InputContainerView = {
        let containerView = InputContainerView(image: UIImage(systemName: "person"),
                                               textField: fullnameTextField)
        return containerView
    }()
    private lazy var usernameContainerView: InputContainerView = {
        let containerView = InputContainerView(image: UIImage(systemName: "person"),
                                               textField: usernameTextFiel)
        return containerView
    }()
    private lazy var passwordContainerView: InputContainerView = {
        let containerView = InputContainerView(image: UIImage(systemName: "lock"),
                                               textField: passwordTextField)
        return containerView
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let fullnameTextField = CustomTextField(placeholder: "Full Name")
    private let usernameTextFiel = CustomTextField(placeholder: "Username")
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Password")
        /* 輸入時隱藏文字（密碼格式） */
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let signUpButton: UIButton = {
        /* 建立並設定 UIButton 按鈕 */
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor  = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1) // 輸入 Color Literal 即出現調色盤
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton()
        // 可以再 append 的 Mutable 樣式文字
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ",
                                                        attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        // 加上粗體的樣式文字
        attributedTitle.append(NSAttributedString(string: "Log In",
                                                  attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        // 在 Button 上加入上述樣式文字
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    // MARK: - Selectors
    @objc func handleSelectPhoto() {
        
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        /* 使用了 UIView 的 Autokayout extension */
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             paddingTop: 32)
        plusPhotoButton.setDimensions(height: 180, width: 180)
        
        /* 建立 StackView */
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   fullnameContainerView,
                                                   usernameContainerView,
                                                   signUpButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor,
                     left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor,
                                        bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                        right: view.rightAnchor,
                                        paddingLeft: 32, paddingRight: 32)
    }
    
}
