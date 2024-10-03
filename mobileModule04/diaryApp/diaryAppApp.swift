//
//  diaryAppApp.swift
//  diaryApp
//
//  Created by Matteo Gauvrit on 19/09/2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FirebaseFirestore

@main
struct diaryAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Data())
                .onOpenURL { url in
                    print("Received URL: \(url)")
                    // Verifie si l'URL correspond à l'URI de redirection
                    
                    print("scheme = \(url.scheme ?? "pas de scheme")")
                    print("host = \(url.host ?? "pas d'host")")
                    
                    if url.scheme == "diaryapp" && url.host == "callback" {
                        if let code = url.valueOf("code") {
                            print("Ready to exchange code: \(code)")
                            // Appelle ici la fonction pour échanger le code contre un access token
                            User.shared.exchangeCodeForToken(code: code)
                        }
                    }
                }
        }
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
                    User.shared.exchangeCodeForToken(code: code)
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
