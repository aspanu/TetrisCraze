//
//  TetrisView.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-29.
//

import SwiftUI

struct TetrisView: View {
    @ObservedObject var model = TetrisModel()

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<model.grid.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<model.grid[row].count, id: \.self) { column in
                        Rectangle()
                            .fill(self.color(for: model.grid[row][column]))
                            .frame(width: 15, height: 15)
                            .border(Color.white, width: 0.5)
                    }
                }
            }
        }
        .border(Color.black, width: 1)
        .padding()
        .overlay(
            KeyEventHandlingView { event in
                self.handleKeyEvent(event)
            }
            .frame(width: 0, height: 0)
        )
    }

    private func color(for block: TetrisBlock) -> Color {
        switch block {
        case .empty:
            return Color.gray
        case .filled(let color):
            return color
        }
    }

    private func handleKeyEvent(_ event: NSEvent) {
        switch event.keyCode {
        case 123:
            // Left arrow
            model.movePieceLeft()
        case 124:
            // Right arrow
            model.movePieceRight()
        case 125:
            // Down arrow
            model.movePieceDown()
        case 126:
            // Up arrow
            model.rotatePiece()
        default:
            break
        }
    }
}

struct TetrisView_Previews: PreviewProvider {
    static var previews: some View {
        TetrisView()
    }
}
