//
//  Utils.swift
//  diaryApp
//
//  Created by Matteo Gauvrit on 19/09/2024.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FirebaseFirestore

class Data: ObservableObject {
    
    private let db = Firestore.firestore()
    
    @Published var isLoading = true // Indicateur de chargement
    @Published var entries: [Entry] = []
    
    // Structure d'entrée
    struct Entry: Codable, Identifiable {
        @DocumentID var id: String?
        var date: String
        var icon: String
        var text: String
        var title: String
        var usermail: String
    }
    
    func fetchEntries() {
        isLoading = true // Démarre l'indicateur de chargement
        Task {
            do {
                let snapshot = try await db.collection("entries").getDocuments()
                let fetchedEntries = snapshot.documents.compactMap { document in
                    try? document.data(as: Entry.self)
                }
                print("Entrées récupérées avec succès : \(fetchedEntries)")

                // Met à jour `self.entries` sur le thread principal
                DispatchQueue.main.async {
                    self.entries = fetchedEntries
                    self.isLoading = false // Arrête l'indicateur de chargement une fois que les données sont récupérées
                }
            } catch {
                print("Erreur lors de la récupération des documents: \(error)")
                // En cas d'erreur, arrête également l'indicateur de chargement
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    func addEntry(title: String, humor: String, text: String) {
        isLoading = true
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium // Par exemple : "Sep 1, 2024"
            formatter.timeStyle = .none
            return formatter
        }()
        
        // Récupérer l'adresse e-mail de l'utilisateur
        guard let usermail = fetchUserEmail() else {
            print("Erreur : l'utilisateur n'est pas connecté.")
            isLoading = false
            return
        }
        
        // Obtenir la date actuelle et la formater
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        let newEntry = Entry(date: formattedDate, icon: humor, text: text, title: title, usermail: usermail)
                
        Task {
            do {
                let ref = try await db.collection("entries").addDocument(data: [
                    "date": "\(formattedDate)",
                    "icon": "\(humor)",
                    "text": "\(text)",
                    "title": "\(title)",
                    "usermail": "\(String(describing: usermail))"
                ])
                print("Document added with ID: \(ref.documentID)")
                // Mettre à jour isLoading sur le thread principal
                DispatchQueue.main.async {
                    self.entries.append(newEntry)
                    self.entries[self.entries.count - 1].id = ref.documentID
                    self.isLoading = false
                }
            } catch {
                // Mettre à jour isLoading sur le thread principal
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("Error adding document: \(error)")
            }
        }
    }
    
    func fetchUserEmail() -> String? {
        // Vérifie si un utilisateur est connecté
        if let user = Auth.auth().currentUser {
            // Retourne l'adresse e-mail de l'utilisateur
            return user.email
        } else {
            print("Aucun utilisateur connecté.")
            return nil // Aucun utilisateur connecté
        }
    }
    
    func fetchEntryDetails(for id: String) async -> Entry? {
        do {
            let document = try await self.db.collection("entries").document(id).getDocument()
            if let entry = try? document.data(as: Entry.self) {
                return entry // Retourne l'entrée trouvée
            } else {
                print("Erreur : données non valides")
                return nil
            }
        } catch {
            print("Erreur lors de la récupération des détails de l'entrée: \(error)")
            return nil
        }
    }
    
    
    func deleteEntry(entryId: String) {
        
        isLoading = true

        Task {
            do {
                // Supprime le document correspondant à l'entrée
                try await db.collection("entries").document(entryId).delete()
                // Filtre les entrées pour ne garder que celles qui ne correspondent pas à l'ID supprimé
                DispatchQueue.main.async {
                    // Filtre les entrées pour ne garder que celles qui ne correspondent pas à l'ID supprimé
                    self.entries.removeAll { $0.id == entryId }
                    self.isLoading = false // Arrête l'indicateur de chargement
                    print("Entrée supprimée avec succès")
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false // Arrête l'indicateur de chargement en cas d'erreur
                    print("Erreur lors de la suppression de l'entrée: \(error)")
                }
            }
        }
    }
}



