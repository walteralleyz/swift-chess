//
//  Piece.swift
//  Chess
//
//  Created by MacHome on 07/07/23.
//

import SwiftUI
import Foundation

class Piece: Hashable {
    var type: PieceType
    var color: PieceColor
    var position: [Int]
    var selected: Bool
    
    init(type: PieceType, color: PieceColor, position: [Int]) {
        self.type = type
        self.color = color
        self.position = position
        self.selected = false
    }
    
    func getSymbolUiText(row: Int, col: Int) -> some View {
        let tileSize: CGFloat = (UIScreen.main.bounds.width / 8) * 0.9
        
        return Text("\(self.getSymbol())")
            .font(.system(size: tileSize * 0.8))
            .frame(width: tileSize, height: tileSize)
            .background(self.selected
                        ? Color.blue
                        : self.getTileColor(row: row, col: col))
    }
    
    func getSymbol() -> String {
        switch self.type {
        case .PAWN:
            return self.color == .BLACK ? "\u{265F}" : "\u{2659}"
            
        case .ROOK:
            return self.color == .BLACK ? "\u{265C}" : "\u{2656}"
            
        case .BISHOP:
            return self.color == .BLACK ? "\u{265D}" : "\u{2657}"
            
        case .KNIGHT:
            return self.color == .BLACK ? "\u{265E}" : "\u{2658}"
            
        case .KING:
            return self.color == .BLACK ? "\u{265A}" : "\u{2654}"
            
        case .QUEEN:
            return self.color == .BLACK ? "\u{265B}" : "\u{2655}"
            
        case .EMPTY:
            return ""
        }
    }
    
    func canWalk(pos: [Int]) -> Bool {
        switch self.type {
        case .PAWN:
            return (self.position[0] + 1 == pos[0]
                    || self.position[0] - 1 == pos[0])
                && self.position[1] == pos[1]
            
        default:
            return true
        }
    }
    
    func getTileColor(row: Int, col: Int) -> Color {
        if (row + col) % 2 == 0 {
            return .white
        } else {
            return .gray
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
        hasher.combine(selected)
    }
    
    static func == (lhs: Piece, rhs: Piece) -> Bool {
        return lhs.position == rhs.position
            && lhs.selected == rhs.selected
    }
}

enum PieceType {
    case PAWN
    case KING
    case QUEEN
    case KNIGHT
    case BISHOP
    case ROOK
    case EMPTY
}

enum PieceColor {
    case WHITE
    case BLACK
    case NULL
}
