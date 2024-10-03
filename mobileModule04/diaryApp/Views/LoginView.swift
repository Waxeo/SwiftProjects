//
//  LoginView.swift
//  diaryApp
//
//  Created by Matteo Gauvrit on 24/09/2024.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack {

            VStack {
                
                Spacer()
                
                Button(action: {
                    User.shared.gitHubConnexion()
                }) {
                    HStack {
                        Image("github")
                            .resizable()
                            .frame(width: 75.0, height: 75.0)
                            .scaledToFit()
                        Text("Continue with GitHub")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                }
                .navigationTitle("Select a connexion service")
                .buttonStyle(.bordered)
                .tint(.blue)
                .padding()
                
                Button(action: {
                    Task { await User.shared.googleConnexion() }
                }) {
                    HStack {
                        Image("googleIcon")
                            .resizable()
                            .frame(width: 75.0, height: 75.0)
                            .scaledToFit()
                        Text("Continue with Google")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .padding()
                
                Spacer()
                Spacer()
            }
        }
        .navigationTitle("Please select a connexion service")
    }
}


#Preview {
    LoginView()
}
