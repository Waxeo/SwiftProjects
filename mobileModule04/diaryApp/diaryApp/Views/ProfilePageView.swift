//
//  ProfilePageView.swift
//  diaryApp
//
//  Created by Matteo Gauvrit on 30/09/2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FirebaseFirestore

struct ProfilePageView: View {
    
    @EnvironmentObject var dataManager: Data
    @State private var isExpanded: Bool = false // Gérer si l'encart est étendu ou non
    @State private var showAddPopup: Bool = false // Gère l'affichage de la popup ajout
    @State private var showDataPopup: Bool = false // Gère l'affichage de la popup affichage
    @State private var selectedEntry: Data.Entry? // Pour stocker l'entrée sélectionnée
    @State private var title: String = ""
    @State private var humor: String = ""
    @State private var content: String = ""
        
    var body: some View {
        ZStack {
            
            BackgroundProfileView()
            
            if dataManager.isLoading == true {
                // Affiche un cercle de chargement en attendant que les données soient récupérées
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2) // Pour agrandir le cercle
                    .padding()
                
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // Section présentation profile
                        HStack {
                            Image("pp")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .padding()
                            
                            Text("Full Name")
                                .padding()
                                .font(.title)
                            
                            Spacer()
                            
                            Button(action: {
                                
                            }) {
                                Image(systemName: "door.right.hand.open")
                                    .symbolRenderingMode(.multicolor)
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
                        
                        Divider()
                        
                        
                        // Encart principal
                        Button(action: {
                            
                            withAnimation {
                                isExpanded.toggle()
                            }
                            
                        }) {
                            VStack {
                                HStack {
                                    Text("Show entries")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.headline)
                                        .padding()
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                        .padding()
                                }
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding()
                                
                                GroupBox {
                                    Button(action: {
                                        showAddPopup.toggle()
                                    }) {
                                        Text("New entry")
                                            .foregroundColor(.black)
                                    }
                                }
                                .backgroundStyle(Color.white.opacity(0.3))
                            }
                        }
                        .buttonStyle(.bordered)
                        .backgroundStyle(Color.gray.opacity(0.2))
                        
                        // Liste des titres affichée si l'encart est étendu
                        if isExpanded {
                            ScrollView {  // ScrollView pour la liste des titres
                                VStack {
                                    ForEach(dataManager.entries, id: \.id) { entry in
                                        Button(action: {
                                            Task {
                                                if let fetchedEntry = await dataManager.fetchEntryDetails(for: entry.id ?? "") {
                                                    self.selectedEntry = fetchedEntry
                                                    self.showDataPopup = true
                                                }
                                            }
                                            print("Titre cliqué : \(entry.title)")
                                        }) {
                                            Text(entry.title)
                                                .padding()
                                                .foregroundColor(.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color.white.opacity(0.5))
                                                .cornerRadius(10)
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .frame(maxHeight: 240) // Limite la hauteur de la liste à 3 titres visibles
                            .transition(.slide) // Transition d'animation
                        } else {
                            
                            VStack {
                                
                                Button(action: {
                                    if (!dataManager.entries.isEmpty && dataManager.entries.count >= 2) {
                                        self.selectedEntry = dataManager.entries[dataManager.entries.count - 2]
                                        self.showDataPopup = true
                                    }
                                    print("cliqué : avant derniere entrée ")
                                }) {
                                    if (!dataManager.entries.isEmpty && dataManager.entries.count >= 2) {
                                        Text("\(dataManager.entries[dataManager.entries.count - 2].title)")
                                            .padding()
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.white.opacity(0.5))
                                            .cornerRadius(10)
                                    }
                                }
                                .padding(.horizontal)
                                                                
                                Button(action: {
                                    if (!dataManager.entries.isEmpty && dataManager.entries.count >= 1) {
                                        self.selectedEntry = dataManager.entries.last
                                        self.showDataPopup = true
                                    }
                                    print("cliqué : last entry")
                                }) {
                                    if (dataManager.entries.isEmpty || dataManager.entries.count < 1) {
                                        Text("No entry found")
                                    } else {
                                        Text("\(String(describing: dataManager.entries.last!.title))")
                                            .padding()
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.white.opacity(0.5))
                                            .cornerRadius(10)
                                    }
                                }
                                .padding(.horizontal)
                                
                            }
                            
                        }
                        
                        Divider()
                        
                        // Ajouter d'autres éléments après la liste de titres
                        Text("le tableau du prochain module")
                            .font(.body)
                            .padding(.horizontal)
                        
                        Spacer() // Espace pour le contenu suivant si nécessaire
                    }
                }
                
                if showAddPopup {
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            HStack {
                                
                                Text("New Entry :")
                                    .font(.title)
                                    .padding()
                                
                                Spacer()
                                
                                Button(action: {
                                    showAddPopup = false
                                }) {
                                    Image(systemName: "xmark.circle")
                                        .symbolRenderingMode(.monochrome)
                                        .foregroundColor(.black)
                                }
                                .padding()
                                
                            }
                            
                            TextField("Title", text: $title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            TextField("Humor", text: $humor)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            TextField("Content", text: $content)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            Button(action: {
                                if (title.isEmpty || humor.isEmpty || content.isEmpty) {
                                    
                                } else {
                                    dataManager.addEntry(title: title, humor: humor, text: content)
                                    title = ""
                                    humor = ""
                                    content = ""
                                    showAddPopup = false
                                }
                                
                            }) {
                                Text("Save Entry")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .padding()
                        
                        Spacer()
                    }
                    .background(Color.black.opacity(0.4)) // Fond semi-transparent
                }
                
                if showDataPopup, let selectedEntry = selectedEntry {
                    ScrollView { // Ajout d'une ScrollView ici
                        VStack(spacing: 20) {
                            
                            Spacer()
                            
                            Text("Entry Details:")
                                .font(.title)
                            
                            Divider()
                            
                            Spacer()
                            
                            Text("Title: \(selectedEntry.title)")
                                .font(.headline)
                            
                            Divider()
                            
                            Text("Date: \(selectedEntry.date)")
                                .font(.headline)
                            
                            Divider()
                            
                            Text("Humor: \(selectedEntry.icon)") // J'utilise l'icône comme exemple de "humor"
                            
                            Divider()
                            
                            Text("Content: \(selectedEntry.text)")
                                .padding()

                            Button(action: {
                                // Ferme le pop-up
                                showDataPopup = false
                            }) {
                                Text("Close")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                            
                            Button(action: {
                                if let entryId = selectedEntry.id {
                                    dataManager.deleteEntry(entryId: entryId)
                                    showDataPopup = false // Ferme le pop-up après suppression
                                }
                            }) {
                                Text("Delete Entry")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                        .padding() // Ajout d'un padding pour le contenu
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .padding()
                }
            }
        }
        .onAppear {
            // Appelle fetchEntries lorsque la vue apparaît
            dataManager.fetchEntries()
        }
    }
}


struct BackgroundProfileView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.green, .white]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
        
    }
}

#Preview {
    ProfilePageView()
}
