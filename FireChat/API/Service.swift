//
//  Service.swift
//  FireChat
//
//  Created by usr on 2020/12/18.
//

import Foundation
import Firebase

struct Service {
    
    static func fetchUsers(completion: @escaping ([User]) -> Void) {
                
        Firestore.firestore()
            .collection("users")
            .getDocuments { snapshot, error in
                
                /* ⭐️ 進階的寫法 ⭐️ */
                guard var users = snapshot?
                        .documents
                        .map({ User(dictionary: $0.data()) }) else { return }
                /* 基礎的寫法
                snapshot?.documents.forEach({ document in
                    
                    let dictionary = document.data()
                    let user = User(dictionary: dictionary)
                    users.append(user)
                    
                })*/
                /* ❗️⭐️ 陣列.firstIndex(where: ) rethrows 元素 ⭐️❗️
                 * ➡️ 找尋陣列中的第一個           符合 where 敘述的元素，回傳其陣列編碼
                 * 再依照編碼移除掉元素。                ⬇️
                 * 此處是從聯絡人中，排除掉使用者自己 */
                if let idxOfSelf = users.firstIndex(where: { $0.uid == Auth.auth().currentUser?.uid }) {
                    users.remove(at: idxOfSelf)
                }
                completion(users)
        }
    }
    
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument{ (snaphot, error) in
            guard let dictionary = snaphot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    /// 取得最近聊天信息陣列
    static func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(uid)
                        .collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener{ (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.fetchUser(withUid: message.chatWithId) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping ([Message]) -> Void) {
        
        var messages = [Message]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        /* ⭐️ 建立查詢：orderBy 時間戳記 ⭐️ */
        let query = COLLECTION_MESSAGES.document(currentUid)
            .collection(user.uid).order(by: "timestamp")
        
        /* ⭐️ 建立 Snapshot 監聽器，監聽 documentChanges ⭐️
         * DocumentChanges：從上次快照以來異動的文件 */
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                /* 取得 documentChanges 中新增的訊息 */
                if change.type == .added {
                    let dictionary = change.document.data()
                    
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["text": message,
                    "fromId": currentUid,
                    "toId": user.uid,
                    "timestamp": Timestamp(date: Date())] as [String: Any]
        
        /* 當使用者發送訊息時，在自己和對方的 collection 中都要新增該訊息的 document */
        COLLECTION_MESSAGES.document(currentUid).collection(user.uid)
            .addDocument(data: data) { _ in
                COLLECTION_MESSAGES.document(user.uid).collection(currentUid)
                    .addDocument(data: data, completion: completion)
                // func addDocment 的參數 completion 傳入
                // func uploadMessage 的引數，此處是一個 Optional 的 (Error?) -> Void 函式
                
                /* ➡️ 覆寫掉『最新訊息』collection 內的 document
                 * ⚠️ setData 與 addDocument 不同，會把該 document 的內容重寫覆蓋掉 */
                COLLECTION_MESSAGES.document(currentUid).collection("recent-messages")
                    .document(user.uid).setData(data)
                COLLECTION_MESSAGES.document(user.uid).collection("recent-messages")
                    .document(currentUid).setData(data)
        }
        
    }
}
