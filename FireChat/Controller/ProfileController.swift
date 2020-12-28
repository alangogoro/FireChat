//
//  ProfileController.swift
//  FireChat
//
//  Created by usr on 2020/12/28.
//

import UIKit
import Firebase

private let reuseIdentifier = "ProfileCell"

class ProfileController: UITableViewController {
    
    // MARK: - Properties
    private var user: User? {
        didSet { headerView.user = user }
    }
    
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0,
                                                             width: view.frame.width,
                                                             height: 380))
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        // 改變狀態列的 icon 顏色，此處無法正確作用
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    
    // MARK: - Helpers
    func configureUI() {
        
        tableView.backgroundColor = .systemPurple
        
        /* 🔰➡️ 設置並註冊 TableView */
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        /* ➡️ 取消掉 TableView 本身適應畫面的位移
         * 作用是讓 TableView（的 Header）徹底佔滿上方螢幕 */
        tableView.contentInsetAdjustmentBehavior = .never
    }
}

extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}

extension ProfileController: ProfileHeaderDelegate {
    func dismissController() {
        dismiss(animated: true)
    }
}
