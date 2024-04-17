//
//  DataSource.swift
//  SwiftUI-Streamlining-Network-Data-Retrieval
//
//  Created by Viacheslav Tkachenko on 17.04.2024.
//

import Foundation
import Combine

//
//  Result of fetching data from the DataSource
//
struct FetchedData<T: Equatable>: Equatable {
    var value: T? = nil
    var isFetching = false // true when fetching is in progress
    var hasFetchedData = false // at least one fetch was done
    
    var isReady: Bool {
        return !isFetching && hasFetchedData
    }
}

@globalActor
actor DataSourceActor {
    static let shared = DataSourceActor()
}

//
// DataSource class which is responsible for fetching the data and trying again after a delay if the fetch failed
//
class DataSource<T: Equatable> {
    
    // resulting data
    @DataSourceActor var data = CurrentValueSubject<FetchedData<T>, Never>(.init())
    
    // block which will be called to fetch the data
    @DataSourceActor private var fetchBlock: (() async throws -> T?)? = nil
    // an index of current fetch operation, to avoid multiple fetches
    @DataSourceActor private var fetchIndex = 0
    // delay after failed fetch to try again
    private let delayAfterFailure: TimeInterval
    
    init(delayAfterFailure: TimeInterval = 3) {
        self.delayAfterFailure = delayAfterFailure
    }
    
    // Safe setter for the fetchBlock
    @DataSourceActor func setFetchBlock(_ block: (() async throws -> T?)?) {
        fetchBlock = block
    }
    
    // method for starting data fetching from a function that does not support concurrency
    func fetch() {
        Task {
            await _fetch()
        }
    }
    
    // method for starting data fetching
    @DataSourceActor func fetchAsync(clearItems: Bool = false) async {
        await _fetch(clearItems: clearItems)
    }
    
    // main method for starting data fetching and trying again after a delay if the fetch failed
    @DataSourceActor private func _fetch(_ force: Bool = false, clearItems: Bool = false) async {
        guard let fetchBlock else { return }
        // if we are already fetching the data, do nothing
        guard !data.value.isFetching || force else { return }

        var newData = data.value
        // storing current fetchIndex
        let index = self.fetchIndex
        // mark that we are fetching
        newData.isFetching = true
        if clearItems {
            newData.value = nil
        }
        // firing the data fetch is in progress
        data.value = newData
        
        do {
            // perform fetch
            let value = try await fetchBlock()
            // if fetchIndex is not equal to the stored, it means that the newest fetch was started
            // and our fetch result is outdated
            guard index == fetchIndex else { return }
            newData.value = value
            // mark that we have fetched the data
            newData.hasFetchedData = true
            // mark that we are not fetching anymore
            newData.isFetching = false
            // firing the data update
            data.value = newData
        } catch {
            Task.detached { [weak self] in
                // waiting for the delayAfterFailure seconds and trying to fetch again
                await Task.sleep(interval: self?.delayAfterFailure ?? 0)
                // if fetchIndex is not equal to the stored, it means that the newest fetch was started
                // and our fetch result is outdated
                guard await self?.fetchIndex == index else { return }
                await self?._fetch(true)
            }
        }
    }
}
