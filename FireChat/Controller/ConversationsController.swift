//
//  ConversationsController.swift
//  FireChat
//
//  Created by usr on 2020/12/6.
//

import UIKit
import Firebase

private let reuseIdentifier = "ConversationCell"

class ConversationsController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView()
    
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.imageView?.setDimensions(height: 24, width: 24)
        
        button.addTarget(self,
                         action: #selector(showNewMessage),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        authenticateUser()
        
    }
    
    // MARK: - API
    /// 檢查使用者登入狀態
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            print("=====DEBUG: User is not logged in. Present login screen here.")
            presentLoginScreen()
        } else {
            
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("====DEBUG: Error signing out..")
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationBar()
        // 設定 NavigationItem - LeftBarButtonItem
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain,
                                                           target: self, action: #selector(showProfile))
        configureTableView()
        
        view.addSubview(newMessageButton)
        newMessageButton.setDimensions(height: 56, width: 56)
        newMessageButton.layer.cornerRadius = 56 / 2
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                right: view.rightAnchor,
                                paddingBottom: 16, paddingRight: 24)
    }
    
    func configureNavigationBar() {
        /* 建立 NavigationBarAppearance
         * 調整標題顏色及紫色不透明背景 */
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemPurple
        /* ⚠️ 將 NavigationBarAppearance 套用在 NavigationBar 上 */
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // NavigationBar 標題文字樣式
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        //                                  translucent 半透明的
        /* ‼️ 切換使用者導覽列（時鐘、電池）的樣式 ⚠️
         * 分為淺色與深色*/
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            /* 🌟建立一個主頁為登入頁面的 NavigationController */
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            /* ‼️顯示方式為「全螢幕」，避免使用者可以滑動取消掉登入頁 */
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    // MARK: - Selectors
    @objc func showProfile() {
        //print("showProfile")
        logout()
    }
    
    @objc func showNewMessage() {
        let controller = NewMessageController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        /* 僅在有資料的欄位顯示分隔線 */
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
}

extension ConversationsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "TEST"
        return cell
    }
}
extension ConversationsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
