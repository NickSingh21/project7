//
//  ContentView.swift
//  Memory Game
//
//  Created by Kyenret Yakubu Ayuba on 3/22/24.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            //.padding()
            //.background(.blue)
           // .foregroundStyle(.white)
          //  .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.5), value: configuration.isPressed)
    }
}

struct ContentView: View {
    @State private var cards: [Card] = []
   // @State private var cards: [Card] = Card.mockedCards
    //@State private var cards: [Card] = []
    @State private var selectedIndices: [Int] = [] // Store indices of tapped cards
    @State private var gridSize: Int?
    
    //@State private var selection = "Select Size"
   // let sizes = ["3 Pairs", "6 Pairs", "10 Pairs"]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3) // Define grid columns
    
    
    var body: some View {
        Menu("Choose Size") {
            Button("3 Pairs", action: { setSize(3) })
            Button("6 Pairs", action: { setSize(6) })
            Button("10 Pairs", action: { setSize(10) })
                }
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .buttonStyle(GrowingButton())
        //.font(.title)
        .foregroundStyle(.white)
        
            //}
        VStack{
            //Reset button
            Button(action: {
                resetGame()
            }) {
                Text("Reset Game")
            }
            .padding()
            .background(.green)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .buttonStyle(GrowingButton())
//            .padding(.trailing, 13) // Add padding to the right
//            .background(Color(red: 0, green: 0.1, blue: 0))
//            .clipShape(Capsule())
//            .bold()
//            //.font(.title)
//            .foregroundStyle(.white)
//
        }
        // Grid of cards
        ScrollView{
            LazyVGrid(columns: columns, spacing: 10) { // Use LazyVGrid for vertical layout
                ForEach(cards.indices, id: \.self) { index in
                    CardView(card: cards[index], onTap: {
                        if selectedIndices.count < 2 { // Allow only two selections at a time
                            selectCard(at: index)
                        }
                    })
                    .padding(10) // Add padding for spacing between cards
                    //.opacity(selectedIndices.contains(index) ? 0.5 : 1.0) // Dim the card if it's selected
                    //.buttonStyle(GrowingButton())
                }
            }
        }
        .padding() // Add padding to the grid
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(Color.gray.opacity(0.2)) // Set background color
    }
    
    private func setSize(_ pairs: Int) {
            cards = Card.generatePairs(count: pairs)
            gridSize = pairs * 2
        }
    
    //private func setCards(count: Int) {
         //   cards = Card.generatePairs(count: count)
      //  }
    // Function to select a card
    private func selectCard(at index: Int) {
        if selectedIndices.contains(index) || cards[index].isMatched {
            return // Ignore if the card is already selected or matched
        }
        
        selectedIndices.append(index)
        
        if selectedIndices.count == 2 {
            checkForMatch()
        }
    }
    
    // Function to check for a match
    private func checkForMatch() {
        //var myCards = cards
        let firstIndex = selectedIndices[0]
        let secondIndex = selectedIndices[1]
        
        if cards[firstIndex].emoji == cards[secondIndex].emoji {
            // Mark cards as matched
            cards[firstIndex].isMatched = true
            cards[secondIndex].isMatched = true
        }else {
            // Return the cards to the facedown position
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.flipCard(at: firstIndex)
                self.flipCard(at: secondIndex)
                //                    [self] in
                //                    var updatedCards = self.cards
                //                    updatedCards[firstIndex].isFaceDown = true
                //                    updatedCards[secondIndex].isFaceDown = true
                //                    self.cards = updatedCards
            }
        }
        
        //cards = myCards
        // Clear selected indices
        selectedIndices.removeAll()
    }
    // Function to reset the game
    private func resetGame() {
        //var myCards = cards
        // Reset game-related state
        cards.shuffle()
        //myCards.isFaceDown()
        selectedIndices.removeAll()
        for i in cards.indices {
            cards[i].isMatched = false
            if cards[i].isFaceDown {
                flipCard(at: i)
            }
        }
    }
    //cards = myCards
    //}
    private func flipCard(at index: Int) {
        cards[index].isFaceDown.toggle()
        //var updatedCards = self.cards
        //updatedCards[index].isFaceDown.toggle()
        //self.cards = updatedCards
    }
    func sixCards() { }
    func twelveCards() { }
    func twentyCards() { }
}

#Preview {
    ContentView()
}
