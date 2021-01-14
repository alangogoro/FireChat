//
//  NewMessageController.swift
//  FireChat
//
//  Created by usr on 2020/12/16.
//

import Foundation
import UIKit

private let reuseIdentifier = "UserCell"

/* ⭐️🌟 宣告 delegate 並規定遵從的要屬於 class 類型
 * 以 delegate 作為 NewMessage 頁跟 Chat 頁的橋樑
 * 同時要宣告 weak var delegate 的屬性於本頁面 ⭐️🌟 */
protocol NewMessageControllerDelegate: class {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User)
}

class NewMessageController: UITableViewController {
    
    // MARK: - Properties
    private var users = [User]()
    /* ➡️ weak var delegate 宣告 */
    weak var delegate: NewMessageControllerDelegate?
    
    private var filteredUsers = [User]()
    /* ➡️ SearchController 宣告 */
    private let searchController = UISearchController(searchResultsController: nil)
    /* ➡️ 宣告一個 Bool 以判斷是否正在搜尋 user，並依此改變 TableView 呈現 */
    private var isSearching: Bool {
        return searchController.isActive &&
            !searchController.searchBar.text!.isEmpty
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSearchController()
        fetchUsers()
        
    }
    
    // MARK: - Selector
    @objc func handleDismissal() {
        dismiss(animated: true)
    }
    
    // MARK: - API
    func fetchUsers() {
        
        showLoader(true)
        
        Service.fetchUsers { users in
            self.users = users
            
            self.showLoader(false)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        configureNavigationBar(withTitle: "New Message", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(handleDismissal))
        
        /* 🌟 用 FooterView 取代空白處（去掉 Cell 之間的分隔線）🌟 */
        tableView.tableFooterView = UIView()
        /* ➡️ 註冊 TableVIew 的 Cell class 以及 reuseIdentifier */
        tableView.register(UserCell.self,
                           forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
    }
    
    func configureSearchController() {
        /* ⭐️➡️ 設置 SearchController 並呈現於 Navigation 之上 ⭐️ */
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        // 是否暗淡化搜尋列背景
        searchController.obscuresBackgroundDuringPresentation = false
        // 是否隱藏 NavigationBar
        searchController.hidesNavigationBarDuringPresentation = false
        // 設定提示文字
        searchController.searchBar.placeholder = "Search for a user"
        definesPresentationContext = false
        
        /* ⭐️➡️ 設定搜尋列 SearchField 的外觀，利用 searchBar.value(forKey: "searchField") ⭐️ */
        if let textField = searchController.searchBar
            .value(forKey: "searchField") as? UITextField {
            textField.textColor = .systemPurple
            textField.backgroundColor = .white
        }
    }
}

// MARK: - UITableViewDataSource
extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredUsers.count : users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath)
            as! UserCell
        
        /* ⚠️➡️ 利用三元運算子，依照是否搜尋中的 Bool 呈現不同陣列的資料 */
        cell.user = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        return cell
    }
}

extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
        delegate?.controller(self, wantsToStartChatWith: user)
    }
}

// MARK: - UISearchResultsUpdating
extension NewMessageController: UISearchResultsUpdating {
    
    /* 🔰➡️ 處理在搜尋列的文字請求 */
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        /* ⭐️ 按照條件過濾出陣列內，符合條件的元素 ⭐️ */
        filteredUsers = users.filter({ user -> Bool in
            return user.username.contains(searchText) || user.fullname.contains(searchText)
        })
        self.tableView.reloadData()
        
    }
    
}
