//
//  DbManagementsTests.swift
//  DbManagementsTests
//
//  Created by Uygur Kıran on 17.09.2021.
//

import Foundation

final class DbManagementTests: CrbTest {
    private override init() {
        super.init()
    }
    static let shared = DbManagementTests()
    
    func testAllCases() {
        validateDbCreation()
        validateDbLoad()
    }
    
    func validateDbCreation() {
        testCASE("Create a new empty database", "createNewDb()")
        do {
            let newDb = try SimpleDB(byLoadingOrCreatingDb: "validateDbCreation")
            print(newDb)
            
            try newDb.instance().destroyDb()
            print("DB DELETION:\t PASSED")
            
            isPASSED(true)
        } catch {
            print(error)
            isPASSED(false)
        }
        
    }
    
    func validateDbLoad() {
        testCASE("Load a database", "loadDb()")
        do {
            let newDb = try SimpleDB(byLoadingOrCreatingDb: "validateDbLoad").instance()
            print("\nCREATED DATABASE:")
            print(newDb)
            
            let loadedDb = try SimpleDB(byLoadingDb: "validateDbLoad").instance()
            print("\nLOADED DATABASE:")
            print(loadedDb)
            
            try loadedDb.destroyDb()
            print("\nDB DELETION:\t PASSED")
            
            isPASSED((newDb == loadedDb))
        } catch {
            print(error)
            isPASSED(false)
        }
        
    }
    
    
    
} //: end



