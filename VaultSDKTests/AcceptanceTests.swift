//
//  AcceptanceTests.swift
//  VaultSDK
//
//  Created by Fang-Pen Lin on 11/22/16.
//  Copyright © 2016 Very Good Security. All rights reserved.
//

import XCTest

@testable import VaultSDK

class AcceptanceTests: XCTestCase {
    static let baseURL = NSURL(string: "https://demo.sandbox.verygoodvault.com")!
    static let publishableKey = "demo-user"

    override func setUp() {
        super.setUp()
    }

    func testCreateToken() {
        let api: VaultAPI = VaultAPI(
            baseURL: AcceptanceTests.baseURL,
            publishableKey: AcceptanceTests.publishableKey
        )

        let exp = expectationWithDescription("token created")
        api.createToken(
            "4111111111111111",
            failure: { error in
                XCTFail("Failed to create token, error=\(error)")
                exp.fulfill()
            },
            success: { token in
                if let id = token["id"] as? String {
                    XCTAssert(id.hasPrefix("tok_"))
                } else {
                    XCTFail("No token created")
                }
                exp.fulfill()
            }
        )
        waitForExpectationsWithTimeout(10, handler: nil)
    }

    func testCreateTokenWithBadKey() {
        let api: VaultAPI = VaultAPI(
            baseURL: AcceptanceTests.baseURL,
            publishableKey: "bad key"
        )
        let exp = expectationWithDescription("token creation failed")
        api.createToken(
            "4111111111111111",
            failure: { error in
                XCTAssertEqual(error.code, VaultAPIError.BadResponse.rawValue)
                XCTAssertEqual((error.userInfo["status_code"] as? NSNumber)?.intValue, 401)
                exp.fulfill()
            },
            success: { token in
                XCTFail("Should bad response")
                exp.fulfill()
            }
        )
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
