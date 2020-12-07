//
//  LoginController.swift
//  FireChat
//
//  Created by usr on 2020/12/6.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    /* ⭐️ 用程式生成 ImageView ⭐️
     * 宣告 ➡️ 規範型別 ➡️ Closure 內回傳型別 ➡️ () */
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        return iv
    }()
    
    private let emailContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        view.setHeight(height: 50)
        return view
    }()
    private let passwordContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.setHeight(height: 50)
        return view
    }()
    
    private let loginButton: UIButton = {
        /* 建立並設定 UIButton 按鈕 */
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor  = .systemRed
        button.setHeight(height: 50)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    // MARK: - Helpers
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
    }
    /// 設置漸層背景
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor,
                           UIColor.systemPink.cgColor]
        gradient.locations = [0, 1]
        
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
}
