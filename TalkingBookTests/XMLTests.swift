//
//  XMLTests.swift
//  TalkingBook
//
//  Created by Daniel Cloud on 9/12/15.
//  Copyright © 2015 Daniel Cloud. All rights reserved.
//

import XCTest
import TalkingBook

class XMLTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testXMLAttributes() {
        // Test XMLElement attributes
        let doc = XMLElement("root", attributes: ["id": 1, "name": "foo"])
        
        XCTAssertTrue(doc.attributeString.containsString("name=\"foo\""))
        XCTAssertFalse(doc.attributeString.containsString("name=foo"))

        XCTAssertTrue(doc.attributeString.containsString("id=\"1\""))
        XCTAssertFalse(doc.attributeString.containsString("id=1"))
    }

    func testXMLParent() {
        let root = XMLElement("root")
        let body = XMLElement("body")
        
        let rootChild = root.addChild(body)
        
        XCTAssertGreaterThan(root.children.count, 0)
        XCTAssertNotNil(body.parent)
        XCTAssertNotNil(rootChild)
        XCTAssertNotNil(rootChild.parent)
    }
    
    func testXMLToString() {
        let root = XMLElement("root", attributes: ["id": 1])
        let body = XMLElement("body", textContent: "Hello World!")
        root.addChild(body)
        
        for i in 1..<5 {
            let el = XMLElement("p", textContent: "\(i): All work and no play makes Daniel something something.")
            body.addChild(el)
        }
        
        XCTAssertGreaterThan(root.children.count, 0)
        XCTAssertEqual(root.toString(), "<root id=\"1\"><body>Hello World!<p>1: All work and no play makes Daniel something something.</p><p>2: All work and no play makes Daniel something something.</p><p>3: All work and no play makes Daniel something something.</p><p>4: All work and no play makes Daniel something something.</p></body></root>")
    }

}
