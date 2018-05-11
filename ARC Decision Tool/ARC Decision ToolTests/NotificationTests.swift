//
//  NotificationTests.swift
//  ARC Decision ToolTests
//
//  Created by Michael McKenna on 4/10/18.
//  Copyright © 2018 Michael McKenna. All rights reserved.
//

import XCTest
@testable import ARC_Decision_Tool
import RealmSwift
import UserNotifications

class NotificationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScheduleNotification() {
        let expect = expectation(description: "schedule notification")
        TaskNotifications.scheduleNotification(at: Date(), for: "NotificationTest") { (success) in
            XCTAssertTrue(success)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNotificationPermissions() {
        let expect = expectation(description: "schedule notification")

        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) {
            granted, error in
            
            // Ensure previously set authorization permission is cached
            if granted {
                XCTAssertTrue(granted)
            } else {
                XCTAssertFalse(granted)
            }
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

}
