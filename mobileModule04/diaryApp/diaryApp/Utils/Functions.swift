//
//  Functions.swift
//  diaryApp
//
//  Created by Matteo Gauvrit on 25/09/2024.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

func gitHubConnexion() {
    // URL de l'authentification GitHub
    let clientID = "Ov23liy1OtbegeWz4qZs"
    let redirectURI = "diaryApp://callback"
    let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientID)&scope=user&redirect_uri=\(redirectURI)")!
    
    // Ouvrir la page de connexion GitHub dans le navigateur
    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
}

func googleConnexion() async {
    guard let clientID = FirebaseApp.app()?.options.clientID else {
        print("No client ID")
        return
    }
    
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    
    guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = await windowScene.windows.first,
          let rootViewControler = await window.rootViewController else {
        print("There is no root view controler")
        return
    }
    
    do {
        let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewControler)
        let user = userAuthentication.user
        guard let idToken = user.idToken else {
            return
        }
        let accessToken = user.accessToken
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                       accessToken: accessToken.tokenString)
        let result = try await Auth.auth().signIn(with: credential)
        print("google auth worked")
    }
    catch {
        print(error.localizedDescription)
        return
    }
}

func exchangeCodeForToken(code: String) {
    let clientID = "Ov23liy1OtbegeWz4qZs"
    let clientSecret = "7678278b1a1aa2a6c8e73466e2613a6ab5f50b2e"
    let redirectURI = "diaryApp://callback"
    
    let tokenURL = URL(string: "https://github.com/login/oauth/access_token")!
    
    var request = URLRequest(url: tokenURL)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    let bodyString = "client_id=\(clientID)&client_secret=\(clientSecret)&code=\(code)&redirect_uri=\(redirectURI)"
    request.httpBody = bodyString.data(using: .utf8)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("Erreur lors de la requête : \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        
        // Imprime la réponse pour le debug
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields)")
        }
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response Data: \(responseString)")
        }

        if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let accessToken = responseJSON["access_token"] as? String {
                print("Token d'accès : \(accessToken)")
                DispatchQueue.main.async {
                    // Authentifier avec Firebase
                    authenticateWithFirebase(accessToken: accessToken)
                }
            } else {
                print("Erreur lors de la récupération du token, aucune clé 'access_token' dans la réponse")
            }
        } else {
            print("Erreur lors de la conversion du JSON")
        }
    }.resume()
}


// authentificate with a token (github implementation)
func authenticateWithFirebase(accessToken: String) {
    let credential = GitHubAuthProvider.credential(withToken: accessToken)

    Auth.auth().signIn(with: credential) { (authResult, error) in
        if let error = error {
            print("Erreur lors de l'authentification avec Firebase : \(error.localizedDescription)")
            return
        }
        print("Utilisateur authentifié avec succès via firebase: \(authResult?.user.uid ?? "")")
        // Redirection vers HomeView ici
    }
}
