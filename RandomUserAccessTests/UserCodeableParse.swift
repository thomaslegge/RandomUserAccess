//
//  UserCodeableParse.swift
//  RandomUserAccessTests
//
//  Created by Thomas Legge on 4/06/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import XCTest
@testable import RandomUserAccess

/// Test User codeable result against string
class UserCodeableParse: XCTestCase {
    
    let testUserString =
    """
    {
        "results": [
            {
                "gender": "female",
                "name": {
                    "title": "Miss",
                    "first": "Isabella",
                    "last": "Johansen"
                },
                "location": {
                    "street": {
                        "number": 6071,
                        "name": "Havremarken"
                    },
                    "city": "Viby Sj.",
                    "state": "Hovedstaden",
                    "country": "Denmark",
                    "postcode": 88738,
                    "coordinates": {
                        "latitude": "-27.1194",
                        "longitude": "149.2914"
                    },
                    "timezone": {
                        "offset": "+4:30",
                        "description": "Kabul"
                    }
                },
                "email": "isabella.johansen@example.com",
                "login": {
                    "uuid": "643a94f3-ddf0-4d92-bbdf-942e7a7472bf",
                    "username": "yellowlion358",
                    "password": "stephen",
                    "salt": "Z8c2KiDR",
                    "md5": "9e6e1d49b775ae60bba25da1102e276a",
                    "sha1": "9f94ec0d63d168d191f0c24516c8efb3aff6eaad",
                    "sha256": "7c39f745a143342947a490d5792f5c197003aa3fcc3bafad72c47e1599aa9f0b"
                },
                "dob": {
                    "date": "1951-09-09T20:20:57.243Z",
                    "age": 69
                },
                "registered": {
                    "date": "2018-06-09T18:59:44.850Z",
                    "age": 2
                },
                "phone": "64241793",
                "cell": "96710817",
                "id": {
                    "name": "CPR",
                    "value": "090951-3542"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/women/43.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/women/43.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/women/43.jpg"
                },
                "nat": "DK"
            }
        ],
        "info": {
            "seed": "93cd2aa66f23a40e",
            "results": 1,
            "page": 1,
            "version": "1.3"
        }
    }
    """.data(using: .utf8)!

    func testUserTitleParse() throws {
        let response = try JSONDecoder().decode(UserResponse.self, from: testUserString)
        XCTAssert(response.results![0].name!.title! == "Miss")
    }
    
    func testUserFirstNameParse() throws {
        let response = try JSONDecoder().decode(UserResponse.self, from: testUserString)
        XCTAssert(response.results![0].name!.first! == "Isabella")
    }
    
    func testUserLastNameParse() throws {
        let response = try JSONDecoder().decode(UserResponse.self, from: testUserString)
        XCTAssert(response.results![0].name!.last! == "Johansen")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
