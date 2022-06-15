//
//  UploadData.swift
//  httpMethodExercise
//
//  Created by Ivan Pavic on 14.6.22..
//

import Foundation

struct POSTMethodUploadData: Codable {
    let title: String
    let body: String
    let userId: Int
}
