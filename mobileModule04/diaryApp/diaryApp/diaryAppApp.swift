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

@main
struct diaryAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    print("Received URL: \(url)")
                    // Verifie si l'URL correspond à l'URI de redirection
                    
                    print("scheme = \(url.scheme ?? "pas de scheme")")
                    print("host = \(url.host ?? "pas d'host")")
                    
                    if url.scheme == "diaryapp" && url.host == "callback" {
                        if let code = url.valueOf("code") {
                            print("Ready to exchange code: \(code)")
                            // Appelle ici la fonction pour échanger le code contre un access token
                            exchangeCodeForToken(code: code)
                        }
                    }
                }
        }
    }
}


// User essaye de se login a un des services proposés -- ajouter une view de sélection des services (google, github)
// Une fois le choix de service validé, ouvrir la page safari du service pour connecter le compte associé ce qui nous donnera le AUTHCODE
// Avec le AUTHCODE on va chercher l'acces token qui nous servira a request au serveur de ressources les ressources demandées
// le point précédent se fait en meme temps que l'application charge la page de callback une fois que le user a validé la connexion depuis son compte du service choisi
