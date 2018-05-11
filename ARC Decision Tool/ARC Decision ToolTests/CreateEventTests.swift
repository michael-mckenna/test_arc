//
//  CreateEventTests.swift
//  ARC Decision ToolTests
//
//  Created by Michael McKenna on 4/10/18.
//  Copyright © 2018 Michael McKenna. All rights reserved.
//

import XCTest
@testable import ARC_Decision_Tool
import RealmSwift

class CreateEventTests: XCTestCase {
    
    var viewControllerUnderTest: CreateEventTableViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "CreateEvent") as! CreateEventTableViewController
        
        self.viewControllerUnderTest.loadView()
        self.viewControllerUnderTest.viewDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHasATableView() {
        XCTAssertNotNil(viewControllerUnderTest.tableView)
    }
    
    func testTableViewHasDelegate() {
        XCTAssertNotNil(viewControllerUnderTest.tableView.delegate)
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDelegate.self))
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(viewControllerUnderTest.tableView.dataSource)
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.numberOfSections(in:))))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:cellForRowAt:))))
    }
    
    func testTableViewCellHasProperNumberOfStaticCells() {
        XCTAssertEqual(viewControllerUnderTest.tableView.numberOfRows(inSection: 0), 12)
    }
    
    func testRespondsToCreateFunction() {
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.createEvent(_:))))
    }
    
    func testCreateHurricane() {
        viewControllerUnderTest.createEvent(UIButton())
        
        let realm = try! Realm()
        XCTAssertGreaterThan(realm.objects(Hurricane.self).count, 0)
    }
    
    func testUpdateHurricane() {
        let realm = try! Realm()
        let hurricane = Hurricane()
        hurricane.id = UUID().uuidString
        try! realm.write {
            realm.add(hurricane, update: true)
        }
        
        let hurricaneCountBefore = realm.objects(Hurricane.self).count
        
        viewControllerUnderTest.hurricane = hurricane
        viewControllerUnderTest.createEvent(UIButton())
        
        let hurricaneCountAfter = realm.objects(Hurricane.self).count
        
        XCTAssertEqual(hurricaneCountBefore, hurricaneCountAfter)
    }
    
    func testReset() {
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.endTrackingTapped(_:))))
        let realm = try! Realm()
        
        // delete task objects in local relam
        try! realm.write {
            realm.delete(realm.objects(Task.self))
            realm.delete(realm.objects(Hurricane.self))
        }
        
        XCTAssertEqual(realm.objects(Task.self).count, 0)
        XCTAssertEqual(realm.objects(Hurricane.self).count, 0)
    }
    
}
