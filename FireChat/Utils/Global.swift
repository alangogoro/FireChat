//
//  Global.swift
//  FireChat
//
//  Created by usr on 2020/12/23.
//

import Firebase

/* 存放全專案都會用到的常數，以省略太長的程式碼 */
/// Firestore - **messages** collection
let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
let COLLECTION_USERS = Firestore.firestore().collection("users")
