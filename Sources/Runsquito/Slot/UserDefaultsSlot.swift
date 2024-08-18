//
//  UserDefaultsSlot.swift
//
//
//  Created by jsilver on 8/18/24.
//

import Foundation

open class UserDefaultsSlot<Value>: Slot {
    // MARK: - Prorperty
    private let userDefaults: UserDefaults?
    private let key: String
    private let mapper: any Map<Value>
    
    public var value: Value? {
        guard let data = userDefaults?.data(forKey: key) else {
            return nil
        }
        
        return try? mapper.decode(from: data)
    }
    public let description: String?
    
    // MARK: - Initializer
    public init(
        key: String,
        mapper: Mapper<Value>,
        in userDefault: UserDefaults? = .init(suiteName: "_runsquito"),
        description: String? = nil
    ) {
        self.userDefaults = userDefault
        self.key = key
        self.mapper = mapper
        self.description = description
    }
    
    // MARK: - Public
    /// Reset all persisted data in the default Runsquito user defaults.
    public static func reset() {
        UserDefaults.standard.removePersistentDomain(forName: "_runsquito")
    }
    
    open func setValue(_ value: Value?) throws {
        guard let value else {
            userDefaults?.removeObject(forKey: key)
            return
        }
        
        let data = try mapper.encode(value)
        userDefaults?.set(data, forKey: key)
    }
    
    // MARK: - Private
}
