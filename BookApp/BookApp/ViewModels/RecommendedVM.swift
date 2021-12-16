//
//  RecommendedVM.swift
//  BookApp
//
//  Created by Dominik Maric on 10.12.2021..
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RecommendedVM : ObservableObject {
    
    @Published var allRecommendedBooks = [Book]()
    @Published var allUsers = [User]()
    @Published var allComments = [Comment]()
    @Published var allLikes = [Like]()
    
    init() {
        getUsers()
    }
    
    func getGenre() -> String {
        for user in allUsers {
            if user.id == Auth.auth().currentUser?.uid{
                return user.genre
            }
        }
        return ""
    }
    
    
    func getUsers() {
        Firestore.firestore().collection("User").addSnapshotListener{ (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            self.allUsers = documents.map{ (queryDocumentSnapshot) -> User in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let surname = data["surname"] as? String ?? ""
                let id = data["userId"] as? String ?? ""
                let genre = data["genre"] as? String ?? ""
                let user = User(name: name, surname: surname, genre: genre, id: id)
                return user
            }
            print(self.allUsers)
        }
    }
    
    
    
    func getAllBooks(genre: String) {
        Firestore.firestore().collection(genre).addSnapshotListener{ (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            self.allRecommendedBooks = documents.map{ (queryDocumentSnapshot) -> Book in
                let data = queryDocumentSnapshot.data()
                let author = data["author"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let desc = data["description"] as? String ?? ""
                let pub = data["publisher"] as? String ?? ""
                let url = data["url"] as? String ?? ""
                let rank = data["rank"] as? Int ?? 0
                let commNum = self.getBookCommentNum(bookName: title)
                let likeNum = self.getBookLikesNum(bookName: title)
                let book = Book(author: author, description: desc, publisher: pub, rank: rank, title: title, url: url, commNum: commNum, likeNum: likeNum)
                return book
            }
        }
    }
    
    func getAllComments() {
        Firestore.firestore().collection("Comments").addSnapshotListener{ (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            self.allComments = documents.map{ (queryDocumentSnapshot) -> Comment in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let surname = data["surname"] as? String ?? ""
                let bookName = data["bookName"] as? String ?? ""
                let comm = data["comment"] as? String ?? ""
                let comment = Comment(bookName: bookName, name: name, surname: surname, comment: comm)
                return comment
            }
        }
    }
    
    func getBookCommentNum(bookName: String) -> Int {
        var commentNum = 0
        for comment in allComments {
            if bookName == comment.bookName {
                commentNum += 1
            }
        }
        return commentNum
    }
    
    func getAllLikes() {
        Firestore.firestore().collection("Likes").addSnapshotListener{ (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            self.allLikes = documents.map{ (queryDocumentSnapshot) -> Like in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let surname = data["surname"] as? String ?? ""
                let bookName = data["bookName"] as? String ?? ""
                let like = Like(name: name, surname: surname, bookName: bookName)
                return like
            }
        }
    }
    
    func getBookLikesNum(bookName: String) -> Int {
        var likeNum = 0
        for like in allLikes {
            if bookName == like.bookName {
                likeNum += 1
            }
        }
        return likeNum
    }
    
}
