//
//  RecommendedView.swift
//  BookApp
//
//  Created by Dominik Maric on 08.12.2021..
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct RecommendedView: View {
    
    @ObservedObject var recVM : RecommendedVM
    @ObservedObject var bookVM : BookVM
    @ObservedObject var detailVM : DetailBookVM
    
    var body: some View {
        NavigationView {

        VStack{
            
            Text(recVM.getGenre())
                .font(.headline)
            
            ScrollView {
                ForEach(recVM.allRecommendedBooks, id: \.self){ book in
                    NavigationLink(destination: DetailBookView(bookVM: bookVM, book: book, numberOfLikes: bookVM.getBookLikesNum(bookName: book.title), detailVM: detailVM)){
                        HStack {
                            WebImage(url: URL(string: book.url))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 150)
                                .cornerRadius(5)
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
                        .padding(15)
                        Spacer()
                    }
                }
            }.clipped()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .onAppear{
            for user in recVM.allUsers {
                if user.id == Auth.auth().currentUser?.uid {
                    recVM.getAllBooks(genre: user.genre)
                }
            }
        }
        }
    }
}

struct RecommendedView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendedView(recVM: RecommendedVM(), bookVM: BookVM(), detailVM: DetailBookVM())
    }
}
