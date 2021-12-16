//
//  SettingsView.swift
//  BookApp
//
//  Created by Dominik Maric on 15.12.2021..
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var loginVM: LogInVM
    
    var body: some View {
        VStack {
            Button {
                loginVM.SignOut()
            } label: {
                Text("Sign out")
            }

        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
