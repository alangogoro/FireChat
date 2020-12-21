//
//  NewMessageController.swift
//  FireChat
//
//  Created by usr on 2020/12/16.
//

import Foundation
import UIKit

private let reuseIdentifier = "UserCell"

class NewMessageController: UITableViewController {
    
    // MARK: - Properties
    private var users = [User]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUsers()
        
    }
    
    // MARK: - Selector
    @objc func handleDismissal() {
        dismiss(animated: true)
    }
    
    // MARK: - API
    func fetchUsers() {
        Service.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        configureNavigationBar(withTitle: "New Message", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(handleDismissal))
        
        /* 用 FooterView 取代空白處（去掉 Cell 之間的分隔線） */
        tableView.tableFooterView = UIView()
        /* 註冊 TableVIew 的 Cell class 以及 reuseIdentifier */
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
    }
}

// MARK: - UITableViewDataSource
extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath)
            as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
}