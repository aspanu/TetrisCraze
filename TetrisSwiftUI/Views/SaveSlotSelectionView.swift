//
//  SaveSlotSelectionView.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-08-26.
//

import Foundation
import SwiftUI

struct SaveSlotSelectionView: View {
    @ObservedObject var viewModel: SaveSlotSelectionViewModel
    let toLoad: Bool
    @Binding var isPresented: Bool
    let onSlotSelected: (Int) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Select a Save Slot")
                .font(.title)
                .foregroundColor(.white)

            HStack(spacing: 30) {
                ForEach(0..<3, id: \.self) { slot in
                    Button(action: {
                        viewModel.selectSlot(slot)
                    }) {
                        VStack {
                            Text("SAVE \(["A", "B", "C"][slot])")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.bottom, 10)

                            if toLoad {
                                Text("LOAD GAME")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 100, height: 100)
                        .background(
                            viewModel.selectedSlot == slot ? Color.purple : Color.black.opacity(0.5)
                        )
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white, lineWidth: 3)
                        )
                    }
                }
            }
            .padding()

            HStack(spacing: 20) {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }

                Button(action: {
                    print("Calling with slot: \(viewModel.selectedSlot ?? 12)")
                    onSlotSelected(viewModel.selectedSlot!)
                    // This button is disabled until a slot is selected
                    isPresented = false
                }) {
                    Text("OK")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isOkButtonEnabled ? Color.green : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!viewModel.isOkButtonEnabled)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
        )
        .buttonStyle(PlainButtonStyle())
    }
}

struct SaveSlotSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SaveSlotSelectionView(
            viewModel: SaveSlotSelectionViewModel(),
            toLoad: false,
            isPresented: .constant(true),
            onSlotSelected: {_ in
                return
            }
        )
            .frame(width: 400, height: 300)
    }
}
