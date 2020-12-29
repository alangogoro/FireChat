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
    private var conversations = [Conversation]()
    
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
        fetchConversations()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 確保每次進入畫面都會正確顯示 NavigationBar 標題
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
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
            print("=====DEBUG: Error signing out..")
        }
    }
    
    func fetchConversations() {
        Service.fetchConversations { conversations in
            self.conversations = conversations
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        configureTableView()
        
        // 設定 NavigationItem - LeftBarButtonItem
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(showProfile))
        
        view.addSubview(newMessageButton)
        newMessageButton.setDimensions(height: 56, width: 56)
        newMessageButton.layer.cornerRadius = 56 / 2
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                right: view.rightAnchor,
                                paddingBottom: 16, paddingRight: 24)
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
        /* ⭐️❗️style: .insetGrouped TableView 的一種樣式❗️⭐️ */
        let controller = ProfileController(style: .insetGrouped)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        /* ‼️顯示方式為「全螢幕」，避免使用者可以滑動取消掉個人資料頁 */
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    @objc func showNewMessage() {
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        /* ➡️ 增加 FooterView，填滿剩下的表格。
         * 作用是 可以隱藏多餘的 Cell 的分隔線 */
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    func showChatController(forUser user: User) {
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ConversationsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath)
            as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
}
extension ConversationsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let user = conversations[indexPath.row].user
        showChatController(forUser: user)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NewMessageControllerDelegate
extension ConversationsController: NewMessageControllerDelegate {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User) {
        
        controller.dismiss(animated: true, completion: nil)
        showChatController(forUser: user)
        
    }
}

extension ConversationsController: ProfileControllerDelegate {
    func handleLogout() {
        logout()
    }
}
