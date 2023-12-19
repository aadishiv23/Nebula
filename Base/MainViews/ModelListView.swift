//
//  ModelListView.swift
//  Base
//
//  Created by Aadi Shiv Malhotra on 12/18/23.
//

import Foundation
import SwiftUI

let sampleModels: [String] = ["GPT-4", "GPT-3.5", "Gemini Pro"]

struct ModelListView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Models")) {
                    ForEach(sampleModels, id: \.self) { model in
                        NavigationLink(destination: MessagesView( modelName: model)  )  {
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
}

struct ModelListView_Previews: PreviewProvider {
    static var previews: some View {
        ModelListView()
    }
}
