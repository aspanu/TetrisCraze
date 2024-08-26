//
//  GameBoardView.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-08-14.
//

import Foundation
import SwiftUI

struct GameBoardView: View {
    let grid: [[TetrisBlock]]
    let blockSize: CGFloat

    var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<grid.count, id: \.self) { row in
                HStack(spacing: 1) {
                    ForEach(0..<grid[row].count, id: \.self) { column in
                        self.blockView(for: grid[row][column])
                            .accessibilityIdentifier("grid_\(row)_\(column)")
                    }
                }
            }
        }
        .background(Color.black.opacity(0.5))
        .border(Color.black, width: 1)
        .padding()
        .shadow(radius: 5)
    }
    
    private func blockView(for block: TetrisBlock) -> some View {
        let fillColour = ColourScheme.pieceColour(for: block)
        let outline = block == .outline
        return Rectangle()
            .fill(fillColour)
            .overlay(outline ? Rectangle().stroke(ColourScheme.outlinePieceColour, lineWidth: 4) : nil)
            .frame(width: blockSize, height: blockSize)
            .border(Color.white.opacity(0.3), width: 0.5)
            .cornerRadius(5)
            .accessibilityLabel(block == .empty ? "empty" : "filled")
    }
}

struct GameBoardView_Preview: PreviewProvider {
    static var previews: some View {
        GameBoardView(
            grid: sampleGrid(),
            blockSize: 20
        )
        .previewLayout(.sizeThatFits)
    }

    static func sampleGrid() -> [[TetrisBlock]] {
        // Creating a 10x20 grid with some filled blocks for demonstration
        var grid = Array(repeating: Array(repeating: TetrisBlock.empty, count: 10), count: 20)
        grid[5][4] = .filled(GradientInfo(gradient: Gradient(colors: [.red, .orange]), startPoint: .top, endPoint: .bottom))
        grid[5][5] = .filled(GradientInfo(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom))
        grid[6][4] = .outline
        grid[6][5] = .outline
        return grid
    }
}
