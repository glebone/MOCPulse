//
//  MOCPulseTests.swift
//  MOCPulseTests
//
//  Created by gleb on 7/3/15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit
import XCTest
import SwiftyJSON

class MOCPulseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVoteAPI_Votes_NOT_NILL() {
        let expectation = expectationWithDescription("get votes")
        
        VoteModel.votes { (votesList) -> Void in
            var votes : [VoteModel]? = votesList
            XCTAssertNotNil(votes, "API. When getting votes we receive nil")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)", terminator: "")
            }
        }
    }
    
    func testVoteAPI_TestAll() {
        let expectation = expectationWithDescription("get votes")
        var lastId = "0"
        API.response(API.request(.GET, path: "\(kProductionServer)votes", headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                var json : JSON = object
                XCTAssertNotNil(json["votes"].arrayObject, "Votes array is nil.")
                for (index, subJson): (String, JSON) in object["votes"] {
                    self.testOneVoteWithResult(subJson)
                    
                    lastId = subJson["id"].stringValue
                }
                
                self.testVoteAPI_GetVote_Fields_NOT_NILL(lastId, expectation: nil)
                self.testVoteAPI_VoteFore_Fields_NOT_NILL(lastId, expectation: nil)
                self.testVoteAPI_CreateVote_Fields_NOT_NILL(lastId, expectation: expectation)
                
            },
            failure: { (error : NSError?) -> Void in
                print("API.Error: \(error?.localizedDescription)")
                XCTAssertNil(error, error!.localizedDescription)
                expectation.fulfill()
        });
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)", terminator: "")
            }
        }
    }
    
    func testVoteAPI_GetVote_Fields_NOT_NILL(id: String, expectation: XCTestExpectation?) {

        API.response(API.request(.GET, path: "\(kProductionServer)votes/\(id)", headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                var json : JSON = object
            
                XCTAssertNotEqual(json["vote"].dictionary!.count, 0, "Vote result is nil.")
                json = json["vote"]
                self.testOneVoteWithResult(json)
                
                if (expectation != nil) {
                    expectation?.fulfill()
                }
            },
            failure: { (error : NSError?) -> Void in
                print("API.Error: \(error?.localizedDescription)")
                XCTAssertNil(error, error!.localizedDescription)
                if (expectation != nil) {
                    expectation?.fulfill()
                }
        });
    }
    
    func testVoteAPI_VoteFore_Fields_NOT_NILL(id: String, expectation: XCTestExpectation?) {
        let _parameters: [String : AnyObject] = ["value" : 1]
        API.response(API.request(.PUT, path: "\(kProductionServer)votes/\(id)", parameters: _parameters, headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                var json : JSON = object
                XCTAssertNotEqual(json["vote"].dictionary!.count, 0, "Vote result is nil.")
                json = json["vote"]
                self.testOneVoteWithResult(json)
                
                if (expectation != nil) {
                    expectation?.fulfill()
                }
            },
            failure: { (error : NSError?) -> Void in
                print("API.Error: \(error?.localizedDescription)")
                XCTAssertNil(error, error!.localizedDescription)
                if (expectation != nil) {
                    expectation?.fulfill()
                }
        });
    }
    
    func testVoteAPI_CreateVote_Fields_NOT_NILL(name: String, expectation: XCTestExpectation?) {
        API.response(API.request(.POST, path: "\(kProductionServer)votes", parameters: ["name" : name, "type" : "1"], headers: kAuthToken_FIXME),
            success: { (object) -> Void in
                var json : JSON = object
                XCTAssertNotEqual(json["vote"].dictionary!.count, 0, "Vote result is nil.")
                json = json["vote"]
                self.testOneVote(json)
                
                if (expectation != nil) {
                    expectation?.fulfill()
                }
            },
            failure: { (error : NSError?) -> Void in
                print("API.Error: \(error?.localizedDescription)")
                XCTAssertNil(error, error!.localizedDescription)
                if (expectation != nil) {
                    expectation?.fulfill()
                }
        });
    }
    
    func testOneVoteWithResult(json: JSON) {
        testOneVote(json)
        
        XCTAssertNotEqual(json["result"].dictionary!.count, 0, "Votes result is nil.")
        XCTAssertNotNil(json["result"]["green"].number, "Result green number is nil.")
        XCTAssertNotNil(json["result"]["yellow"].number, "Result yellow number is nil.")
        XCTAssertNotNil(json["result"]["red"].number, "Result red number is nil.")
        XCTAssertNotNil(json["result"]["all_users"].number, "Result all_user number is nil.")
        XCTAssertNotNil(json["result"]["vote_users"].number, "Result vote_users number is nil.")
    }
    
    func testOneVote(json: JSON) {
        XCTAssertNotNil(json["id"].string, "Id string is nil.")
        XCTAssertNotNil(json["name"].string, "Name string is nil.")
        XCTAssertNotNil(json["owner"].string, "Owner string is nil.")
        XCTAssertNotNil(json["date"].number, "Date number is nil.")
        XCTAssertNotNil(json["voted"].bool, "Voted bool is nil.")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
