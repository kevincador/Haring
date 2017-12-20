//
//  MarkdownParser.swift
//  Pods
//
//  Created by Ivan Bruel on 18/07/16.
//
//

import UIKit

open class MarkdownParser {

  // MARK: Element Arrays
  fileprivate var escapingElements: [MarkdownElement]
  fileprivate var defaultElements: [MarkdownElement]
  fileprivate var unescapingElements: [MarkdownElement]

  open var customElements: [MarkdownElement]

  // MARK: Basic Elements
  open let header: MarkdownHeader
  open let list: MarkdownList
  open let quote: MarkdownQuote
  open let link: MarkdownLink
  open let automaticLink: MarkdownAutomaticLink
  open let bold: MarkdownBold
  open let italic: MarkdownItalic
  open let code: MarkdownCode

  // MARK: Escaping Elements
  fileprivate var codeEscaping = MarkdownCodeEscaping()
  fileprivate var escaping = MarkdownEscaping()
  fileprivate var unescaping = MarkdownUnescaping()

  // MARK: Configuration
  /// Enables or disables detection of URLs even without Markdown format
  open var automaticLinkDetectionEnabled: Bool = true
  open let font: UIFont
  open let color: UIColor

  // MARK: Initializer
  public init(font: UIFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
              color: UIColor = UIColor.black,
              automaticLinkDetectionEnabled: Bool = true,
              customElements: [MarkdownElement] = []) {
    self.font = font
    self.color = color

    header = MarkdownHeader(font: font)
    list = MarkdownList(font: font)
    quote = MarkdownQuote(font: font)
    link = MarkdownLink(font: font)
    automaticLink = MarkdownAutomaticLink(font: font)
    bold = MarkdownBold(font: font)
    italic = MarkdownItalic(font: font)
    code = MarkdownCode(font: font)

    self.automaticLinkDetectionEnabled = automaticLinkDetectionEnabled
    self.escapingElements = [codeEscaping, escaping]
    self.defaultElements = [header, list, quote, link, automaticLink, bold, italic]
    self.unescapingElements = [code, unescaping]
    self.customElements = customElements
  }

  // MARK: Element Extensibility
  open func addCustomElement(_ element: MarkdownElement) {
    customElements.append(element)
  }

  open func removeCustomElement(_ element: MarkdownElement) {
    guard let index = customElements.index(where: { someElement -> Bool in
      return element === someElement
    }) else {
      return
    }
    customElements.remove(at: index)
  }

  // MARK: Parsing
  open func parse(_ markdown: String) -> NSAttributedString {
    return parse(NSAttributedString(string: markdown))
  }
    
    open func elements() -> [MarkdownElement] {
        var elements = [MarkdownElement]()
        elements.append(contentsOf: defaultElements)
        elements.append(contentsOf: customElements)
        return elements
    }

  open func parse(_ markdown: NSAttributedString) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(attributedString: markdown)
    attributedString.addAttribute(NSAttributedStringKey.font, value: font,
                                  range: NSRange(location: 0, length: attributedString.length))
    attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color,
                                  range: NSRange(location: 0, length: attributedString.length))
    let elements = escaping + self.elements() + unescapingElements
    elements.forEach { element in
      if automaticLinkDetectionEnabled || type(of: element) != MarkdownAutomaticLink.self {
        element.parse(attributedString)
      }
        }
        return attributedString
    }

}
