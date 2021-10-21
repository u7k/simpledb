//
//  sdpCli.swift
//
//  Created by Uygur Kıran on 18.09.2021.
//

import Foundation
import simpledb_pack
import ArgumentParser

// MARK: - CLI ENTRY
/// Command Line Interface for managing databases. Use `sdpCli.main()` to init.
struct sdpCli: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: "simpledb-cli",
                                                    version: "1.0",
                                                    subcommands: [
                                                        Create_.self,
                                                        Destroy_.self,
                                                        Set_.self, 
                                                        Get_.self,
                                                        RunTest_.self
                                                    ])
    
} //: end



//MARK: - ARGS & HANDLING
extension sdpCli {
    static private func validateDbName(_ name: String) throws {
        if name.canBeFilename() == false {
            throw ValidationError("Please enter a valid database name." +
                                  "\n Only ASCII characters without the special caracters or whitespaces are allowed.")
        }
    }
    
    private struct RunTest_: ParsableCommand {
        static let configuration = CommandConfiguration(commandName: "runtest",
                                                        abstract: "Creates a new database",
                                                        shouldDisplay: false)
        
        func run() throws {
            SimpleDB.runTests()
        }
    }
    
    private struct Create_: ParsableCommand {
        static let configuration = CommandConfiguration(commandName: "create",
                                                        abstract: "Creates a new database")
        
        @Argument(help: "Name of the database.")
        var name: String
        
        func validate() throws {
            try validateDbName(name)
        }
        
        func run() throws {
            // create new db //
            do {
                let db = try SimpleDB(byLoadingOrCreatingDb: name).instance()
                print(db)
                print("*** SUCCESS ***")
            } catch {
                print(error)
            }
                    
        }
        
    }
    
    
    private struct Destroy_: ParsableCommand {
        static let configuration = CommandConfiguration(commandName: "destroy",
                                                        abstract: "Deletes a database")
        
        @Argument(help: "Name of the database")
        var name: String
        
        func validate() throws {
            try validateDbName(name)
        }
        
        func run() throws {
           // FIXME: ask if sure?
            do {
                try SimpleDB.destroyDb(withName: name)
                print("*** SUCCESS ***")
            } catch {
                print(error)
            }
            
            
        }
        
    }
    
    
    private struct Set_: ParsableCommand {
        static let configuration = CommandConfiguration(commandName: "set",
                                                        abstract: "Creates a key-value or sets value to a key in database")
        
        @Argument(help: "Name of the database")
        var name: String
        
        @Argument(help: "Key to set")
        var key: String
        
        @Argument(help: "Value to set")
        var value: String
        
        func validate() throws {
            try validateDbName(name)
        }
        
        func run() throws {
            do {
                let db = try SimpleDB(byLoadingDb: name).instance()
                try db.setValue(key: key, value: value)
                print("*** SUCCESS ***")
            } catch {
                print(error)
            }
            
        }
        
    }
    
    
    private struct Get_: ParsableCommand {
        static let configuration = CommandConfiguration(commandName: "get",
                                                        abstract: "Gets the value associated with a key from database")
        
        @Argument(help: "Name of the database")
        var name: String
        
        @Argument(help: "Key to get")
        var key: String
        
        func validate() throws {
            try validateDbName(name)
        }
        
        func run() throws {
            do {
                let db = try SimpleDB(byLoadingDb: name).instance()
                let val = try db.getValue(withKey: key)
                print(val)
            } catch {
                print(error)
            }
        }
        
    }
    
    
} //: end




