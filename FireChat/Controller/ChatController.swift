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
        fetchMessages()
        
    }
    
    /* ❗️⚠️ 覆寫 InputAccessoryView 成自己的 view ⚠️❗️ */
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    // 最後要加上這一個
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - API
    func fetchMessages() {
        
        showLoader(true)
        
        Service.fetchMessages(forUser: user) { messages in
            self.messages = messages
            
            self.showLoader(false)
            self.collectionView.reloadData()
            /* ❗️⭐️ 當送出訊息，重新下載資料以後捲動到最下方 ⭐️❗️ */
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1],// IndexPath
                                             at: .bottom,
                                             animated: true)
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.username, prefersLargeTitles: false)
        
        /* ⭐️ ➡️ 註冊 CollectionView 使用的 Cell 的類別以及 ID ⭐️ */
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        /*            .alwaysBounceVertical */
        collectionView.alwaysBounceVertical = true
        
        /* ‼️⭐️ 設定當使用者滑動 CollectionView，互動式的隱藏/跳出鍵盤 ⌨️ ⭐️‼️ */
        collectionView.keyboardDismissMode = .interactive
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
        cell.message?.user = user
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
    
    /* ⭐️ 定義 Item(Cell)，即每則訊息的尺寸 */
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        /* ⭐️‼️ 為了讓 Item 尺寸適應訊息長度而變化，需要以下的 code ‼️⭐️ */
        /* 1️⃣ 先預設訊息的高度為50，生成 Cell */
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
                                            //與畫面一樣長
        let estimatedSizeCell = MessageCell(frame: frame)
        /* 2️⃣ 指派 message 實際的內容，加上 layoutIfNeeded()
         * 當訊息的高度大於50時，會重新 layout */
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        /* 3️⃣ 任意指定一個極端高度的尺寸 */
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        /* 4️⃣ .systemLayoutSizeFitting
         * 這個 CollectionViewCell 的方法會回傳自身最符合傳入需求的尺寸 */
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        /* 5️⃣ 利用上述方法得出的尺寸結果，回傳 Item(Cell) 的 CGSize */
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}

extension ChatController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
                
        Service.uploadMessage(message, to: user) { error in
            if let error = error {
                print("=====DEBUG: Failed to uplaod message with error \(error.localizedDescription)")
                return
            }
            
            inputView.clearMessageText()
        }
        
    }
}
