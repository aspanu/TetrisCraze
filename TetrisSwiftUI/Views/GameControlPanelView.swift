//
//  GameControlPanelView.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-08-22.
//

import Foundation
import SwiftUI

struct GameControlPanelView: View {
    let onPause: () -> Void
    let onSave: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onPause) {
                Image(systemName: "pause.fill")
                    .font(.title)
                    .padding()
            }
            .background(Color.blue)
            .cornerRadius(10)
            
            Button(action: onSave) {
                Image(systemName: "square.and.arrow.down")
                    .font(.title)
                    .padding()
            }
            .background(Color.green)
            .cornerRadius(10)
        }
    }
}


