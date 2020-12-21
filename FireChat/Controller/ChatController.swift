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
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let iav = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0,
                                                        width: view.frame.width,
                                                        height: 50))
        return iav 
    }()
    
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
    
    /* ❗️⚠️ 覆寫 InputAccessoryView 成自己的 view ⚠️❗️ */
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Helpers
    func configureUI() {
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.username, prefersLargeTitles: false)
    }
}
