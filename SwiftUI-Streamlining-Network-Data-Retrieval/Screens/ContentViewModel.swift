//
//  ContentViewModel.swift
//  SwiftUI-Streamlining-Network-Data-Retrieval
//
//  Created by Viacheslav Tkachenko on 17.04.2024.
//

import Foundation
import Combine

@MainActor
class ContentViewModel: ObservableObject {
    
    // public data for View
    @Published var siteData: FetchedData<String> = .init()

    // 1. create DataSource
    private var siteDataSource: DataSource<String> = .init()

    // has to be called in the View task method to start the data fetching
    func setup() async {
        // 2. initiate DataSource with Data fetching
        await UseCases.setupAsSiteContent(siteDataSource)
        // 3. assing result of DataSource to the Published variable to trigger View refresh
        await siteDataSource.data
            .receive(on: RunLoop.main) // we have to publish View changes only from the main thread
            .assign(to: &$siteData)
        // 4. start fetching site data
        siteDataSource.fetch()
    }
}




