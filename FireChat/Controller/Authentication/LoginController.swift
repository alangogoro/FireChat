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
        /* ‼️ 啟用程式碼所寫的 AutoLayout ⚠️
         * ⛔️ 如果不加這一行，UI 不會顯示！ */
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        /* 使用 Anchor 設定 ImageView 的 AutoLayout */
        iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
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
