//
//  CommentView.swift
//  BookApp
//
//  Created by Dominik Maric on 10.12.2021..
//

import SwiftUI

struct CommView: View {
    
    var book: Book
    @ObservedObject var detailVM: DetailBookVM
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var comment = ""
    
    var body: some View {
        
        TextField("Leave a comment", text: $comment)
            .frame(width: 250, height: 50, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.purple, lineWidth: 4)
            )
            .padding(.bottom, 20)
            .multilineTextAlignment(.center)
        
        Button {
            detailVM.sendComment(comm: comment, name: detailVM.getName(), surname: detailVM.getSurname(), bookName: book.title)
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Comment")
        }
        .frame(width: 100, height: 30, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.purple, lineWidth: 4)
        )
        .foregroundColor(.purple)
    }
}

