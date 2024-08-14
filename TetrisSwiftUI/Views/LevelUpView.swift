//
//  LevelUpView.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-08-14.
//

import Foundation
import SwiftUI

struct LevelUpView: View {
    @Binding var showLevelUp: Bool
    @Binding var level: Int
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0

    var body: some View {
        if showLevelUp {
            Text("\(level)")
                .font(.system(size: 100, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.3)) {
                        scale = 1.5
                        opacity = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeIn(duration: 0.3)) {
                            scale = 2.0
                            opacity = 0.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showLevelUp = false
                        }
                    }
                }
        }
    }
}

struct LevelUp_Preview: PreviewProvider {
    static var previews: some View {
        LevelUpView(showLevelUp: .constant(true), level: .constant(5))
    }
}
