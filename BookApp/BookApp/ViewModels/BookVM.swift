//
//  BookVM.swift
//  BookApp
//
//  Created by Dominik Maric on 09.12.2021..
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Combine

class BookVM : ObservableObject{
    
    @Published var allBooks = [Book]()
    @Published var allComments = [Comment]()
    @Published var allLikes = [Like]()
    @Published var searchedBook = ""
    @Published var searchedAllBooks = [Book]()
    @Published var favoriteBooks = [Book]()
    
    var cancellable: AnyCancellable? = nil
    
    init(){
        self.getAllComments()
        self.getAllLikes()
        self.getAllBooks()
        
        cancellable = $searchedBook
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: {str in
                if str == "" {
                    self.searchedAllBooks = self.allBooks
                } else {
                    self.searchedAllBooks = []
                    self.search(text: str)
                }
            })
    }
    
    func search(text: String) {
        for book in allBooks {
            if book.title.contains(text.uppercased()) {
                searchedAllBooks.append(book)
            }
        }
    }
    
    
    func getAllBooks() {
        Firestore.firestore().collection("Books").addSnapshotListener { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            self.allBooks = documents.map{ (queryDocumentSnapshot) -> Book in
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
    
    func getBookCommentNum(bookName: String) -> Int{
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
            if bookName == like.bookName{
                likeNum += 1
            }
        }
        return likeNum
    }
    
    
    func addFavorite(book: Book) {
        if let index = favoriteBooks.firstIndex(of: book) {
            favoriteBooks.remove(at: index)
        }
        else {
            favoriteBooks.append(book)
        }
    }
    
    func favorite(book: Book) -> Bool {
        if favoriteBooks.contains(book) {
            return true
        }
        return false
    }
}

