//
//  Square.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/17/23.
//

import Foundation
import SwiftUI

// We can make the square's size a constant and use that
let squareSize: CGFloat = 10

// Our square
struct SquareView: View {
  var color: Color
  
  var body: some View {
    RoundedRectangle(cornerRadius: 0)
      .frame(width: squareSize, height: squareSize, alignment: .center)
      .foregroundColor(color)
    }
}


// Our preview
struct ComponentsSquares_Previews: PreviewProvider {
    static var previews: some View {
        // Colours
        let colors = [
            Color.red,
            Color.blue,
            Color.green,
            Color.yellow,
        ]

        // This will be our desired spacing we want for our grid
        // If you want the grid to be truly square you can just set this to 'squareSize'
        let spacingDesired: CGFloat = 25

        // These are our grid items we'll use in the 'LazyHGrid'
        let rows = [
            GridItem(.fixed(squareSize), spacing: spacingDesired, alignment: .center),
            GridItem(.fixed(squareSize), spacing: spacingDesired, alignment: .center)
        ]

        // We then use the 'spacingDesired' in the grid
        LazyHGrid(rows: rows, alignment: .center, spacing: spacingDesired, pinnedViews: [], content: {
            ForEach(0 ..< 4) { colorIndex in
                SquareView(color: colors[colorIndex])
            }
        })
    }
}
