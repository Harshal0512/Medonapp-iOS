//
//  LinksLabel.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/11/22.
//

import Foundation
import UIKit


// Base class for showing and handling taps on links within the text.
// Any custom label class can inherit it to adopt link detection and tapping capabilities.
class LinksLabel: UILabel {
    
    private var items: [LinksLabelDataItem] = []
    private var recognizer: UITapGestureRecognizer?
    var delegate: LinksLabelProtocol?
    
        
    func setAttribute(link: String, range: NSRange) {
        let item = LinksLabelDataItem(link: link, range: range)
        items.append(item)
    }
    
    var textValue: String? {
        willSet(newValue) {
            if let str = newValue {
                if(items.count == 0) {
                    detectLinks(str)
                }
                if(items.count > 0) {
                    isTappable = true
                    let attrText = NSMutableAttributedString(string: str)
                    for(_, item) in items.enumerated() {
                        attrText.addAttribute(.link, value: item.link, range: item.range)
                    }
                    attributedText = attrText
                }
                else {
                    isTappable = false
                    text = str
                }
            }
        }
    }
    
    var isTappable: Bool = false {
        willSet(newValue) {
            if(newValue) {
                recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                addGestureRecognizer(recognizer!)
                lineBreakMode = .byWordWrapping
                isUserInteractionEnabled = true
            }
            else if(recognizer != nil) {
                removeGestureRecognizer(recognizer!)
                isUserInteractionEnabled = false
                recognizer = nil
            }
        }
    }
    
    @objc func handleTap(_ rec: UIGestureRecognizer) {
        guard let tapRec = rec as? UITapGestureRecognizer else { return }
        for(_, item) in items.enumerated() {
            if(tapRec.didTapAttributedTextInLabel(label: self, inRange: item.range)) {
                if let delegate = delegate {
                    delegate.didTapLinksLabel(targetLink: item.link, source: self)
                }
                else {
                    Utils.openURL(item.link)
                }
                return
            }
        }
        delegate?.didTapLinksLabel(targetLink: nil, source: self)
    }
    
    private func detectLinks(_ str: String) {
        let array = str.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        for(_, token) in array.enumerated() {
            if(token.isUrl()) {
                let loc = str.indexOf(token)
                if(loc >= 0) {
                    setAttribute(link: token, range: NSRange(location: loc, length: token.count))
                }
            }
        }
    }
    
    
    class LinksLabelDataItem {
        var range: NSRange
        var link: String = ""
        
        init(link: String, range: NSRange) {
            self.link = link
            self.range = range
        }
    }

}

protocol LinksLabelProtocol {
    func didTapLinksLabel(targetLink: String?, source: LinksLabel)
}
