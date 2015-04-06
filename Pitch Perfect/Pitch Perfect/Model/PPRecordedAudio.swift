//
//  PPRecordedAudio.swift
//  Pitch Perfect
//
//  Created by Axel Guilmin on 3/24/15.
//
//

import Foundation

class PPRecordedAudio: NSObject {

    var filePathUrl: NSURL!
    var title: String!
    
    convenience init(filePathUrl: NSURL, title: String) {
        self.init()
        self.filePathUrl = filePathUrl
        self.title = title
    }
}