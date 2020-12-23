//
//  ChatController.swift
//  FireChat
//
//  Created by usr on 2020/12/21.
//

import UIKit

private let reuseIdentifier = "MessageCell"

/// 聊天室列表
class ChatController: UICollectionViewController {
    
    // MARK: - Properties
    private let user: User
    private var messages = [Message]()
    var fromCurrentUser = false
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let inputView = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0,
                                                        width: view.frame.width,
                                                        height: 50))
        inputView.delegate = self
        return inputView
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
    // 最後要加上這一個
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Helpers
    func configureUI() {
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.username, prefersLargeTitles: false)
        
        /* ⭐️ ➡️ 註冊 CollectionView 使用的 Cell 的類別以及 ID ⭐️ */
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        /*            .alwaysBounceVertical */
        collectionView.alwaysBounceVertical = true
    }
}

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath)
            as! MessageCell
        cell.message = messages[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ChatController: UICollectionViewDelegateFlowLayout {
    
    /* ⭐️ 定義 Section 的位置 */
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    /* ⭐️ 定義 Item(Cell) 的尺寸 */
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }                     // 與畫面一樣長
}

extension ChatController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        
        inputView.messageInputTextView.text = nil
        
        fromCurrentUser.toggle()
        
        let message = Message(text: message, isFromCurrentUser: fromCurrentUser)
        messages.append(message)
        collectionView.reloadData()
    }
}
