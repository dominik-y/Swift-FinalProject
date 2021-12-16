//
//  FavoritesView.swift
//  BookApp
//
//  Created by Dominik Maric on 08.12.2021..
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoritesView: View {
    @ObservedObject var bookVM : BookVM
    @ObservedObject var detailVM: DetailBookVM
    
    var body: some View {
        VStack {
            Text("Favorites")
                .font(.headline)
            
            ScrollView {
                ForEach(bookVM.favoriteBooks, id: \.self){ book in
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
            }
        }
        
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(bookVM: BookVM(), detailVM: DetailBookVM())
    }
}
