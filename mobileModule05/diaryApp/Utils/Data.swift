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
    @Published var dayEntries: [Entry] = []
    @Published var feelings = humors(veryhappy: 0, happy: 0, great: 0, mid: 0, sad: 0, crying: 0)
    @Published var displayName: String = "Unknown" // Variable d'état pour stocker le nom d'utilisateur

    // Structure d'entrée
    struct Entry: Codable, Identifiable {
        @DocumentID var id: String?
        var date: String
        var icon: String
        var text: String
        var title: String
        var usermail: String
    }
    
    struct humors {
        var veryhappy: Int
        var happy: Int
        var great: Int
        var mid: Int
        var sad: Int
        var crying: Int
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
                    
                    // Réinitialise les compteurs avant de les recalculer
                    self.feelings = humors(veryhappy: 0, happy: 0, great: 0, mid: 0, sad: 0, crying: 0)

                    // Utilisez une boucle for classique pour incrémenter les valeurs
                    for entry in self.entries {
                        if entry.icon == "veryhappy" {
                            self.feelings.veryhappy += 1
                        } else if entry.icon == "happy" {
                            self.feelings.happy += 1
                        } else if entry.icon == "great" {
                            self.feelings.great += 1
                        } else if entry.icon == "mid" {
                            self.feelings.mid += 1
                        } else if entry.icon == "sad" {
                            self.feelings.sad += 1
                        } else if entry.icon == "crying" {
                            self.feelings.crying += 1
                        }
                    }
                    
                    if let user = Auth.auth().currentUser {
                        self.displayName = user.displayName ?? "Pas de nom d'utilisateur"
                    }
                    
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
                    
                    if self.entries.last!.icon == "veryhappy" {
                        self.feelings.veryhappy += 1
                    } else if self.entries.last!.icon == "happy" {
                        self.feelings.happy += 1
                    } else if self.entries.last!.icon == "great" {
                        self.feelings.great += 1
                    } else if self.entries.last!.icon == "mid" {
                        self.feelings.mid += 1
                    } else if self.entries.last!.icon == "sad" {
                        self.feelings.sad += 1
                    } else if self.entries.last!.icon == "crying" {
                        self.feelings.crying += 1
                    }
                    
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
                // Récupère le document correspondant à l'ID d'entrée
                let documentRef = db.collection("entries").document(entryId)
                let document = try await documentRef.getDocument()
                
                if let data = document.data(), let icon = data["icon"] as? String {
                    // Incrémente/décrémente les émotions selon l'icône
                    switch icon {
                    case "veryhappy":
                        self.feelings.veryhappy -= 1
                    case "happy":
                        self.feelings.happy -= 1
                    case "great":
                        self.feelings.great -= 1
                    case "mid":
                        self.feelings.mid -= 1
                    case "sad":
                        self.feelings.sad -= 1
                    case "crying":
                        self.feelings.crying -= 1
                    default:
                        print("Icône non reconnue")
                    }
                    
                    print("Icon: \(icon)")
                } else {
                    print("Document n'existe pas ou icône introuvable.")
                }
                
                // Supprime le document correspondant à l'entrée
                try await documentRef.delete()
                
                // Filtre les entrées pour ne garder que celles qui ne correspondent pas à l'ID supprimé
                DispatchQueue.main.async {
                    self.entries.removeAll { $0.id == entryId }
                    self.dayEntries.removeAll { $0.id == entryId }
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
    
    func fetchEntriesForDate(_ dateString: String) {
        isLoading = true // Démarre l'indicateur de chargement

        Task {
            do {
                // Requête pour récupérer les entrées avec la date spécifique
                let snapshot = try await self.db.collection("entries")
                    .whereField("date", isEqualTo: dateString) // Assurez-vous que "date" est le bon nom de champ
                    .getDocuments()
                
                let fetchedEntries = snapshot.documents.compactMap { document in
                    try? document.data(as: Entry.self) // Essayez d'extraire les données au format Entry
                }
                
                print("Entrées récupérées pour la date \(dateString): \(fetchedEntries)")
                
                DispatchQueue.main.async {
                    self.dayEntries = fetchedEntries // Met à jour les entrées sur le thread principal
                    self.isLoading = false // Arrête l'indicateur de chargement
                }
            } catch {
                print("Erreur lors de la récupération des documents: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false // Arrête l'indicateur de chargement en cas d'erreur
                }
            }
        }
    }
    
    // Fonction de déconnexion
    func signOutUser() {
        
        isLoading = true
        
        do {
            try Auth.auth().signOut() // Tente de déconnecter l'utilisateur
            isLoading = false
        } catch let signOutError as NSError {
            print("Erreur de déconnexion: %@", signOutError)
        }
    }
}



