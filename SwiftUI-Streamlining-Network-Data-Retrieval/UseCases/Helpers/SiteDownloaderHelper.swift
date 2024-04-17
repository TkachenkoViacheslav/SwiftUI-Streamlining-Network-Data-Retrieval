//
//  SiteDownloaderHelper.swift
//  SwiftUI-Streamlining-Network-Data-Retrieval
//
//  Created by Viacheslav Tkachenko on 17.04.2024.
//

import Foundation

//
// Helper class for downloading HTML from a site
//
class SiteDownloaderHelper {
    static func downloadHTML(from urlString: String) async throws -> String {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.mimeType == "text/html" else {
            throw URLError(.unsupportedURL)
        }
        
        guard let htmlString = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeRawData)
        }
        
        return htmlString
    }
}
