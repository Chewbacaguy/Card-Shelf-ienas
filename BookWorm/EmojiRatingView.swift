//
//  EmojiRatingView.swift
//  BookWorm
//
//  Created by Santiago Torres Alvarez on 26/10/23.
//

import SwiftUI

struct EmojiRatingView: View {
    let rating: Int16
    var body: some View {
        switch rating {
        case 1:
            return Text("♣️")
        case 2:
            return Text("♠️")
        case 3:
            return Text("♦️")
        case 4:
            return Text("♥️")
        case 5:
            return Text("♥️")
        default:
            return Text("🃏")
        }
    }
}

//#Preview {
//    EmojiRatingView()
//}
