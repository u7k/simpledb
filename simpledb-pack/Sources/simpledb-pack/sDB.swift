//
//  sdbDatabase.swift
//  sdbDatabase
//
//  Created by Uygur Kıran on 19.09.2021.
//

import Foundation
import AppKit

//MARK: - DATABASE ERRORS
public enum sdbDBError: String, Error {
    case cannotCreateNewDB = "Cannot create new db."
    case dbNotLoaded = "SimpleDB: No databases loaded."
    case dbAlreadyExists = "Database already exists."
    case dbNotFound = "Database doesn't exist or cannot be found."
    case keyNotFound = "Key doesn't exists."
}

extension sdbDBError: CustomStringConvertible {
    public var description: String {
        return "DATABASE ERROR:\t \(self.rawValue)"
    }
}


//MARK: - PUBLIC METHODS INTERFACE
private protocol sdbDBAbstract {
    // self management //
    func destroyDb() throws
    
    // get-only metadata //
    func getName() -> String
    func getDirectory(shortened: Bool) -> String
    
    // actions //
    func setValue(key: String, value: String) throws
    func getValue(withKey key: String) throws -> String
}


//MARK: - DB PROPERTIES
private struct sdbDBProps {
    let dbName: String
    let dbPath: URL
    
    // db's in-memory cache: `[hashedKey: value]`
    var store = [Int: String]()
}


//MARK: - DB MODEL
public final class sDB: sdbDBAbstract {
    private var props: sdbDBProps
    private let fileManager: sdbFileManager
    
    private init(dbName: String, dbPath: URL) {
        self.props = sdbDBProps(dbName: dbName,
                                dbPath: dbPath)
        self.fileManager = sdbFileManager.shared
        try? self.loadStore()
    }
    
    private func loadStore() throws {
        props.store = try fileManager.readAllFiles(dbPath: props.dbPath)
    }
    
    internal static func createDb(withName name: String) throws -> sDB {
        do {
            let dbPath = try sdbFileManager.shared.createNewDirectory(forDbName: name)

            return sDB(dbName: name, dbPath: dbPath)
        } catch let fileError {
            if fileError == sdbFileError.dbDirAlreadyExists {
                // db dir exists
                throw sdbDBError.dbAlreadyExists
            } else {
                // other file error
                throw fileError
            }
        }
    }
    
    internal static func loadDb(withName name: String) throws -> sDB {
        do {
            let dbPath = try sdbFileManager.shared.getDbDirectory(forDbName: name)

            return sDB(dbName: name, dbPath: dbPath)
        } catch let fileError {
            if fileError == sdbFileError.dbDirNotFound {
                throw sdbDBError.dbNotFound
            } else {
                // or any file error
                throw fileError
            }
        }
    }
    
    internal static func destroyDb(withName name: String) throws {
        try sdbFileManager.shared.deleteDbDirectory(dbName: name)
    }
    
    
    //MARK: - PUBLIC METHODS
    /// Deletes a database
    public func destroyDb() throws {
        try fileManager.deleteDbDirectory(dbDirectory: props.dbPath)
        
        // empty cached data
        props.store = [:]
    }

    /// Returns database's name
    public func getName() -> String {
        return props.dbName
    }
    
    /// Returns database's path
    public func getDirectory(shortened: Bool = true) -> String {
        return shortened ? props.dbPath.path : props.dbPath.absoluteString
    }
    
    public func setValue(key: String, value: String) throws {
        let hashed = key.persistentHash
        try fileManager.writeToFile(key: String(hashed), value: value, dbPath: props.dbPath)

        // update cached data
        props.store[hashed] = value
    }
    
    public func getValue(withKey key: String) throws -> String {
        let hashed = key.persistentHash
        if let val = props.store[hashed] { return val }
        throw sdbDBError.keyNotFound
    }
    
    /// DEPRECATED
    @available(*, deprecated)
    private func getValueFromDisc(withKey key: String) throws -> String {
        return try fileManager.readFromFile(key: String(key.persistentHash), dbPath: props.dbPath)
    }
    
    
} //: end


//MARK: - CrbDatabase EXTENSIONS
extension sDB: CustomStringConvertible, Equatable {
    public var description: String {
        return "*** Database *** \n name: \(self.props.dbName) \n path: \(self.props.dbPath.path)"
    }
    
    /// Make Equatable:  ==  if paths match
    public static func == (lhs: sDB, rhs: sDB) -> Bool {
        return (lhs.props.dbPath == rhs.props.dbPath)
    }
}

