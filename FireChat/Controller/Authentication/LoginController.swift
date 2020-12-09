//
//  LoginController.swift
//  FireChat
//
//  Created by usr on 2020/12/6.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    private var viewModel = LoginViewModel()
    
    /* ⭐️ 用程式生成 ImageView ⭐️
     * 宣告 ➡️ 規範型別 ➡️ Closure 內回傳型別 ➡️ () */
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        return iv
    }()
    
    private lazy var emailContainerView: InputContainerView = {
        let containerView = InputContainerView(image: UIImage(systemName: "envelope"),
                                               textField: emailTextField)
        
        /* 不使用 InputContainerView 自訂 Class 時的寫法
         * 每次製作 ContainerView 都要寫大量、重複的 code
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let iv = UIImageView()
        iv.image = UIImage(systemName: "envelope")
        iv.tintColor = .white
        
        containerView.addSubview(iv)
        iv.centerY(inView: containerView)
        iv.anchor(left: containerView.leftAnchor, paddingLeft: 8)
        iv.setDimensions(height: 24, width: 28)
        
        containerView.addSubview(emailTextField)
        emailTextField.centerY(inView: containerView)
        emailTextField.anchor(left: iv.rightAnchor,
                              bottom: containerView.bottomAnchor,
                              right: containerView.rightAnchor,
                              paddingLeft: 8, paddingBottom: -8)
        
        containerView.setHeight(height: 50) */
        return containerView
    }()
    private lazy var passwordContainerView: InputContainerView = {
        let containerView = InputContainerView(image: UIImage(systemName: "lock"),
                                               textField: passwordTextField)
        
        return containerView
    }()
    
    private let loginButton: UIButton = {
        /* 建立並設定 UIButton 按鈕 */
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor  = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1) // 輸入 Color Literal 即出現調色盤
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        
        button.isEnabled = false
        button.addTarget(self,
                         action: #selector(handleLogin),
                         for: .touchUpInside)
        
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton()
        // 可以再 append 的 Mutable 樣式文字
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ",
                                                        attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        // 加上粗體的樣式文字
        attributedTitle.append(NSAttributedString(string: "Sign Up",
                                                  attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        // 在 Button 上加入上述樣式文字
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: TextFields - 獨立於生成 ContainerView 的 Closure 之外，才能抓取使用者輸入的資訊
    private let emailTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Email")
        
        /* 不使用 CustomTextField 自訂 Class 時的寫法
         * 每次製作 TextField 都要寫大量、重複的 code
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.textColor = .white*/
        return textField
    }()
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Password")
        /* 輸入時隱藏文字（密碼格式） */
        textField.isSecureTextEntry = true
        return textField
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    // MARK: - Selectors
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkFromStatus()
    }
    
    @objc func handleLogin() {
        
    }
    
    // MARK: - Helpers
    /** 檢查 ViewModel 的 formIsValid Bool 以切換按鈕狀態 */
    func checkFromStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        // 設定導覽列（時鐘、電池⋯）為淺色文字
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImageView)
        /* ===== 使用了 UIView 的 Autokayout extension ===== */
        iconImageView.centerX(inView: view)
        iconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             paddingTop: 32)
        iconImageView.setDimensions(height: 120, width: 120 )
        /* ===== 未使用 UIView 的 Autokayout extension 時，必須這樣寫 =====
        /* ‼️ 啟用程式碼所寫的 AutoLayout ⚠️
         * ⛔️ 如果不加這一行，UI 不會顯示！ */
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        /* 使用 Anchor 設定 ImageView 的 AutoLayout */
        iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
         */
        
        /* 建立 StackView */
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: iconImageView.bottomAnchor,
                     left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                                     paddingLeft: 32, paddingRight: 32)
        
        /* 當點按 TextField 時觸發切換按鈕樣式 */
        emailTextField.addTarget(self,
                                 action: #selector(textDidChange),
                                 for: .editingChanged)
        passwordTextField.addTarget(self,
                                 action: #selector(textDidChange),
                                 for: .editingChanged)
    }
    
}
