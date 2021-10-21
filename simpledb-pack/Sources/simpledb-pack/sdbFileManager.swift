//
//  sdbFileManager.swift
//  sdbFileManager
//
//  Created by Uygur Kıran on 17.09.2021.
//

import Foundation

//MARK: - FILE MANAGER ERRORS
public enum sdbFileError: String, Error, Equatable {
    case dbNameNotValid = "Please enter a valid database name. Only ASCII characters other than the special characters or whitespaces are allowed."
    case dbDirAlreadyExists = "Database directory already exist"
    case dbDirNotFound = "Database directory not found."
}

extension sdbFileError: CustomStringConvertible {
    public var description: String {
        return "FILE ERROR:\t \(self.rawValue)"
    }
}


//MARK: - FILE MANAGER
internal final class sdbFileManager {
    private init() {}
    static let shared = sdbFileManager()
    
    //MARK: - GET URL, CREATE OR READ DIRECTORIES
    /// Returns the base directory path for databases.
    /// e.g. /Users/uygur/Documents/.cerebloDb
    private func getBaseDirectory() -> URL {
        let baseDirName = ".simpledb"
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsURL = URL(string: paths[0])!
        let baseDirPath = documentsURL.appendingPathComponent(baseDirName)
        
        if FileManager.default.fileExists(atPath: baseDirPath.absoluteString) {
            // check if exists //
            return baseDirPath
        } else {
            // if not, create //
            do {
                try FileManager.default.createDirectory(atPath: baseDirPath.absoluteString,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
                return baseDirPath
            } catch {
                fatalError(error.localizedDescription)
            }
        } //: else
        
    }
        
    
    /// Creates new subdirectory in the base directory for a new db.
    func createNewDirectory(forDbName dbName: String) throws -> URL {
        if dbName.canBeFilename() == false { throw sdbFileError.dbNameNotValid }
        
        // create db folder //
        let dbDirPath = getBaseDirectory().appendingPathComponent(dbName)
        
        if !FileManager.default.fileExists(atPath: dbDirPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dbDirPath.absoluteString,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
                return dbDirPath
            } catch let anyFileError {
                throw anyFileError
            }
        } else {
            throw sdbFileError.dbDirAlreadyExists
        }
        
    }
    
    
    /// Returns db path, if path exists.
    func getDbDirectory(forDbName dbName: String) throws -> URL {
        let dbDirPath = getBaseDirectory().appendingPathComponent(dbName)
        
        if FileManager.default.fileExists(atPath: dbDirPath.absoluteString) {
            return dbDirPath
        } else {
            throw sdbFileError.dbDirNotFound
        }
    }
    
    
    func deleteDbDirectory(dbName: String) throws {
        let dbDirectory = try getDbDirectory(forDbName: dbName)

        try FileManager.default.removeItem(atPath: dbDirectory.absoluteString)
    }
    
    func deleteDbDirectory(dbDirectory: URL) throws {        
        try FileManager.default.removeItem(atPath: dbDirectory.absoluteString)
    }
    
    
    //MARK: - READ & WRITE FILES
    func writeToFile(key: String, value: String, dbPath: URL) throws {
        let keyPath = dbPath.appendingPathComponent("\(key)_str.kv")
        try value.write(toFile: keyPath.absoluteString, atomically: true, encoding: String.Encoding.utf8)
    }    
    
    /// For loading store to a database's in-memory cache
    func readAllFiles(dbPath: URL) throws -> [Int: String] {
        // dir iterator //
        guard let enumerator = FileManager.default.enumerator(atPath: dbPath.absoluteString) else {
            throw sdbFileError.dbDirNotFound
        }
        
        var temp = [Int: String]()
        
        // iterate db dir -> [filenames] //
        while var fn = enumerator.nextObject() as? String {
            
            if enumerator.fileAttributes?[FileAttributeKey.type] as? FileAttributeType == .typeRegular,
                fn.contains(".kv") {
                // read file
                do {
                    let val = try String(contentsOfFile: dbPath.appendingPathComponent(fn).absoluteString)
                    
                    fn = fn.replacingOccurrences(of: "_str.kv", with: "")
                    if let hashVal = Int(fn) {
                        temp[hashVal] = val
                    }
                    
                } catch {
                    continue
                }
            }
            
        } //: loop
        return temp
    }
    
    
    func readFromFile(key: String, dbPath: URL) throws -> String {
        let keyPath = dbPath.appendingPathComponent("\(key)_str.kv")
        
        if FileManager.default.fileExists(atPath: keyPath.absoluteString) {
            return try String(contentsOfFile: keyPath.absoluteString)
        } else {
            throw sdbDBError.keyNotFound
        }
    }
    

} //: end


