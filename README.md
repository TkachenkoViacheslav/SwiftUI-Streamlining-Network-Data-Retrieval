# SwiftUI-Streamlining-Network-Data-Retrieval

Almost all mobile applications involve some form of network operations. However, dealing with poor network conditions often requires tedious error handling and repeated attempts in every ViewModel. This repository contains an example of useful class DataSource which can help to streamline network data retrieval in ViewModels.

## DataSource
The class, named DataSource, is a versatile generic class suitable for retrieving data from a network - or any other potentially faulty operations. It features an asynchronous completion block that either returns a result or throws an error, which can be customized according to your application's needs. Additionally, it includes an asynchronous method called 'fetch' that initiates data retrieval. The outcomes are delivered in a CurrentValueSubject, accompanied by status flags such as isFetching (indicating if an operation is underway and a loader view should be displayed) and hasFetchedData (confirming that at least one fetch operation has been successful).

## Make ViewModel network-independent
To make our ViewModel network-independent, we can initialize DataSource using another class, which I like to refer to as UseCases.

## Usage scenario
1. create DataSource
private var siteDataSource: DataSource<String> = .init()

2. initiate DataSource with Data fetching
await siteDataSource.setFetchBlock {
    try await SiteDownloaderHelper.downloadHTML(from: "https://google.com")
}
3. assing result of DataSource to the Published variable to trigger View refresh
await siteDataSource.data
    .receive(on: RunLoop.main) // we have to publish View changes only from the main thread
    .assign(to: &$siteData)
4. start fetching site data
    siteDataSource.fetch()


The full article you can find [here](https://medium.com/@tkachenko.slava/streamlining-network-data-retrieval-in-viewmodels-07e5f5adf3e1)