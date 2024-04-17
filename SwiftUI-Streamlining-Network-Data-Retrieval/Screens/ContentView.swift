//
//  ContentView.swift
//  SwiftUI-Streamlining-Network-Data-Retrieval
//
//  Created by Viacheslav Tkachenko on 17.04.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            if viewModel.siteData.isReady {
                let siteData = viewModel.siteData.value
                // do something with the site data
                Text("Site is Loaded!")
            } else {
                // fetching is in process, so we show a loading message
                Text("Loading site data ...")
            }
        }
        .padding()
        .task {
            // setup ViewModel to start fetching data
            await viewModel.setup()
        }
    }
}

#Preview {
    ContentView()
}
