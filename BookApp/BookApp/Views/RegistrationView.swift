//
//  RegistrationView.swift
//  BookApp
//
//  Created by Dominik Maric on 08.12.2021..
//

import SwiftUI

struct RegistrationView: View {
    @State var email = ""
    @State var password = ""
    @State var name = ""
    @State var surname = ""
    @State var genre = "Espionage"
    
    let genres = ["Humor", "Health", "Fiction", "Espionage"]

    @ObservedObject var loginVM = LogInVM()

    var body: some View {
        VStack {
            LottieView(name: "book", loopMode: .loop)
                .frame(width: 300, height: 250)
            
            TextField("Email", text: $email)
                .frame(width: 330, height: 50, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.purple, lineWidth: 4)
                ).padding(5)
                .autocapitalization(.none)
                .multilineTextAlignment(.center)
            
            SecureField("Password", text: $password)
                .frame(width: 330, height: 50, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.purple, lineWidth: 4)
                ).padding(5)
                .autocapitalization(.none)
                .multilineTextAlignment(.center)
            
            TextField("Name", text: $name)
                .frame(width: 330, height: 50, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.purple, lineWidth: 4)
                ).padding(5)
                .autocapitalization(.none)
                .multilineTextAlignment(.center)
            
            TextField("Surname", text: $surname)
                .frame(width: 330, height: 50, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.purple, lineWidth: 4)
                ).padding(5)
                .autocapitalization(.none)
                .multilineTextAlignment(.center)
            
            Picker("Espionage", selection: $genre) {
                ForEach(genres, id: \.self) {
                    Text($0)
                }
            }
            .frame(width: 330, height: 50, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.purple, lineWidth: 4)
            ).padding(5)
                .multilineTextAlignment(.center)
            
            HStack {
                Button("Sign Up ") {
                    loginVM.signUp(email: email, password: password, name: name, surname: surname, genre: genre)
                }
                    .disabled(self.name.isEmpty || self.surname.isEmpty)                
                    .padding()
                    .frame(width: 330, height: 50, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.purple, lineWidth: 4)
                    )
                    .foregroundColor(.black)
            }
            .padding(.top, 20)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(loginVM: LogInVM())
    }
}
