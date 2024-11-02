//
//  ListViewModel.swift
//  MachingWithSwiftUI
//
//  Created by 杉山誇京 on 2024/10/26.
//
// Viewファイルは「Modelの状態の変更をViewに通知する役割」を担当するもの
//　このファイルはモデルを定義するときに使う。（表示要素などはListViewで、内部の処理などはListViewModelでコードを記載する）

import Foundation

class ListViewModel{
    
    var users = [User]()
    
    private var currentIndex = 0
    
    init(){
        self.users = getMockUsers()
    }
    
    private func getMockUsers() -> [User] {
        return [
            User.MOCK_USER1,
            User.MOCK_USER2,
            User.MOCK_USER3,
            User.MOCK_USER4,
            User.MOCK_USER5,
            User.MOCK_USER6,
            User.MOCK_USER7
        ]
    }
    
    func nopeButtontapped() {
        
        if currentIndex >= users.count { return }
        
        NotificationCenter.default.post(name: Notification.Name("NOPEACTION"), object: nil, userInfo: [
            "id": users[currentIndex].id
        ])
        
        currentIndex += 1
    }
    func likeButtontapped() {
        
        if currentIndex >= users.count { return }
        
        NotificationCenter.default.post(name: Notification.Name("LIKEACTION"), object: nil, userInfo: [
            "id": users[currentIndex].id
        ])
        
        currentIndex += 1
    }
    func redoButtontapped() {
        
        if currentIndex <= 0 { return }
        
        NotificationCenter.default.post(name: Notification.Name("REDOACTION"), object: nil, userInfo: [
            "id": users[currentIndex - 1].id
        ])
        
        currentIndex -= 1
    }
}
