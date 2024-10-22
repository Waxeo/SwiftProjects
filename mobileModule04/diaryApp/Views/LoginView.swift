//
//  LoginView.swift
//  diaryApp
//
//  Created by Matteo Gauvrit on 24/09/2024.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var isAuthenticated: Bool
    
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
                    Task {
                        await User.shared.googleConnexion()
                        
                        if User.shared.isAuthenticated {
                            dismiss() // Revenir à la vue précédente
                        }
                    }
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
        .onReceive(User.shared.$isAuthenticated) { authenticated in
            if authenticated {
                dismiss() // Revenir à la vue précédente si authentifié
            }
        }
    }
}
