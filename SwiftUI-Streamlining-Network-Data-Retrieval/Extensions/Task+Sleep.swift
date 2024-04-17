//
//  Task+Sleep.swift
//  SwiftUI-Streamlining-Network-Data-Retrieval
//
//  Created by Viacheslav Tkachenko on 17.04.2024.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    public static func sleep(interval: Double) async {
        try? await sleep(nanoseconds: UInt64(interval * 1e9))
    }
}
