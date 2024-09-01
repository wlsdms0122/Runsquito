//
//  UserDefaultsSlot.swift
//
//
//  Created by jsilver on 8/18/24.
//

import Foundation

open class UserDefaultsSlot<Value>: Slot<Value> {
    // MARK: - Prorperty
    private let userDefaults: UserDefaults?
    private let key: String
    private let mapper: any Map<Value>
    
    public override var value: Value? {
        guard let data = userDefaults?.data(forKey: key) else {
            return nil
        }
        
        return try? mapper.decode(from: data)
    }
    
    // MARK: - Initializer
    public init(
        key: String,
        mapper: Mapper<Value>,
        in userDefaults: UserDefaults? = .init(suiteName: "_runsquito"),
        description: String? = nil
    ) {
        self.userDefaults = userDefaults
        self.key = key
        self.mapper = mapper
        
        super.init(nil, description: description)
    }
    
    // MARK: - Public
    /// Reset all persisted data in the default Runsquito user defaults.
    public static func reset() {
        UserDefaults.standard.removePersistentDomain(forName: "_runsquito")
    }
    
    open override func setValue(_ value: Value?) throws {
        valueWillChange.send()
        
        guard let value else {
            userDefaults?.removeObject(forKey: key)
            return
        }
        
        let data = try mapper.encode(value)
        userDefaults?.set(data, forKey: key)
    }
    
    // MARK: - Private
}
