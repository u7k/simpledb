//
//  keyValueTests.swift
//  keyValueTests
//
//  Created by Uygur Kıran on 18.09.2021.
//

import Foundation

final class keyValueTests: sdbTest {
    private override init() {
        super.init()
    }
    static let shared = keyValueTests()
    
    func testAllCases() {
        validateKeyValueGetSet()
        validateKeyValueCaching()
    }
    
    func validateKeyValueGetSet() {
        testCASE("Store and retrieve value")
        
        do {
            let newDb = try SimpleDB(byLoadingOrCreatingDb: "validateKeyValueGetSet").instance()
            
            let key = "testKey"
            let value = "test value"
            
            print("VALUE TO TEST:\t \(value)")
            
            try newDb.setValue(key: key, value: value)
            print("SETTING VALUE:\t PASSED")
            
            let result = try newDb.getValue(withKey: key)
            print("RETRIVED VALUE:\t \(result)")
            
            try newDb.destroyDb()
            print("DB DELETION:\t PASSED")
            
            isPASSED((result == value))
        } catch {
            print(error)
            isPASSED(false)
        }
    }
    
    
    func validateKeyValueCaching() {
        testCASE("Cache db in-memory. Get value from the cache.")
        
        do {
            let newDb = try SimpleDB(byLoadingOrCreatingDb: "validateKeyValueCaching").instance()
            
            let testKey = "testKey2"
            let testVal = "testValue2"
            
            try newDb.setValue(key: "testKey1", value: "testValue1")
            try newDb.setValue(key: testKey, value: testVal)
            try newDb.setValue(key: "testKey3", value: "testValue3")
            try newDb.setValue(key: "testKey4", value: "testValue4")
            print("SETTING VALUES:\t PASSED")
            
            
            let gotVal = try newDb.getValue(withKey: testKey)
            print("RETRIEVING IN-MEMORY VALUE:\t PASSED")
            
            try newDb.destroyDb()
            print("DB DELETION:\t PASSED")
            
            isPASSED( (testVal == gotVal) )
        } catch {
            print(error)
            isPASSED(false)
        }
        
    }
    
    
    // TODO: performance test with 1000 keys, etc.
    
    
} //: end
