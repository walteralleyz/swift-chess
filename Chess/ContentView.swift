//
//  ContentView.swift
//  Chess
//
//  Created by MacHome on 06/07/23.
//

import SwiftUI

struct ChessboardView: View {
    @State var table: Array<Array<Piece>> = [
        generateKingRow(color: .BLACK, row: 0),
        generatePawnRow(color: .BLACK, row: 1),
        generateEmptyPieces(row: 2),
        generateEmptyPieces(row: 3),
        generateEmptyPieces(row: 4),
        generateEmptyPieces(row: 5),
        generatePawnRow(color: .WHITE, row: 6),
        generateKingRow(color: .WHITE, row: 7)
    ]
    
    @State var selected: Piece?
    @State var turn: PieceColor = .BLACK
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<table.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<table[row].count, id: \.self) { col in
                        table[row][col]
                            .getSymbolUiText(row: row, col: col)
                            .onTapGesture {
                                buildTapAction(row: row, col: col)
                            }
                            .id(selected)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    func buildTapAction(row: Int, col: Int) {
        let temp = table[row][col]
        
        if temp.color == turn && self.selected == nil {
            selectPiece(temp: temp)
        }
        
        if temp.color != self.turn && self.selected != nil {
            if self.selected!.canWalk(pos: temp.position) {
                movePieceAtTable(row: row, col: col, temp: temp)
                resetSelected(temp: temp)
                invertColor()
            }
        }
    }
    
    func selectPiece(temp: Piece) {
        if temp.type != PieceType.EMPTY {
            self.selected = temp
            self.selected!.selected = true
        }
    }
    
    func movePieceAtTable(row: Int, col: Int, temp: Piece) {
        let pos = self.selected!.position
        
        table[row][col] = self.selected!
        table[pos[0]][pos[1]] = temp
    }
    
    func resetSelected(temp: Piece) {
        self.selected!.position = temp.position
        self.selected!.selected = false
        self.selected = nil
    }
    
    func invertColor() {
        if self.turn == .BLACK {
            self.turn = .WHITE
            return
        }
        
        self.turn = .BLACK
    }
    
}

struct ContentView: View {
    var body: some View {
        ChessboardView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func generateKingRow(color: PieceColor, row: Int) -> [Piece] {
    return [
        Piece(type: .ROOK, color: color, position: [row, 0]),
        Piece(type: .BISHOP, color: color, position: [row, 1]),
        Piece(type: .KNIGHT, color: color, position: [row, 2]),
        Piece(type: .KING, color: color, position: [row, 3]),
        Piece(type: .QUEEN, color: color, position: [row, 4]),
        Piece(type: .KNIGHT, color: color, position: [row, 5]),
        Piece(type: .BISHOP, color: color, position: [row, 6]),
        Piece(type: .ROOK, color: color, position: [row, 7])
    ]
}

func generatePawnRow(color: PieceColor, row: Int) -> [Piece] {
    var pieces: [Piece] = []
    
    for col in 0..<8 {
        pieces.append(
            Piece(type: .PAWN, color: color, position: [row, col]))
    }
    
    return pieces
}

func generateEmptyPieces(row: Int) -> [Piece] {
    var pieces: [Piece] = []
    
    for col in 0..<8 {
        pieces.append(
            Piece(type: .EMPTY, color: .NULL, position: [row, col]))
    }
    
    return pieces
}
