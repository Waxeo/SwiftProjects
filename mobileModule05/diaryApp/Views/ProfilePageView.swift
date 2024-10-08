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
    
    @Binding var isAuthenticated: Bool
    @EnvironmentObject var dataManager: Data
    @State private var isExpanded: Bool = false // Gérer si l'encart est étendu ou non
    @State private var showAddPopup: Bool = false // Gère l'affichage de la popup ajout
    @State private var showDataPopup: Bool = false // Gère l'affichage de la popup affichage
    @State private var selectedEntry: Data.Entry? // Pour stocker l'entrée sélectionnée
    @State private var title: String = ""
    @State private var humor: String = ""
    @State private var content: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    let buttonLabels = ["veryhappy", "happy", "great", "mid", "sad", "crying"]
        
    @State private var selectedButtonIndex: Int? = nil // Stocke l'index du bouton sélectionné
        
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

                            
                            Text("\(dataManager.displayName)")
                                .padding()
                                .font(.title)
                            
                            Spacer()
                            
                            Button(action: {
                                dataManager.signOutUser()
                                isAuthenticated = false
                                dismiss()
                            }) {
                                Image(systemName: "door.right.hand.open")
                                    .symbolRenderingMode(.multicolor)
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
                        
                        Divider()
                        
                        GroupBox {
                            Button(action: {
                                showAddPopup.toggle()
                            }) {
                                Text("New diary entry")
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(.bordered)
                            .cornerRadius(10)
                            .background(.green)
                            
                            // Encart principal
                            Button(action: {
                                
                                withAnimation {
                                    isExpanded.toggle()
                                }
                                
                            }) {
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
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(10)
                                .padding()
                            }
                            
                            
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
                                                HStack {
                                                    
                                                    Text(entry.date)
                                                    
                                                    Image(entry.icon)
                                                        .resizable()
                                                        .frame(width: 30, height: 30)
                                                    
                                                    Divider()
                                                    
                                                    Spacer()
                                                    
                                                    Text(entry.title)
                                                    
                                                    Spacer()
                                                    
                                                }
                                                .padding()
                                                .foregroundColor(.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color.white.opacity(1))
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
                                            HStack {
                                                
                                                Text("\(dataManager.entries[dataManager.entries.count - 2].date)")
                                                
                                                Image("\(dataManager.entries[dataManager.entries.count - 2].icon)")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                                
                                                Divider()
                                                
                                                Spacer()
                                                
                                                Text("\(dataManager.entries[dataManager.entries.count - 2].title)")
                                                
                                                Spacer()
                                                
                                            }
                                            .padding()
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.white.opacity(1))
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
                                            HStack {
                                                
                                                Text("\(String(describing: dataManager.entries.last!.date))")
                                                
                                                Image("\(String(describing: dataManager.entries.last!.icon))")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                                
                                                Divider()
                                                
                                                Spacer()
                                                
                                                Text("\(String(describing: dataManager.entries.last!.title))")
                                                
                                                Spacer()
                                                
                                            }
                                            .padding()
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.white.opacity(1))
                                            .cornerRadius(10)
                                        }
                                    }
                                    .padding(.horizontal)
                                    
                                }
                                
                            }
                        }
                        .padding()
                        .backgroundStyle(.cyan)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .cornerRadius(10)
                        
                        Divider()
                        
                        // Ajouter d'autres éléments après la liste de titres
                        GroupBox {
                            
                            Text("Your feel for your \(dataManager.entries.count) entries")
                                .font(.title2)
                                .foregroundColor(.white)
                            
                            if (!dataManager.entries.isEmpty) {
                                VStack {
                                    let feelingsArray = [
                                        ("Very Happy", dataManager.feelings.veryhappy),
                                        ("Happy", dataManager.feelings.happy),
                                        ("Great", dataManager.feelings.great),
                                        ("Mid", dataManager.feelings.mid),
                                        ("Sad", dataManager.feelings.sad),
                                        ("Very Sad", dataManager.feelings.crying)
                                    ]
                                    
                                    ForEach(feelingsArray, id: \.0) { feeling in
                                        let percentage = Double(feeling.1) / Double(dataManager.entries.count) * 100
                                        
                                        ProgressView(value: percentage / 100) {
                                            Text("\(Int(round(percentage)))% \(feeling.0)")
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                            
                        }
                        .padding()
                        .backgroundStyle(.green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .cornerRadius(10)
                        
                        // Avoir un tableau avec 8 barres de chargement des différentes humeurs et avoir le total des entrées en BDD, une fois que c'est good, calculer pour chacun (nHumeurType / nEntrées) * 100 arrondi à l'unitée la plus proche et greffer ça aux barres de chargement qui font office d'affichage de l'utilisation des humeurs
                        
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
                            
                            Grid(horizontalSpacing: 16, verticalSpacing: 16) {
                                ForEach(0..<2) { row in
                                    GridRow {
                                        ForEach(0..<3) { col in
                                            let index = row * 3 + col
                                            Button(action: {
                                                selectedButtonIndex = index // Sélectionne le bouton cliqué
                                                humor = buttonLabels[index]
                                            }) {
                                                Image(buttonLabels[index])
                                                    .resizable()
                                                    .frame(width: 75, height: 75)
                                                    .background(selectedButtonIndex == index ? Color.secondary : Color.blue) // Change de couleur si sélectionné
                                                    .foregroundColor(.white)
                                                    .cornerRadius(10)
                                            }
                                        }
                                    }
                                }
                            }
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
                                    selectedButtonIndex = nil
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
