//
//  XML.swift
//  TalkingBook
//
//  Created by Daniel Cloud on 9/12/15.
//  Copyright © 2015 Daniel Cloud. All rights reserved.
//

import Foundation

public extension String {
    func format(args: CVarArgType...) -> String {
        return NSString(format: self, arguments: getVaList(args)) as String
    }
}

protocol DOMStringSerializable {
    func toString() -> String
}

public typealias AttributeDictionary = [String: Any]

public class XMLElement: DOMStringSerializable, CustomStringConvertible {
    public let name: String
    public private(set) weak var parent: XMLElement?
    public var children: [XMLElement] = [XMLElement]()
    public var attributes: AttributeDictionary
    public var textContent: String?
    var isSelfClosing: Bool = false
    
    public var attributeString: String {
        get {
            var attrString = self.attributes.map { (key: String, value: Any) in
                return value is CustomStringConvertible ? "\(key)=\"\(value)\"" : ""
            }
            .filter { (v: String) -> Bool in
                v.isEmpty == false
            }
            .joinWithSeparator(" ")
            
            if attrString.isEmpty == false {
                attrString = " " + attrString
            }
            return attrString
        }
    }
    
    
    public init(_ name: String, attributes: AttributeDictionary, textContent: String?) {
        self.name = name
        self.attributes = attributes
        self.textContent = textContent
    }
    
    public convenience init(_ name: String) {
        self.init(name, attributes: AttributeDictionary(), textContent: nil)
    }
    
    public convenience init(_ name: String, selfClosing: Bool) {
        self.init(name, attributes: AttributeDictionary(), textContent: nil)
        self.isSelfClosing = true
    }
    
    public convenience init(_ name: String, attributes: AttributeDictionary) {
        self.init(name, attributes: attributes, textContent: nil)
    }
    
    public convenience init(_ name: String, attributes: AttributeDictionary, selfClosing: Bool) {
        self.init(name, attributes: attributes, textContent: nil)
        self.isSelfClosing = true
    }
    
    public convenience init(_ name: String, textContent: String) {
        self.init(name, attributes: AttributeDictionary(), textContent: textContent)
    }
    
    public func addChild(element: XMLElement) -> XMLElement? {
        if self.isSelfClosing == false {
            element.parent = self
            children.append(element)
            return element
        }
        return nil
    }
    
    public func toString() -> String {
        let openTagEnd:String = isSelfClosing ? " /" : ""
        var content: [String] = ["<\(name)\(attributeString)\(openTagEnd)>"]
        
        if isSelfClosing == false {
            if let textContent = textContent {
                content.append(textContent)
            }
            
            for child in children {
                content.append(child.toString())
            }
            
            content.append("</\(name)>")
        }
        return content.joinWithSeparator("")
    }
    
    public var description: String {
        get {
            return toString()
        }
    }
}


public class DTD: DOMStringSerializable, CustomStringConvertible {
    let docTypeString: String
    
    public init(_ docTypeString: String) {
        self.docTypeString = docTypeString
    }
    
    public func toString() -> String {
        return "<!DOCTYPE \(self.docTypeString)>"
    }
    
    public var description: String {
        get {
            return toString()
        }
    }
}

public class XMLDocument: DOMStringSerializable, CustomStringConvertible {
    public let version: Float
    public let dtd: DTD?
    
    public var root: XMLElement
    
    public init(_ root: XMLElement, version: Float, dtd:DTD? = nil) {
        self.root = root
        self.version = version
        self.dtd = dtd
    }
    
    public convenience init(_ rootName: String, version: Float, docType:String) {
        self.init(XMLElement(rootName), version: version, dtd: DTD(docType))
    }
    
    public convenience init(_ rootName: String, version: Float) {
        self.init(XMLElement(rootName), version: version, dtd: nil)
    }
    
    public var description: String {
        get {
            return toString()
        }
    }
    
    public func toString() -> String {
        var xmlString =  "<?xml version=\"\(version)\"?>"
        if let dtd = self.dtd {
            xmlString += dtd.toString()
        }
        xmlString += root.toString()

        return xmlString
    }
    
    public func addChild(element: XMLElement) {
        self.root.addChild(element)
    }
}
