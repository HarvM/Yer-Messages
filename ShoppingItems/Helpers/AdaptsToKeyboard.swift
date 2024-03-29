//
//  AdaptsToKeyboard.swift
//  ShoppingItems
//
//  Created by Marc Harvey on 28/11/2020.
//  Copyright © 2020 Marc Harvey. All rights reserved.
//

import SwiftUI
import Combine

struct AdaptsToKeyboard: ViewModifier {
    
    @State private var offset: CGFloat = 0
    @State private var currentHeight: CGFloat = 0
    let animationDuration: Double = 0.4
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.currentHeight)
                .animation(Animation.easeOut(duration: animationDuration), value: offset)
                .onAppear(perform: {
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
                        .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
                        .compactMap { notification in
                            notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
                        }
                        .map { rect in
                            rect.height - geometry.safeAreaInsets.bottom
                        }
                        .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
                        .compactMap { notification in
                            CGFloat.zero
                        }
                        .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                })
        }
    }
}
