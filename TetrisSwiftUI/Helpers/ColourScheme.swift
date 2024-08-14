//
//  ColourScheme.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-08-08.
//

import SwiftUI

enum ColourScheme {
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.purple, Color.blue, Color.green, Color.yellow, Color.red]),
        startPoint: .top,
        endPoint: .bottom
    )
    static let staticPieceColour: Color = .mint
    static let outlinePieceColour: Color = .yellow


    static let pieceColours: [TetrisPiece.Shape: LinearGradient] = [
        .I: LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .top, endPoint: .bottom),
        .O: LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .top, endPoint: .bottom),
        .T: LinearGradient(gradient: Gradient(colors: [Color.purple, Color.pink]), startPoint: .top, endPoint: .bottom),
        .L: LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .top, endPoint: .bottom),
        .J: LinearGradient(gradient: Gradient(colors: [Color.blue, Color.indigo]), startPoint: .top, endPoint: .bottom),
        .S: LinearGradient(gradient: Gradient(colors: [Color.green, Color.yellow]), startPoint: .top, endPoint: .bottom),
        .Z: LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]), startPoint: .top, endPoint: .bottom),
    ]
    
    static func pieceColour(for block: TetrisBlock) -> LinearGradient {
        switch block {
        case .empty:
            return LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
        case .staticBlock:
            return LinearGradient(gradient: Gradient(colors: [ColourScheme.staticPieceColour]), startPoint: .top, endPoint: .bottom)
        case .outline:
            return LinearGradient(gradient: Gradient(colors: [Color.clear]), startPoint: .top, endPoint: .bottom)
        case .filled(let gradient):
            return gradient
        }
    }
}
