//
//  sdbExts.swift
//  sdbExts
//
//  Created by Uygur Kıran on 18.09.2021.
//

import Foundation 

//MARK: - STRING
extension String {
    /// Generates hashes for `keys` to be stored and retrieved.
    var persistentHash: Int {
        return self.utf8.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
    
    /// Filenames can contain only ASCII characters other than special characters and whitespaces.
    public func canBeFilename() -> Bool {
        if self.count < 1 || self.count > 32 || !self.canBeConverted(to: .ascii) { return false }
        
        let illegalChars = "?/!^%\\,. "
        return self.allSatisfy({ illegalChars.contains($0) == false })
    }
    
}


//MARK: - EQUATABLE W ERROR
extension Equatable where Self : Error {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs as Error == rhs as Error
    }
}

/// Makes Error & CustomErrors Equatable. e.g. if ( anyError == CrbFileError ) { }
public func == (lhs: Error, rhs: Error) -> Bool {
    guard type(of: lhs) == type(of: rhs) else { return false }
    let error1 = lhs as NSError
    let error2 = rhs as NSError
    return error1.domain == error2.domain && error1.code == error2.code && "\(lhs)" == "\(rhs)"
}
