//
//  AuthService.swift
//  FireChat
//
//  Created by usr on 2020/12/15.
//

import Firebase
import UIKit

/// 會員註冊所須資料之彙集
struct RegistrationCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        /* 將 Firebase 提供函式內的 Callback func 原封不動的
         * 作為自建函式 logUserIn 的 Optional 參數。
         * 一樣是呼叫完後就會執行 Callback 程式 */
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUser(credentials: RegistrationCredentials,
                    completion: ((Error?) -> Void)?) {
        /* UIImage.jpegData(compressionQuality: 0.5) 壓縮圖片 */
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        
        /* ⭐️ 為圖片取名為 UUID，並準備一個儲存路徑 */
        //let filename = NSUUID().uuidString
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/prifile_images/\(filename)")
        
        /* ⭐️ 上傳圖片 */
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                print("=====DEBUG: Failed to upload image with error \(error.localizedDescription)")
                completion!(error)
                return
            }
            /* 取得 URL */
            ref.downloadURL { (url, error) in
                //❔❓❔ 範例寫的是 absoluteURL，但執行有問題 ❔❓❔
                // guard let profileImageUrl = url?.absoluteURL else { return }
                guard let profileImageString = url?.absoluteString else { return }
                
                /* ⭐️ 利用 Email 與密碼建立使用者欄位 */
                Auth.auth().createUser(withEmail: credentials.email,
                                       password: credentials.password) { (result, error) in
                    if let error = error {
                        print("=====DEBUG: Failed to create user with error \(error.localizedDescription)")
                        completion!(error)
                        return
                    }
                    
                    /* 取得建成的使用者 UID */
                    guard let uid = result?.user.uid else { return }
                    
                    let data = ["email": credentials.email,
                                "fullname": credentials.fullname,
                                "profileImageUrl": profileImageString,
                                "uid": uid,
                                "username": credentials.username] as [String: Any]
                    
                    /* ⭐️ 儲存會員註冊資料到 users集合 的 文件 中 ⭐️ */
                    Firestore.firestore()
                        .collection("users").document(uid)
                        .setData(data, completion: completion)
                    /* Firestore 提供的函式 completion 參數的型別為
                     * ((Error?) -> Void)? 的 Optional function
                     * 也就是可能會有 error 產生，而你不一定要承接處理的 Callback func
                     * 是用來寫 setData 完畢之後需要做什麼的地方。
                     * 此處就原封不動的把 ((Error?) -> Void)? 這個型別當成是 createUser 的參數
                     * 所以會有最後一行的 completion: completion
                     * 需要((Error?) -> Void)⬆️        ⬆️就自己寫符合 ((Error?) -> Void) 的參數 */
                }
            }
        }
    }
}
