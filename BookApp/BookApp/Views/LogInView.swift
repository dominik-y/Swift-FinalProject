//
//  LogInView.swift
//  BookApp
//
//  Created by Dominik Maric on 08.12.2021..
//

import SwiftUI

struct LogInView: View {
    
    @State var email = ""
    @State var password = ""
    @State var shouldRegistrate = false
    
    @ObservedObject var loginVM = LogInVM()
    @ObservedObject var bookVM = BookVM()
    @ObservedObject var recVM = RecommendedVM()
    @ObservedObject var detailVM = DetailBookVM()
    
    var body: some View {
        if loginVM.isLogged == false {
            NavigationView {
                VStack {
                    LottieView(name: "book", loopMode: .loop)
                        .frame(width: 300, height: 250)
                    
                    TextField("Email", text: $email)
                        .frame(width: 330, height: 40, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.purple, lineWidth: 4)
                        ).padding()
                        .autocapitalization(.none)
                        .multilineTextAlignment(.center)
                    
                    SecureField("Password", text: $password)
                        .frame(width: 330, height: 40, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.purple, lineWidth: 4)
                        )
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        
                        Button {
                            loginVM.logIn(email: email, password: password)
                            email = ""
                            password = ""
                        } label: {
                            Text("Login")
                        }
                        .alert("Not a proper Email", isPresented: $loginVM.shouldAlertEmail) {
                            Button("OK", role: .cancel) { }
                        }
                        .alert("Wrong password", isPresented: $loginVM.shouldAlertCredentials) {
                            Button("OK", role: .cancel) { }
                        }
                        .frame(width: 110, height: 30, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.purple, lineWidth: 4)
                        )
                        .foregroundColor(.purple)
                        
                        NavigationLink(destination: RegistrationView(loginVM: loginVM), isActive: $loginVM.shouldRegistrate) {
                            Button {
                                loginVM.shouldRegistrate = true
                                print("reg")
                            } label: {
                                Text("Registration")
                            }
                            .frame(width: 110, height: 30, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.purple, lineWidth: 4)
                            )
                            .foregroundColor(.purple)
                        }
                    }.padding(.top, 20)
                }.padding(.bottom, 100)
            }
        } else {
            NavigationView {
                BookTabView(bookVM: bookVM, recVM: recVM, detailVM: detailVM, loginVM: loginVM)
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
