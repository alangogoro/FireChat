//
//  NewMessageController.swift
//  FireChat
//
//  Created by usr on 2020/12/16.
//

import Foundation
import UIKit

class NewMessageController: UITableViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemPink
    }
}
