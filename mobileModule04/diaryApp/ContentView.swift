//
//  ContentView.swift
//  diaryApp
//
//  Created by Matteo Gauvrit on 19/09/2024.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var user = User.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                if user.isAuthenticated == true {
                    HomeView()
                } else {
                    ZStack{
                        BackgroundContentView()
                        VStack {
                            GroupBox {
                                Text("Welcome to your Diary App,\nplease login with a Google or Github account")
                                    .font(.custom("Copperplate", size: 28))
                                    .multilineTextAlignment(.center)
                            }
                            .backgroundStyle(Color.gray.opacity(0.2))
                            
                            Image("book")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.tint)
                            
                            NavigationLink(destination: LoginView()) {
                                Text("Login")
                                    .foregroundColor(.black)
                            }
                            .buttonStyle(.bordered)

                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                user.checkUserAuthentication()
            }
        }
    }
}

struct BackgroundContentView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.gray, .white]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
        
    }
}

#Preview {
    ContentView()
}

