//: Playground - noun: a place where people can play

import Cocoa

/*
let dtdStr = "smil PUBLIC \"-//W3C//DTD SMIL 1.0//EN\" \"http://www.w3.org/TR/REC-smil/SMIL10.dtd\""


let dtdNode = NSXMLDTDNode(XMLString: dtdStr)

let doctypeString = "<!DOCTYPE \(dtdStr)>"
let dtdNode1 = NSXMLDTDNode(XMLString: doctypeString)

let dtdCopied = "<!DOCTYPE smil PUBLIC \"-//W3C//DTD SMIL 1.0//EN\" \"http://www.w3.org/TR/REC-smil/SMIL10.dtd\">"
let dtdNodeCopied = NSXMLDTDNode(XMLString: dtdCopied)

let xhtmlNode = try? NSXMLDTD(contentsOfURL: NSURL(string: "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd")!, options: NSXMLNodePreserveEntities)

print(xhtmlNode?.description)
*/

public extension String {
    func format(args: CVarArgType...) -> String {
        return NSString(format: self, arguments: getVaList(args)) as String
    }
}


print("%04.1f".format(1.3))