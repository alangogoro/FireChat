//
//  ChatController.swift
//  FireChat
//
//  Created by usr on 2020/12/21.
//

import UIKit

class ChatController: UICollectionViewController {
    
    // MARK: - Properties
    private let user: User
    
    // MARK: - Lifecycle
    /* ⭐️❗️UICollectionViewController 建構式 ❗️⭐️ */
    init(user: User) {
        self.user = user
        /* ⭐️❗️在建構式中傳入 FlowLayout 物件，決定 CollectionView 的樣式 ❗️⭐️ */
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        collectionView.backgroundColor = .white
    }
}
