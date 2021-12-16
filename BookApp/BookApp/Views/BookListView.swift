//
//  BookListView.swift
//  BookApp
//
//  Created by Dominik Maric on 08.12.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct BookListView: View {
    @ObservedObject var bookVM : BookVM
    @ObservedObject var detailVM : DetailBookVM
    
    var body: some View {
        VStack {
            
            TextField("Search", text: $bookVM.searchedBook)
                .frame(width: 250, height: 30, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.purple, lineWidth: 4)
                )
                .padding(.bottom, 15)
                .multilineTextAlignment(.center)
            
            
            ScrollView {
                ForEach(bookVM.searchedAllBooks, id: \.self){ book in
                    NavigationLink(destination: DetailBookView(bookVM: bookVM, book: book, numberOfLikes: bookVM.getBookLikesNum(bookName: book.title), detailVM: detailVM)){
                        HStack {
                            WebImage(url: URL(string: book.url))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 150)
                                .cornerRadius(5)
                                .padding(.horizontal, 10)
                            VStack {
                                Text(book.title).foregroundColor(.black)
                            }
                            HStack {
                                Spacer()
                                Image(systemName: "message")
                                Text(String(bookVM.getBookCommentNum(bookName: book.title)))
                                
                                Image(systemName: "hand.thumbsup")
                                Text(String(bookVM.getBookLikesNum(bookName: book.title)))
                            }
                        }
                        Spacer()
                    }
                }
            }.clipped()
        }
        .onAppear {
            bookVM.getAllLikes()
            bookVM.getAllComments()
            bookVM.getAllBooks()
        }
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView(bookVM: BookVM(), detailVM: DetailBookVM())
    }
}


