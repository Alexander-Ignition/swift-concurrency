//
//  ArrayBuilder.swift
//  experiment
//
//  Created by Alexander Igantev on 11/12/20.
//

import Foundation

@resultBuilder // @_functionBuilder // next swift version
enum ArrayBuilder {
    static func buildBlock<T>(_ components: T...) -> [T] {
        components
    }
}

enum AppConfiguration {
    
    @ArrayBuilder
    static var numbers: [Int] {
        2
        2
        3
    }
}
