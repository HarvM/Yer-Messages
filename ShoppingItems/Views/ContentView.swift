//
//  ContentView.swift
//  ShoppingItems
//
//  Created by Marc Harvey on 05/01/2020.
//  Copyright © 2020 Marc Harvey. All rights reserved.
//
import SwiftUI
import Foundation

///Images used across the app
enum ContentViewImages: String {
    case plusImage = "plusIcon"
    case thumbsUp = "👍"
    case sorryShrug = "🤷🏻‍♂️"
    case checkmarkFill = "checkmark.circle.fill"
    case checkmarkEmpty = "circle"
    case appIcon = "appHeader"
    case cameraButtonIcon = "cameraIcon"
}
///Font used across the app
enum DefaultFont: String {
    case defaultFont = "SF Pro"
}

///Background colours
enum BackgroundColours: String {
    case defaultBackground = "defaultBackground"
    //TODO: Add in other colours to let user change their theme
}

struct ContentView: View {
    //MARK: - Properties
    @State var isEditing = false
    @ObservedObject var listStore: ShoppingItemStore
    let generator = UINotificationFeedbackGenerator()
    @Environment (\.managedObjectContext) var managedObjectContext
    @Environment (\.presentationMode) var presentationMode
    @Environment (\.colorScheme) var colorScheme
    @FetchRequest(entity: ShoppingItems.entity(), sortDescriptors:
                    [NSSortDescriptor (keyPath: \ShoppingItems.order, ascending: true)])
    var shoppingItemEntries: FetchedResults<ShoppingItems>
    
    //MARK: Main body of the view
    var body: some View {
        ZStack {
            Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all)
            listView
        }
        .background(Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all))
    }
    
    ///Use of ViewBuilder to differentiate between the populated and unpopulated list
    ///Using this to display the placeholder screen
    @ViewBuilder
    var listView: some View {
        ///If no shoppingItemEntries on the list then display the placeholder image
        if shoppingItemEntries.count == 0 {
            emptyListView
        } else {
            ///Will show the view with the shoppingItems that the user has input
            populatedView
        }
    }
    
    var emptyListView: some View {
        NavigationView {
            ZStack {
                Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Image(ContentViewImages.appIcon.rawValue)
                    }
                    .padding(.bottom, 100)
                    Button(action: self.readPhysicalList, label: {
                        Image(ContentViewImages.cameraButtonIcon.rawValue)
                            .resizable()
                            .background(Color.yellow)
                            .frame(width: 50, height: 50)
                            .cornerRadius(30)
                            .padding(.bottom, 28)
                    })
                }
                .frame(width: 500, height: 900, alignment: .center)
                .listStyle(PlainListStyle())
                .listRowBackground(Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all))
                
                //MARK: - NavigationBarItems: Leading item will be the EditButton that lets the user edit the list, the trailing launches MapView
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: NewEntryView()
                                        .navigationTitle("Add Item")
                                        .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 0, maxHeight: .infinity, alignment:.center)
                                        .edgesIgnoringSafeArea(.all)
                        ){
                            ///Image of the trailing icon tha leads the user to the map
                            Image(ContentViewImages.plusImage.rawValue)
                                .frame(width: 35, height: 35)
                                .cornerRadius(38.5)
                                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                        }
                    }
                }
                .foregroundColor(.white)
                .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
            }
        }
        .background(Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all))
    }
    
    //MARK: - PopulatedView
    ///This view will hold the List that displays the items that the user has input and kept in CoreData
    var populatedView: some View {
        NavigationView {
            ZStack {
                Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all)
                VStack {
                    List {
                        //MARK: - HStack: how the cells are displayed and populated
                        Section() {
                            ForEach(shoppingItemEntries, id: \.self) {
                                shoppingItemNew in
                                HStack {
                                    CellView(itemToBeAdded: shoppingItemNew.itemToBeAdded,
                                             quantitySelected: shoppingItemNew.quantitySelected,
                                             preferredMeasurement: shoppingItemNew.preferredMeasurement)
                                    NavigationLink("", destination: DetailView (itemToBeDisplayed: shoppingItemNew))
                                } ///End of HStack
                            } //End of ForEach loop
                            .onDelete(perform: self.deleteItem)
                            .onMove(perform: moveItem)
                        } ///End of Section
                        .listStyle(PlainListStyle())
                        .listRowBackground(Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all))
                    } ///End of List
                    //MARK: -  Button that launches the camera to read written shopping list
                    Button(action: self.readPhysicalList, label: {
                        Image(ContentViewImages.cameraButtonIcon.rawValue)
                            .resizable()
                            .background(Color.yellow)
                            .frame(width: 50, height: 50)
                            .cornerRadius(30)
                            .padding(.bottom, 28)
                    })
                } ///End VStack
                ///Appears to help with the reordering of the List and makes it less laggy when a row is moved
                .id(UUID())
                ///Removes the header and the wee arrow that hides/shows the cells
                .listStyle(PlainListStyle())
                ///Ensures that the list is closer to the top of the window
                .navigationBarTitleDisplayMode(.inline)
                
                //MARK: - NavigationBarItems: Leading item will be the EditButton that lets the user edit the list, the trailing launches MapView
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: NewEntryView()
                                        .navigationTitle("Add Item")
                                        .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 0, maxHeight: .infinity, alignment:.center)
                                        .edgesIgnoringSafeArea(.all)
                        ){
                            ///Image of the trailing icon tha leads the user to the map
                            Image(ContentViewImages.plusImage.rawValue)
                                .frame(width: 35, height: 35)
                                .cornerRadius(38.5)
                                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                        }
                    }
                }
            }
        }
        .background(Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all))
    }
    
    init() {
        ///Below is various attempts at getting the from from the Picker to display a different background colour
        UIPickerView.appearance().backgroundColor = UIColor(Color(BackgroundColours.defaultBackground.rawValue))
        UIPickerView.appearance().tintColor = UIColor(Color(BackgroundColours.defaultBackground.rawValue))
        ///Setting the empty/potential cells to the desired colour
        UITableView.appearance().backgroundColor = UIColor(Color(BackgroundColours.defaultBackground.rawValue))
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default) ///clears navBar to background colour
        UINavigationBar.appearance().shadowImage = UIImage() ///removes seperator
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backgroundColor = UIColor(Color(BackgroundColours.defaultBackground.rawValue))
        ///Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        ///Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        ///Have to init the listStore with a value
        self.listStore = ShoppingItemStore.init()
        
    }
}

struct KeyboardAvoiderDemo: View {
    @State var text = ""
    var body: some View {
        VStack {
            TextField("Demo", text: self.$text)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {}
        .onLongPressGesture(
            pressing: { isPressed in if isPressed { self.endEditing() } },
            perform: {})
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
