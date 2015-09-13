//
//  XML.swift
//  TalkingBook
//
//  Created by Daniel Cloud on 9/12/15.
//  Copyright © 2015 Daniel Cloud. All rights reserved.
//

import Foundation

public typealias AttributeDictionary = [String: CustomStringConvertible]

public class XMLElement: NSObject {
    let name: String
    public private(set) weak var parent: XMLElement?
    public var children: [XMLElement] = [XMLElement]()
    public var attributes: AttributeDictionary = [:]
    public var textContent: String?
    
    public var attributeString: String {
        get {
            var attrString = self.attributes.map({ (key: String, value: CustomStringConvertible) in
                return "\(key)=\"\(value)\""
            }).joinWithSeparator(" ")
            if attrString.isEmpty == false {
                attrString = " " + attrString
            }
            return attrString
        }
    }
    
    public init(_ name: String) {
        self.name = name
    }
    
    public init(_ name: String, attributes: AttributeDictionary) {
        self.name = name
        self.attributes = attributes
    }
    
    public init(_ name: String, textContent: String) {
        self.name = name
        self.textContent = textContent
    }
    
    public func addChild(element: XMLElement) -> XMLElement {
        element.parent = self
        children.append(element)
        return element
    }
    
    public func toString() -> String {
        var content: [String] = ["<\(name)\(attributeString)>"]
        
        if let textContent = textContent {
            content.append(textContent)
        }
        
        for child in children {
            content.append(child.toString())
        }
        
        content.append("</\(name)>")
        return content.joinWithSeparator("")
    }
    
}
