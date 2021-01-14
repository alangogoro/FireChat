//
//  ProfileController.swift
//  FireChat
//
//  Created by usr on 2020/12/28.
//

import UIKit
import Firebase

private let reuseIdentifier = "ProfileCell"

protocol ProfileControllerDelegate: class {
    func handleLogout()
}

class ProfileController: UITableViewController {
    
    // MARK: - Properties
    private var user: User? {
        didSet { headerView.user = user }
    }
    
    weak var delegate: ProfileControllerDelegate?
    
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0,
                                                             width: UIScreen.main.bounds.width,
                                                             height: 380))
    
    private let footerView = ProfileFooter()
        
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
        
        showLoader(true)
        Service.fetchUser(withUid: uid) { user in
            self.user = user
            self.showLoader(false)
        }
    }
    
    
    // MARK: - Helpers
    func configureUI() {
        
        tableView.backgroundColor = .systemGroupedBackground
        /* 🌟 設置 TableView Header 🌟 */
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        /* ➡️ 取消掉 TableView 本身適應畫面的位移
         * 作用是讓 TableView（的 Header）徹底佔滿上方螢幕 */
        tableView.contentInsetAdjustmentBehavior = .never
        
        /* ⭐️ 設置並註冊 TableView Cell ⭐️ */
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
        
        /* 🌟 設置 TableView Footer 🌟 */
        footerView.frame = .init(x: 0, y: 0,
                                 width: view.frame.width,
                                 height: 100)
        tableView.tableFooterView = footerView
        footerView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases.count // enum 型別，並且遵從 CaseIterable
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            as! ProfileCell
        
        let viewModel = ProfileViewModel(rawValue: indexPath.row)
        cell.viewModel = viewModel
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileController {
    /* ⚠️➡️ 覆寫此函式，可讓 Header 距離其它 UI 元件遠一點 ⚠️ */
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView() // 多放入一個 view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let viewModel = ProfileViewModel(rawValue: indexPath.row) else { return }
        
        switch viewModel{
        case .accountInfo:
            print("=====DEBUG: Show account information page..")
        case .settings:
            print("=====DEBUG: Show Settings page..")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - TableView Header & Footer Delegates
extension ProfileController: ProfileHeaderDelegate {
    func dismissController() {
        dismiss(animated: true)
    }
}
extension ProfileController: ProfileFooterDelegate {
    
    func handleLogout() {
        
        let alert = UIAlertController(title: nil,
                                      message: "Sure to logout?",
                                      preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Log Out",
                                         style: .destructive) { _ in
            /* 先消滅頁面，再呼叫 delegate 登出 */
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
