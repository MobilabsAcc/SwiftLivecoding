//
//  Box.swift
//  mvcSample
//
//  Created by Eugene Hyrol on 30/04/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation

class Box<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
