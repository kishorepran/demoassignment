//
//  KisanHubAssignmentTests.swift
//  KisanHubAssignmentTests
//
//  Created by Pran Kishore on 15/01/18.
//  Copyright © 2018 Pran Kishore. All rights reserved.
//

import XCTest
@testable import KisanHubAssignment

class KisanHubAssignmentTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCharatcersForParsing() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        if let path = Bundle.main.path(forResource: "UK", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let rows = data.split(separator: "\r\n").map({String($0)}) //Line sperator of text file is \r\n
                let manager = WaetherDataManager()
                let stripped = manager.strip(FromText:rows, ignoringElements: manager.metadataLines)!
                
                for row in stripped {
                    let columns = row.split(separator: " ").map({String($0)})
                    print(columns.first!)
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    func testParsing() {
        
        if let path = Bundle.main.path(forResource: "UK", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let manager = WaetherDataManager()
                let items = manager.parse(Text: data, forCountry: "UK" , Weather: "Tmean" )
                print(items?.count ?? "Failure")
            } catch {
                print(error)
            }
        }
        
    }
    
    func testURL() {
        
        let url = URL.init(string: "https://www.metoffice.gov.uk/pub/data/weather/uk/climate/datasets/Tmax/date/UK.txt")
        do {
            let data = try Data.init(contentsOf: url!)
            let text = String.init(data: data, encoding: .utf8)
            print(text ?? "Failure")
        } catch {
            print(error)
        }
    }
    
    func testDownloading() {
        let manager = WaetherDataManager()
        manager.downloadAllRecords()
        print(manager.pathForExportedCSVFile() ?? "Faliure")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
