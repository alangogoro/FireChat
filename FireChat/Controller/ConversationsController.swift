//
//  ConversationsController.swift
//  FireChat
//
//  Created by usr on 2020/12/6.
//

import UIKit

class ConversationsController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationBar()
        // 設定 NavigationItem - LeftBarButtonItem
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain,
                                                           target: self, action: #selector(showProfile))
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
    
    // MARK: - Selectors
    @objc func showProfile() {
        print("showProfile")
    }
    
    func configureTableView() {
        tableView.backgroundColor = .systemPink
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
}
