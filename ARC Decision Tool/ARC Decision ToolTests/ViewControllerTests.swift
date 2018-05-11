//
//  ViewControllerTests.swift
//  ARC Decision ToolTests
//
//  Created by Michael McKenna on 4/10/18.
//  Copyright © 2018 Michael McKenna. All rights reserved.
//

import XCTest
@testable import ARC_Decision_Tool
import RealmSwift

class ViewControllerTests: XCTestCase {
    
    var viewControllerUnderTest: ViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
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
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:cellForRowAt:))))
    }
    
    func testCollectionViewConformsToDataSourceProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UICollectionViewDataSource.self))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.collectionView(_:numberOfItemsInSection:))))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.collectionView(_:cellForItemAt:))))
    }
    
    func testTimelinesDisplayed() {
        XCTAssertEqual(viewControllerUnderTest.collectionView.numberOfItems(inSection: 0), viewControllerUnderTest.cellIdentifiers.count)
    }
    
    func testTimelineCalculated() {
        let task = Task()
        task.id = UUID().uuidString
        task.timeline = "120"
        
        let hurricane = Hurricane()
        hurricane.landfall = Date().advanceBy(10)
    
        let realm = try! Realm()
        try! realm.write {
            realm.add(task, update: true)
            realm.add(hurricane, update: true)
        }
        
        RealmHelper.setStaticTaskDates()
        
        XCTAssertNotEqual(Date(), task.completionDate)
    }
    
}
