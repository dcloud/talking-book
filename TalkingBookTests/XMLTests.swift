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
        XCTAssertNotNil(rootChild!.parent)
    }
    
    func testXMLDocumentInit() {
        let root = XMLElement("root")
        let doc = XMLDocument(root, version: 1.0)
        
        XCTAssertNotNil(doc.root)
        XCTAssertEqual(root.name, "root")
    }
    
    func testXMLDocumentConvenienceInit() {
        let doc = XMLDocument("root", version: 1.0)
        
        XCTAssertNotNil(doc.root)
        XCTAssertEqual(doc.root.name, "root")
    }
    
    func testXMLToString() {
        let root = XMLElement("root", attributes: ["id": 1])
        let body = XMLElement("body", textContent: "Hello World!")
        root.addChild(body)
        let doc = XMLDocument(root, version: 1.0)
        
        for i in 1..<5 {
            let el = XMLElement("p", textContent: "\(i): All work and no play makes Daniel something something.")
            body.addChild(el)
        }
        
        XCTAssertGreaterThan(root.children.count, 0)
        XCTAssertEqual(doc.toString(), "<?xml version=\"1.0\"?><root id=\"1\"><body>Hello World!<p>1: All work and no play makes Daniel something something.</p><p>2: All work and no play makes Daniel something something.</p><p>3: All work and no play makes Daniel something something.</p><p>4: All work and no play makes Daniel something something.</p></body></root>")
    }
    
    func testXMLtoNSXMLDocument() {
        let root = XMLElement("root", attributes: ["id": 1])
        let body = XMLElement("body", textContent: "Hello World!")
        root.addChild(body)
        let doc = XMLDocument(root, version: 1.0)
        
        for i in 1..<5 {
            let el = XMLElement("p", textContent: "\(i): All work and no play makes Daniel something something.")
            body.addChild(el)
        }
        
        let xmlDocument: NSXMLDocument? = try? NSXMLDocument(XMLString: doc.toString(), options: Int(NSXMLDocumentContentKind.XMLKind.rawValue))
        
        XCTAssertNotNil(xmlDocument)
        
        if let xmlDocument = xmlDocument {
            do {
                try xmlDocument.validate()
            } catch {
                XCTFail()
            }
        }
    }

}


class SMILXMLTests: XCTestCase {
    let smilDTDv1 = "smil PUBLIC \"-//W3C//DTD SMIL 1.0//EN\" \"http://www.w3.org/TR/REC-smil/SMIL10.dtd\""
    var smilDTD: DTD?
    var smilDoc: XMLDocument?
    
    override func setUp() {
        super.setUp()
        self.smilDTD = DTD(self.smilDTDv1)
        self.smilDoc = XMLDocument("smil", version: 1.0, docType: smilDTDv1)
    }
    
    override func tearDown() {
        self.smilDoc = nil
        self.smilDTD = nil
        super.tearDown()
    }
    
    func testSMILDTD() {
        if let smilDoc = self.smilDoc, smilDTD = self.smilDTD {
            if let docDTD = smilDoc.dtd {
                XCTAssertEqual(docDTD.toString(), smilDTD.toString())
            } else {
                XCTFail("smilDoc.dtd was not properly initialized")
            }
            
        } else {
            XCTFail("smilDoc was not properly initialized!")
        }
    }
    
    func testSMILDocument() {
        let head = XMLElement("head")
        
        let metasByAttrs: [AttributeDictionary] = [
            ["name": "dc:format", "content": "Daisy 2.02"],
            ["name": "ncc:generator", "content": "XMLTests"],
            ["name": "dc:identifier", "content": "abcdef-123-abc"]
        ]
        
        for attrs:AttributeDictionary in metasByAttrs {
            let meta = XMLElement("meta", attributes: attrs, selfClosing: true)
            head.addChild(meta)
        }
        
        for child in head.children {
            XCTAssertEqual(child.name, "meta")
        }
        
        
        let body = XMLElement("body")
        let mainSeq = XMLElement("seq", attributes: ["dur": "1.3s"])
        body.addChild(mainSeq)
        
        XCTAssertEqual(body.children.count, 1)
        XCTAssertEqual(body.children[0].name, "seq")
        if let dur: String = body.children[0].attributes["dur"] as? String {
            XCTAssertEqual(dur, "1.3s")
        }
        
        if let smilDoc = self.smilDoc {
            smilDoc.addChild(head)
            smilDoc.addChild(body)
            
            XCTAssertNotEqual(smilDoc.toString(), "")
            

//            let xmlDocument: NSXMLDocument? = try? NSXMLDocument(XMLString: smilDoc.toString(), options: Int(NSXMLDocumentContentKind.XMLKind.rawValue))
            
//            XCTAssertNotNil(xmlDocument)
        }
        
    }
}
