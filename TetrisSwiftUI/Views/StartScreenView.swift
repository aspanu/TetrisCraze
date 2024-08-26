//
//  StartScreenView.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-08-12.
//

import Foundation
import SwiftUI

struct StartScreenView: View {
    let startGameAction: () -> Void
    let loadGameAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Tetris Craze")
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .cornerRadius(15)

            Button(action: startGameAction) {
                Text("New Game")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
            }
            .background(Color.blue)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()
            
            Button(action: loadGameAction) {
                Text("Load Game")
                    .font(.title)
                    .padding()
            }
            .background(Color.blue)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()

        }
        .padding()
        .buttonStyle(PlainButtonStyle())
        .background(Color.clear)
    }
}

struct StartScreen_Preview: PreviewProvider {
    static var previews: some View {
        StartScreenView {
            return
        } loadGameAction: {
            return
        }
    }
}
