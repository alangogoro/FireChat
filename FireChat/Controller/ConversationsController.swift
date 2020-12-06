//
//  ConversationsController.swift
//  FireChat
//
//  Created by usr on 2020/12/6.
//

import UIKit

class ConversationsController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        // NavigationBar 標題文字放大
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        // 設定 NavigationItem - LeftBarButtonItem
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain,
                                                           target: self, action: #selector(showProfile))
    }
    
    // MARK: - Selectors
    @objc func showProfile() {
        print("showProfile")
    }
    
}
