//
//  UseCases.swift
//  SwiftUI-Streamlining-Network-Data-Retrieval
//
//  Created by Viacheslav Tkachenko on 17.04.2024.
//

import Foundation

class UseCases {
    static func setupAsSiteContent(_ dataSource: DataSource<String>) async {
        await dataSource.setFetchBlock {
            try await SiteDownloaderHelper.downloadHTML(from: "https://google.com")
        }
    }
}
