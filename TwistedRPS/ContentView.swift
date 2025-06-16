//
//  ContentView.swift
//  TwistedRPS
//
//  Created by Gurur on 16.06.2025.
//

import SwiftUI

enum Move: String, CaseIterable {
    case rock = "🪨"
    case paper = "📄"
    case scissors = "✂️"
}

enum Goal: String {
    case win = "Win"
    case lose = "Lose"
}

struct ContentView: View {
    @State private var appMove = Move.allCases.randomElement()!
    @State private var goal = Bool.random() ? Goal.win : Goal.lose
    @State private var score: Int = 0
    @State private var round: Int = 1
    @State private var showingScore: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.green, Color.mint],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                VStack {
                    Text("Rock Paper Scissors")
                        .font(.title)
                    Text("Choose wisely.")
                        .foregroundStyle(.secondary)
                }
                
                VStack(spacing: 24) {
                    Text("Round \(round) of 10")
                    Text("App chose: \(appMove.rawValue)")
                    Text("You must: \(goal.rawValue)")
                    
                    HStack(spacing: 32) {
                        ForEach(Move.allCases, id: \.self) { move in
                            Button(action: {
                                play(move)
                            }) {
                                Text(move.rawValue)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
                
                Text("Score: \(score)")
            }
            .padding(36)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 8))
            .alert("Game Over", isPresented: $showingScore) {
                Button("Restart", action: reset)
            } message: {
                Text("Your final score is: \(score)")
            }
        }
    }

    func isWinning(_ player: Move, against opponent: Move) -> Bool {
        switch (player, opponent) {
        case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
            return true
        default:
            return false
        }
    }
    
    func play(_ playerMove: Move) {
        let shouldWin = goal == .win
        let didWin = isWinning(playerMove, against: appMove)
        
        if didWin == shouldWin {
            score += 1
        } else {
            score -= 1
        }
        
        nextRound()
    }
    
    func nextRound() {
        if round == 10 {
            showingScore = true
        } else {
            round += 1
            appMove = Move.allCases.randomElement()!
            goal = Bool.random() ? .win : .lose
        }
    }
    
    func reset() {
        score = 0
        round = 1
        appMove = Move.allCases.randomElement()!
        goal = Bool.random() ? .win : .lose
    }
}

#Preview {
    ContentView()
}
