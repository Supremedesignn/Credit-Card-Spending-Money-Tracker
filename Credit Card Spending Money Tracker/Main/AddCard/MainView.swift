//
//  MainView.swift
//  Credit Card Spending Money Tracker
//
//  Created by Nkosi Yafeu on 5/28/22.
//

import SwiftUI

struct MainView: View {
    
    @State private var shouldPresentAddCardForm = false
    
    //amount of credit card variable
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: true)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                if !cards.isEmpty {
                    TabView {
                        ForEach(cards) { card in
                            CreditCardView(card: card)
                                .padding(.bottom, 50)
                        }
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 280)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                }
                
                // 2
                Spacer()
                    .fullScreenCover(isPresented:
                                        $shouldPresentAddCardForm, onDismiss:
                                        nil) {
                        AddCardForm()
                        
                    }
                
            }
            .navigationTitle("Credit Cards")
            .navigationBarItems(leading: HStack {
                addItemButton
                deleteAllButton
            },
                                trailing: addCardButton)
        }
    }
    // refactor button
    private var deleteAllButton: some View {
        Button {
            cards.forEach { card in
                viewContext.delete(card)
            }
            do {
                try viewContext.save()
            } catch {
                
            }
            
            
            
        } label: {
            Text("Delete All")
        }
        
    }
    
    var addItemButton: some View {
        Button(action: {
            withAnimation {
                let viewContext =
                PersistenceController.shared.container
                    .viewContext
                let card = Card(context: viewContext)
                card.timestamp = Date()
                
                
                do {
                    try viewContext.save()
                } catch {
                    
                    //               let nsError = error as NSError
                    //                   fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }, label: {
            Text("Add Item")
        })
    }
    
    struct CreditCardView: View {
        
        let card: Card
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text(card.name!)
                    .font(.system(size: 24, weight: .semibold))
                
                
                HStack {
                    Image("Visa")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 44)
                        .clipped()
                    
                    Spacer()
                    Text("Balance: 4,000")
                        .font(.system(size: 18, weight: .semibold))
                    
                }
                
                
                
                Text(card.number ?? "")
                
                Text("Credit  Limit: $\(card.limit)")
                
                HStack { Spacer() }
                
            }
            .foregroundColor(.white)
            .padding()
            .background(VStack {
                if let colorData = card.color,
                   let uiColor = UIColor.color(data: colorData),
                   let actualColor = Color(uiColor) {
                    
                    // iOS 14
                    //                    LinearGradient(gradient: .init(stops: [
                    //                        .init(color: actualColor.opacity(0.6), location: 0),
                    //                        .init(color: actualColor, location: 1)
                    //                    ]), startPoint: .top, endPoint: .bottom)
                    
                    LinearGradient(colors: [
                        actualColor.opacity(0.6),
                        actualColor
                    ], startPoint: .center, endPoint: .bottom)
                } else {
                    Color.purple
                }
            })
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
    
    var addCardButton: some View {
        Button(action: {
            // trigger action
            shouldPresentAddCardForm.toggle()
            
        }, label:  {
            Text("+Card")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color.black)
                .cornerRadius(5)
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let context =
        PersistenceController.shared.container.viewContext
        MainView()
            .environment(\.managedObjectContext, context)
        // AddCardForm()
    }
}
