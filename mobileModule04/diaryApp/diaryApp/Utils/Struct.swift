//
//  Utils.swift
//  diaryApp
//
//  Created by Matteo Gauvrit on 19/09/2024.
//

import Foundation
import SwiftUI
import UIKit
import OAuthSwift
import FirebaseCore

struct BackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.gray, .white]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
        
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    // use to debug
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("Received URL: \(url.absoluteString)")
        
        // Vérifie si l'URL correspond à l'URI de redirection
        if url.scheme == "diaryApp" {
            print("Correct scheme detected")
            
            if url.host == "callback" {
                print("Correct host detected")
                
                // Extraire le code de l'URL
                if let code = url.valueOf("code") {
                    print("Code extracted: \(code)")
                    // Passer le code à la requête pour obtenir le token
                     exchangeCodeForToken(code: code)
                } else {
                    print("Code not found in URL")
                }
            } else {
                print("Incorrect host")
            }
        } else {
            print("Incorrect scheme")
        }
        return true
    }
}

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        let url = URLComponents(string: self.absoluteString)
        return url?.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
