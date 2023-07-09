//
//  Piece.swift
//  Chess
//
//  Created by MacHome on 07/07/23.
//

import SwiftUI
import Foundation

class Piece: Hashable {
    var color: PieceColor
    var position: [Int]
    var selected: Bool
    
    init(color: PieceColor, position: [Int]) {
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
        return ""
    }
    
    func canWalk(pos: [Int]) -> Bool {
        return true
    }
    
    func getTileColor(row: Int, col: Int) -> Color {
        if (row + col) % 2 == 0 {
            return .white
        }
        
        return .gray
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

class Pawn: Piece {
    
    override func getSymbol() -> String {
        return self.color == .BLACK ? "\u{265F}" : "\u{2659}"
    }
    
    override func canWalk(pos: [Int]) -> Bool {
        return (self.position[0] + 1 == pos[0]
                || self.position[0] - 1 == pos[0])
                && self.position[1] == pos[1]
    }
    
}

class King: Piece {
    
    override func getSymbol() -> String {
        return self.color == .BLACK ? "\u{265A}" : "\u{2654}"
    }
    
    override func canWalk(pos: [Int]) -> Bool {
        let f = { (p0: Int, p1: Int) -> Bool in p0 + 1 == p1 || p0 - 1 == p1 }
        
        return (f(self.position[0], pos[0]) && self.position[1] == pos[1])
            || (f(self.position[1], pos[1]) && self.position[0] == pos[0])
            || (f(self.position[1], pos[1]) && f(self.position[0], pos[0]))
    }
    
}

class Queen: Piece {
    
    override func getSymbol() -> String {
        return self.color == .BLACK ? "\u{265B}" : "\u{2655}"
    }
    
    override func canWalk(pos: [Int]) -> Bool {
        let rookWalk = { (p0: Int, p1: Int) -> Bool in p0 > p1 || p0 < p1 }
        let bishopWalk = { (p0: Int, p1: Int, p2: Int) -> Bool in p0 + p1 == p2 || p0 - p1 == p2 }
        
        return (self.position[0] == pos[0] && rookWalk(pos[1], self.position[1]))
            || (self.position[1] == pos[1] && rookWalk(pos[0], self.position[0]))
            || ((pos[0] > self.position[0] || pos[0] < self.position[0])
               && bishopWalk(self.position[1], abs(self.position[0] - pos[0]), pos[1]))
    }
    
}

class Knight: Piece {
    
    override func getSymbol() -> String {
        return self.color == .BLACK ? "\u{265E}" : "\u{2658}"
    }
    
    override func canWalk(pos: [Int]) -> Bool {
        let f = { (p0: Int, p1: Int) -> Bool in p0 + 2 == p1 || p0 - 2 == p1 }
        
        return ((self.position[0] + 1 == pos[0] || self.position[0] - 1 == pos[0])
                && f(self.position[1], pos[1]))
    }
    
}

class Bishop: Piece {
    
    override func getSymbol() -> String {
        return self.color == .BLACK ? "\u{265D}" : "\u{2657}"
    }
    
    override func canWalk(pos: [Int]) -> Bool {
        let f = { (p0: Int, p1: Int, p2: Int) -> Bool in p0 + p1 == p2 || p0 - p1 == p2 }
        
        return ((pos[0] > self.position[0] || pos[0] < self.position[0])
                && f(self.position[1], abs(self.position[0] - pos[0]), pos[1]))
    }
    
}

class Rook: Piece {
    
    override func getSymbol() -> String {
        return self.color == .BLACK ? "\u{265C}" : "\u{2656}"
    }
    
    override func canWalk(pos: [Int]) -> Bool {
        let f = { (p0: Int, p1: Int) -> Bool in p0 > p1 || p0 < p1 }
        
        return (self.position[0] == pos[0] && f(pos[1], self.position[1]))
            || (self.position[1] == pos[1] && f(pos[0], self.position[0]))
    }
    
}

class Empty: Piece {
    
    override func canWalk(pos: [Int]) -> Bool {
        return false
    }
    
}

enum PieceColor {
    case WHITE
    case BLACK
    case NULL
}
