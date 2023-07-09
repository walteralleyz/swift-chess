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
        var temp = table[row][col]
        
        if temp.color == turn {
            if self.selected != nil {
                self.selected!.selected = false
            }
            
            selectPiece(temp: temp)
            
            return
        }
        
        let canWalk = self.selected != nil
        && self.selected!.canWalk(pos: temp.position)
        
        if temp.color != self.turn && canWalk {
            movePieceAtTable(row: row, col: col, temp: temp)
            resetSelected(temp: &temp)
            invertColor()
        }
    }
    
    func selectPiece(temp: Piece) {
        if type(of: temp) != Empty.self {
            self.selected = temp
            self.selected!.selected = true
        }
    }
    
    func movePieceAtTable(row: Int, col: Int, temp: Piece) {
        let pos = self.selected!.position
        
        table[row][col] = self.selected!
        table[pos[0]][pos[1]] = temp
    }
    
    func resetSelected(temp: inout Piece) {
        let pos = self.selected!.position
        
        self.selected!.position = temp.position
        self.selected!.selected = false
        
        temp.position = pos
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
        Rook(color: color, position: [row, 0]),
        Bishop(color: color, position: [row, 1]),
        Knight(color: color, position: [row, 2]),
        King(color: color, position: [row, 3]),
        Queen(color: color, position: [row, 4]),
        Knight(color: color, position: [row, 5]),
        Bishop(color: color, position: [row, 6]),
        Rook(color: color, position: [row, 7])
    ]
}

func generatePawnRow(color: PieceColor, row: Int) -> [Piece] {
    var pieces: [Piece] = []
    
    for col in 0..<8 {
        pieces.append(
            Pawn(color: color, position: [row, col]))
    }
    
    return pieces
}

func generateEmptyPieces(row: Int) -> [Piece] {
    var pieces: [Piece] = []
    
    for col in 0..<8 {
        pieces.append(
            Empty(color: .NULL, position: [row, col]))
    }
    
    return pieces
}
