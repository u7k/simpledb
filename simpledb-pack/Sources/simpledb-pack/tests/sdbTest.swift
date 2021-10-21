//
//  CrbTest.swift
//  CrbTest
//
//  Created by Uygur Kıran on 18.09.2021.
//

import Foundation

internal class sdbTest {
    /// Calc execution time
    private var t0 = DispatchTime.now()
    private func timerStart() { t0 = DispatchTime.now() }
    private func timerGetResult() -> Double {
        let nanoTime = Double(DispatchTime.now().uptimeNanoseconds - t0.uptimeNanoseconds)
        return nanoTime / 1_000_000
    }
    
    /// Prints test case
    func testCASE(_ msg: String, _ funcsToTest: String... ) {
        print("*****************************")
        print("TEST CASE:\t \(msg)")
        
        if !funcsToTest.isEmpty {
            let tempStr = funcsToTest.map({ "\($0)" }).joined(separator: " | ")
            print("FUNCs INVOLVED: \(tempStr)")
        }
        
        timerStart()
    }
    
    /// Prints if a test is passed (condition == true) or not. If not, 'fatality' arg. can create an assertionFailure().
    func isPASSED(_ condition: Bool, fatality: Bool = true) {
        print("DURATION:\t \(timerGetResult()) ms")
        if condition {
            print("*** PASSED ***")
            print("*****************************")
            print("\n")
        } else {
            print("*** NOT PASSED ***")
            print("*****************************")
            print("\n")
            if fatality { assertionFailure(
                OperationQueue.current?.name ??
                OperationQueue.current?.underlyingQueue?.label ?? "") }
        }
        
        
    }
    
} //: end
