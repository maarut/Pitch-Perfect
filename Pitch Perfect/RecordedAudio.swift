//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Maarut Chandegra on 19/01/2016.
//  Copyright © 2016 Maarut Chandegra. All rights reserved.
//

import Foundation

class RecordedAudio {
    let filePathURL: NSURL
    let title: String
    
    init(filePathURL: NSURL, title: String)
    {
        self.filePathURL = filePathURL
        self.title = title
    }
}