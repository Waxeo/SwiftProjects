//
//  CalendarView.swift
//  diaryApp
//
//  Created by Matteo Gauvrit on 30/09/2024.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()  // La date sélectionnée, initialisée à la date actuelle
    @ObservedObject var dataManager = Data()  // Gestionnaire de données Firebase
    @State private var showDataPopup: Bool = false // Gère l'affichage de la popup affichage
    @State private var selectedEntry: Data.Entry? // Pour stocker l'entrée sélectionnée
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    // DatePicker pour sélectionner une date
                    DatePicker(
                        "Select a date",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(GraphicalDatePickerStyle()) // Style graphique pour avoir un calendrier visuel
                    .padding()
                    
                    // Liste des entrées pour la date sélectionnée
                    if !dataManager.dayEntries.isEmpty {
                        ScrollView {  // ScrollView pour la liste des titres
                            VStack {
                                ForEach(dataManager.dayEntries, id: \.id) { entry in
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
                        .frame(maxHeight: 240)
                    } else {
                        Text("No entries for selected date.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
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
        .onAppear {
            fetchEntriesForDate(selectedDate)
        }
        .onChange(of: selectedDate) {
            // Met à jour les entrées lorsque la date est modifiée
            fetchEntriesForDate(selectedDate)
        }
    }
    
    // Fonction pour récupérer les entrées pour une date donnée
    private func fetchEntriesForDate(_ date: Date) {
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium // Par exemple : "Sep 1, 2024"
            formatter.timeStyle = .none
            return formatter
        }()
        
        // Obtenir la date actuelle et la formater
        let formattedDate = dateFormatter.string(from: date)
        
        print("\(formattedDate)")
        
        // Filtrer les entrées pour correspondre à la date sélectionnée
        dataManager.fetchEntriesForDate(formattedDate)
    }
    
    
    
    // Fonction pour voir les détails d'une entrée
    private func viewEntryDetails(_ entry: Data.Entry) {
        // Implémenter la logique pour afficher plus de détails
        print("Voir les détails pour l'entrée: \(entry)")
    }
}

#Preview {
    CalendarView()
}
