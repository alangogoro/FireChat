//
//  ResgistrationController.swift
//  FireChat
//
//  Created by usr on 2020/12/6.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
    weak var delegate: AuthenticationDelegate?
    
    
    private let plusPhotoButton: UIButton = {
        // 建立並設定 UIButton 按鈕
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .white
        button.imageView?.setDimensions(height: 150, width: 150)
        /* ❗️clipsToBounds 裁切元件內容來符合邊界❗️
         * 此處是為了切出圓形的大頭貼圖示 */
        button.clipsToBounds = true
        button.imageView?.clipsToBounds = true
        
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
                                               textField: usernameTextField)
        return containerView
    }()
    private lazy var passwordContainerView: InputContainerView = {
        let containerView = InputContainerView(image: UIImage(systemName: "lock"),
                                               textField: passwordTextField)
        return containerView
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let fullnameTextField = CustomTextField(placeholder: "Full Name")
    private let usernameTextField = CustomTextField(placeholder: "Username")
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Password")
        /* 輸入時隱藏文字（密碼格式） */
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let signUpButton: UIButton = {
        // 建立並設定 UIButton 按鈕
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor  = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1) // 輸入 Color Literal 即出現調色盤
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        
        button.addTarget(self,
                         action: #selector(handleRegistration),
                         for: .touchUpInside)
        button.isEnabled = false
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
        configureTextFieldEvents()
        
    }
    
    // MARK: - Selectors
    /// 跳出圖片挑選器並取得圖片
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullnameTextField {
            viewModel.fullname = sender.text
        } else {
            viewModel.username = sender.text
        }
        
        checkFormStatus()
    }
    
    @objc func handleRegistration() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let profileImage = profileImage else { return }
        
        let credentials = RegistrationCredentials(email: email,
                                                  password: password,
                                                  fullname: fullname,
                                                  username: username,
                                                  profileImage: profileImage)
        
        showLoader(true, withText: "Signing Up")
        
        AuthService.shared.createUser(credentials: credentials) { error in
            if let error = error {
                self.showLoader(false)
                self.showError(error.localizedDescription)
                return
            }
            
            self.showLoader(false)
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc func handleSelectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }

    @objc func keyboardWillShow() {
        /* ➡️ 若要顯示鍵盤，畫面上移 88 */
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    @objc func keyboardWillHide() {
        /* ➡️ 若要收起鍵盤，畫面回復原位 */
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        /* 使用了 UIView 的 Autokayout extension */
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             paddingTop: 32)
        plusPhotoButton.setDimensions(height: 150, width: 150)
        
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
    
    /**
     設置所有 TextField 在使用者輸入時檢查文字並啟用註冊按鈕。也監聽鍵盤跳出時畫面上移
     */
    func configureTextFieldEvents() {
        /* 當點按 TextField 時觸發切換按鈕樣式 */
        emailTextField.addTarget(self,
                                 action: #selector(textDidChange),
                                 for: .editingChanged)
        passwordTextField.addTarget(self,
                                 action: #selector(textDidChange),
                                 for: .editingChanged)
        fullnameTextField.addTarget(self,
                                 action: #selector(textDidChange),
                                 for: .editingChanged)
        usernameTextField.addTarget(self,
                                 action: #selector(textDidChange),
                                 for: .editingChanged)
        
        /* ⭐️ 監聽鍵盤事件，讓畫面上移或恢復 ⭐️ */
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
}

// MARK: - UIImagePickerControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate,
                                  /* ⚠️ 圖片挑選還需要遵從 NavigationControllerDelegate */
                                  UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        /* 取得圖片設為 plusPhotoButton 的圖片 */
        let image = info[.originalImage] as? UIImage
        profileImage = image
        /* ❗️⚠️ withRenderingMode(.alwaysOriginal) 保持圖片原始色調 ⚠️❗️ */
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 150 / 2
        // 退出圖片挑選器
        dismiss(animated: true, completion: nil)
    }
    
}

extension RegistrationController: AuthenticationControllerProtocol {
    /** 檢查 ViewModel 的 formIsValid Bool 以切換按鈕狀態 */
    func checkFormStatus() {
        if viewModel.formIsValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
}
