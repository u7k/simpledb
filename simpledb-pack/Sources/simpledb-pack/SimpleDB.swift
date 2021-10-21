//
//  SimpleDB.swift
//  SimpleDB
//
//  Created by Uygur Kıran on 17.09.2021.
//

import Foundation

//MARK: - DB MANAGER
public final class SimpleDB {
    private var currentDb: sDB?
    
    public init(byLoadingDb named: String) throws {
        currentDb = try SimpleDB.loadDb(withName: named)
    }
    
    public init(byCreatingDb named: String) throws {
        currentDb = try SimpleDB.createDb(withName: named)
    }
    
    public init(byLoadingOrCreatingDb named: String) throws {
        do {
            // try load
            currentDb = try SimpleDB.loadDb(withName: named)
        } catch let err {
            if err == sdbDBError.dbNotFound {
                // or create new
                currentDb = try SimpleDB.createDb(withName: named)
            }
        }
    }
    
    deinit {
        currentDb = nil
    }
    
    //MARK: - PUBLIC METHODS
    /// Get a reference of the current database instance
    public func instance() throws -> sDB {
        if currentDb != nil { return currentDb! }
        throw sdbDBError.dbNotLoaded
    }
    
    /// Loads another database to `.instance()`
    public func changeInstance(byLoadingAnotherDb named: String) throws {
        self.currentDb = try sDB.loadDb(withName: named)
    }
    
    /// Close current database instance
    public func terminateInstance() {
        currentDb = nil
    }
    
    //MARK: - STATIC METHODS
    private static func createDb(withName name: String) throws -> sDB {
        return try sDB.createDb(withName: name)
    }
    
    /// Loads and returns a CrbDatabase instance
    private static func loadDb(withName name: String) throws -> sDB {
        let db = try sDB.loadDb(withName: name)
        return db
    }
    
    /// Deletes a database
    public static func destroyDb(withName name: String) throws {
        try sDB.destroyDb(withName: name)
    }
    
    public static func runTests() {
        DbManagementTests.shared.testAllCases()
        KeyValueTests.shared.testAllCases()
    }
    
} //: end
