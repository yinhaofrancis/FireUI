//
//  FireUITests.swift
//  FireUITests
//
//  Created by hao yin on 2018/9/6.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import XCTest
@testable import FireUI

class FireUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let a = StackContainer(width: .volume(1000), height: .volume(1000))
        let it = StackContainer(width: .percent(0.1), height: .percent(0.1))
        it.direction = .horizontal
        it.grow = 1
        let itt = Item(width: .percent(0.6), height: .percent(0.6))
        itt.shrink = 1
        it.subItems = [itt,Item(width: .percent(0.7), height: .percent(0.7))]
        a.subItems = [it,Item(width: .percent(0.1), height: .percent(0.1)),Item(width: .volume(100), height: .volume(100))];
        a.layout()
        XCTAssertTrue(it.frame == CGRect(x: 0, y: 0, width: 1000, height: 800))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 0, y: 800, width: 1000, height: 100))
        XCTAssertTrue(a.subItems[2].frame == CGRect(x: 0, y: 900, width: 1000, height: 100))
        
        XCTAssertTrue(it.subItems[0].frame == CGRect(x: 0, y: 0, width: 300, height: 800))
        XCTAssertTrue(it.subItems[1].frame == CGRect(x: 300, y: 0, width: 700, height: 800))
        
    }
    func testDisplayStyle(){
        let a = StackContainer(width: .volume(1000), height: .volume(1000))
        a.subItems = [Item(width: .volume(200), height: .volume(200)),Item(width: .volume(100), height: .volume(100))]
        a.direction = .horizontal
        a.layout()
        XCTAssertTrue(a.subItems[0].frame == CGRect(x: 0, y: 0, width: 200, height: 1000))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 200, y: 0, width: 100, height: 1000))
        a.justContent = .center
        a.layout()
        XCTAssertTrue(a.subItems[0].frame == CGRect(x: 350, y: 0, width: 200, height: 1000))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 550, y: 0, width: 100, height: 1000))
        a.justContent = .end
        a.layout()
        XCTAssertTrue(a.subItems[0].frame == CGRect(x: 700, y: 0, width: 200, height: 1000))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 900, y: 0, width: 100, height: 1000))
        a.justContent = .between
        a.layout()
        XCTAssertTrue(a.subItems[0].frame == CGRect(x: 0, y: 0, width: 200, height: 1000))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 900, y: 0, width: 100, height: 1000))
        
        a.justContent = .around
        a.layout()
        XCTAssertTrue(a.subItems[0].frame == CGRect(x: 700.0 / 4.0, y: 0, width: 200, height: 1000))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 700.0 / 4.0 * 3.0 + 200, y: 0, width: 100, height: 1000))
        
        a.justContent = .evenly
        a.layout()
        XCTAssertTrue(a.subItems[0].frame == CGRect(x: 700.0 / 3.0, y: 0, width: 200, height: 1000))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 700.0 / 3.0 * 2.0 + 200, y: 0, width: 100, height: 1000))
    }
    func testAsign() {
        let a = StackContainer(width: .volume(1000), height: .volume(1000))
        a.subItems = [Item(width: .volume(200), height: .volume(200)),Item(width: .volume(100), height: .volume(100))]
        a.direction = .horizontal
        a.layout()
        XCTAssertTrue(a.subItems[0].frame == CGRect(x: 0, y: 0, width: 200, height: 1000))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 200, y: 0, width: 100, height: 1000))
        a.alignItem = .start
        a.layout()
        XCTAssertTrue(a.subItems[0].frame == CGRect(x: 0, y: 0, width: 200, height: 200))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 200, y:0, width: 100, height: 100))
        a.alignItem = .center
        a.layout()
        XCTAssertTrue(a.subItems[0].frame == CGRect(x: 0, y: 400, width: 200, height: 200))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 200, y:450, width: 100, height: 100))
        a.alignItem = .end
        a.layout()
        XCTAssertTrue(a.subItems[0].frame == CGRect(x: 0, y: 800, width: 200, height: 200))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 200, y:900, width: 100, height: 100))
        
    }
    func testAsignV(){
        let a = StackContainer(width: .volume(1000), height: .volume(1000))
        a.subItems = [Item(width: .volume(200), height: .volume(200)),Item(width: .volume(100), height: .volume(100))]
        a.direction = .vertical
        a.layout()
        XCTAssertTrue(a.subItems[0].frame == CGRect(x: 0, y: 0, width: 1000, height: 200))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 0, y: 200, width: 1000, height: 100))
        a.alignItem = .start
        a.layout()
        XCTAssertTrue(a.subItems[0].frame == CGRect(x: 0, y: 0, width: 200, height: 200))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 0, y: 200, width: 100, height: 100))
        a.alignItem = .center
        a.layout()
        XCTAssertTrue(a.subItems[0].frame == CGRect(x: 400, y: 0, width: 200, height: 200))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 450, y: 200, width: 100, height: 100))
        a.alignItem = .end
        a.layout()
        XCTAssertTrue(a.subItems[0].frame == CGRect(x: 800, y: 0, width: 200, height: 200))
        XCTAssertTrue(a.subItems[1].frame == CGRect(x: 900, y:200, width: 100, height: 100))
    }
}
