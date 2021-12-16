//
//  DetailBookVM.swift
//  BookApp
//
//  Created by Dominik Maric on 10.12.2021..
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class DetailBookVM: ObservableObject {
    
    @Published var allComments = [Comment]()
    @Published var allLikes = [Like]()
    @Published var allUsers = [User]()
    private var isLiked = false
    private var docID = ""
    private var bookComments = [Comment]()
    private var bookLikes = [Like]()
    
    
    init() {
        getAllComments()
        getAllLikes()
        getUsers()
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
    
    func sendComment(comm: String, name: String, surname: String, bookName: String) {
        Firestore.firestore().collection("Comments").addDocument(data: [
            "name": name,
            "surname": surname,
            "comment": comm,
            "bookName": bookName
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Yea baby")
            }
        }
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
    
    func getDocumentId(name: String, surname: String, bookName: String) {
        Firestore.firestore().collection("Likes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["name"] as! String == name && document.data()["surname"] as! String == surname && document.data()["bookName"] as! String == bookName{
                        self.docID = document.documentID
                    }
                }
            }
        }
    }
    
    
    func getBookLike(bookName: String) {
        self.bookLikes = []
        for like in allLikes{
            if bookName == like.bookName {
                bookLikes.append(like)
            }
        }
    }
    
    
    func checkLikeStatus(name: String, surname: String, bookName: String) -> Bool {
        for like in bookLikes {
            if like.name == name && like.surname == surname {
                return true
            }
        }
        return false
    }
    
    
    func sendLike(name: String, surname: String, bookName: String) {
        getBookLike(bookName: bookName)
        
        if checkLikeStatus(name: name, surname: surname, bookName: bookName) == false {
            Firestore.firestore().collection("Likes").addDocument(data: [
                "name": name,
                "surname": surname,
                "bookName": bookName
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Yea baby")
                }
            }
        } else {
            Firestore.firestore().collection("Likes").document(docID).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
    }
    
    func getName() -> String {
        for user in allUsers {
            if user.id == Auth.auth().currentUser?.uid{
                return user.name
            }
        }
        return ""
    }
    
    func getSurname() -> String {
        for user in allUsers {
            if user.id == Auth.auth().currentUser?.uid{
                return user.surname
            }
        }
        return ""
    }
    
    
}
