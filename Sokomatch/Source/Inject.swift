//
//  Inject.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 28.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import Foundation

class InjectionResolver {
    
    enum Error: Swift.Error {
        case notRegistered(String)
    }
    
    static let shared = InjectionResolver()
    
    func register<T>(_ injectable: T) {
        injectables["\(T.self)"] = injectable
    }
    
    func resolve<T>(_ type: T.Type) throws -> T {
        let key = "\(type)"
        guard let injectable = injectables[key] as? T else {
            throw Error.notRegistered(key)
        }
        return injectable
    }
    
    // MARK: Private
        
    private var injectables = [String: Any]()
    
    private init() { }
}

@propertyWrapper
struct Inject<T> {
    
    var wrappedValue: T {
        get { return value }
        set { }
    }
    
    init() {
        value = try! InjectionResolver.shared.resolve(T.self)
    }
    
    // MARK: Private
    
    var value: T
}
