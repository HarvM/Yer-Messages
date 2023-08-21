//
//  DetailView.swift
//  ShoppingItems
//
//  Created by Marc Harvey on 18/10/2020.
//  Copyright © 2020 Marc Harvey. All rights reserved.
//

import SwiftUI
import CoreData

@available(iOS 17.0, *)
struct NewEntryView: View {
    
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    let generator = UINotificationFeedbackGenerator()
    @StateObject var itemToBeAdded = ShoppingItem()
    @StateObject var notesOnItem = ItemNote()
    @StateObject var quantitySelected = ItemQuantity()
    @StateObject var selectedMeasurement = ItemMeasurement()
    @State var isShowingContentView = false
    @State var showAlert = false
    @State var areTreatsAllowed = true
    let stringStore = StringStore()
    let itemSizeMax: Int = 30
    @Environment(\.modelContext) var context

    // MARK: - Body the UI that will have a Form (Item Entry, Stepper, and Notes) and a Save Button (bottom of view)
    var body: some View {
        ZStack {
            Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer().frame(height: 45)
                    Form {
                        // MARK: - TextEditor - Item entry (Main) section
                        Section (header: Text(stringStore.whatWouldYouLike)
                            .foregroundColor(.yellow)
                            .truncationMode(.head)
                            .background(Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all))) {
                                VStack {
                                    HStack {
                                        NewShoppingItemSectionView(newShoppingItem: itemToBeAdded)
                                    }
                                    .font(.headline)
                                } /// End of Section
                                .padding(5)
                            }
                        
                        // MARK: - Picker Section for quantity & quantity type
                        Section (header: Text(stringStore.howManyWouldYouLike)
                            .foregroundColor(.yellow)
                            .background(Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all))) {
                                VStack {
                                    NewShoppingItemQuantityView(newShoppingItemQuantity: quantitySelected)
                                }
                                NewEntryPickerView(newSelectedMeasurement: selectedMeasurement)
                            }/// End of Section
                            .padding(2)
                        
                        // MARK: - TextEditor (Extra Notes) Section
                        Section(header: Text(stringStore.extraNotes)
                            .foregroundColor(.yellow)
                            .background(Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all))) {
                                HStack {
                                    NewShoppingItemNotesView(newShoppingItemNote: notesOnItem)
                                }
                            } /// End of section
                            .padding(2)
                    } ///End of Form
                    .clipped()
                    .padding(.top)
                    .background(Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all))
                    /// Uses the AdaptsToKeyboard struct to bump the screen up when the user brings up the keyboard
                    .modifier(AdaptsToKeyboard())
                    .scrollContentBackground(.hidden)
                // MARK: - Button that will save the user's entry - sits at the bottom of the view
                HStack(alignment: .center, spacing: 10) {
                    Button(action: {self.saveItem(itemToBeAdded: itemToBeAdded, notesOnItem: "2", quantitySelected: "23", preferredMeasurement: "something") } , label: {
                        Image(ContentViewImages.plusImage.rawValue)
                            .resizable()
                            .frame(width: 45, height: 45)
                            .cornerRadius(.infinity)
                            .padding(.bottom, 28)
                    })
                    .background(Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all))
//                    .alert(isPresented: $showAlert) { () -> Alert in
//                        Alert(title: Text(stringStore.oneMoment),
//                              message: Text(stringStore.makeSure),
//                              dismissButton: .default(Text(ContentViewImages.thumbsUp.rawValue))
//                        )
//                    }
                } /// End of HStack
                .background(Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all))
            } /// End of VStack
            .padding(.top, 40)
            .toolbar { /// Using toolbar to place in the Treat button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: self.weeTreat, label:  {
                        Text("🎁")
                    })
                }
            } /// End of toolbar
            .background(Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all))
        } /// End of ZStack
        .edgesIgnoringSafeArea(.all)
        .background(Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
    } /// End of body
} /// End of View


//struct NewEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewEntryView()
//    }
//}
