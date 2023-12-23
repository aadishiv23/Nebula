//
//  ModelListView.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/18/23.
//

import Foundation
import SwiftUI
import Combine
let sampleModels: [String] = ["GPT-4", "GPT-3.5", "Gemini Pro"]

struct ModelListView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Models")) {
                    ForEach(sampleModels, id: \.self) { model in
                        NavigationLink(destination: destinationView(for: model)) {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading) {
                                    Text(model).font(.headline)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Models")
        }
    }

    @ViewBuilder
    private func destinationView(for model: String) -> some View {
        switch model {
        case "GPT-4", "GPT-3.5":
            MessagesView(modelName: model)
        case "Gemini Pro":
            ConversationScreen()
        default:
            EmptyView() // Or some default view
        }
    }
}


/*struct ModelListView_Previews: PreviewProvider {
   // static var cancellables: Set<AnyCancellable>
    static var previews: some View {
        ModelListView(cancellables: cancellables)
    }
}*/
