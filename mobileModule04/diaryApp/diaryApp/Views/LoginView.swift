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
            Color.black
                .ignoresSafeArea()
            VStack {
                Text("Please select a connexion service")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button(action: {
                    gitHubConnexion()
                }) {
                    HStack {
                        Image("github")
                            .resizable()
                            .frame(width: 75.0, height: 75.0)
                            .scaledToFit()
                        Text("Continue with GitHub")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
                .buttonStyle(.bordered)
                .tint(.blue)
                .padding()
                
                Button(action: {
                    Task { await googleConnexion() }
                }) {
                    HStack {
                        Image("googleIcon")
                            .resizable()
                            .frame(width: 75.0, height: 75.0)
                            .scaledToFit()
                        Text("Continue with Google")
                            .foregroundColor(.white)
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
    }
}


#Preview {
    LoginView()
}
