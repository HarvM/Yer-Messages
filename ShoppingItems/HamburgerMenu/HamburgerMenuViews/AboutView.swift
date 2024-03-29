import SwiftUI
import StoreKit

struct AboutView: View {
    
    /// Needed when using modal to dismiss view
    @Environment(\.presentationMode) var presentationMode
    /// To open the URL
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(BackgroundColours.defaultBackground.rawValue).edgesIgnoringSafeArea(.all)
                // MARK: - Main
                VStack {
                    // MARK: - About
                    HStack {
                        Text("Thanks for giving this a try and I hope it makes your shopping a little easier.")
                            .font(.title2)
                    }
                    .padding()
                    // MARK: - Feedback text
                    HStack {
                        Text("If you have suggestions or want to give some feedback then please feel free to contact me on Twitter.")
                            .font(.title2)
                    }
                    .padding()
                    // MARK: - Button to take user to Twitter account
                    Button(action: {
                        openURL(URL(string: "https://twitter.com/MessagesYer")!)
                    }) {
                        Image(ContentViewImages.twitterIcon.rawValue)
                    }
                    .padding(.top, 50)
                }
                .padding(20) /// End of VStack
            } /// End of ZStack
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.black)
                }
            } /// End of toolbar
            .navigationBarTitle("About")
            .foregroundColor(.yellow)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
