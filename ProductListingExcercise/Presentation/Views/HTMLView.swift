//
//  HTMLView.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 06/05/2024.
//

import SwiftUI

struct HTMLView: View {
  let htmlContent: String
  
  var body: some View {
    Text(prepareAttributedString())
      .disabled(true)
      .padding(Spacing.x2)
  }

  private func prepareAttributedString() -> AttributedString {
    if
      let attributedText = htmlContent.htmlAttributedString(),
      let attributedString = try? AttributedString(attributedText, including: \.swiftUI)
    {
        return attributedString
      }
    
    return AttributedString(htmlContent)
  }
}

#Preview {
  HTMLView(htmlContent: "<p><strong>RUN WITH IT</strong></p>\n<p><br data-mce-fragment=\"1\">Your run requires enduring comfort and support, so step out and hit the road in Speed. Made with zero-distractions and lightweight, ventilating fabrics that move with you, you can trust in Speed no matter how far you go.</p>\n<p> </p>\n<p><br data-mce-fragment=\"1\">- Full length legging<br data-mce-fragment=\"1\">- High-waisted<br data-mce-fragment=\"1\">- Compressive fit<br data-mce-fragment=\"1\">- Internal adjustable elastic/drawcord at front waistband<br data-mce-fragment=\"1\">- Pocket to back of waistband<br data-mce-fragment=\"1\">- Reflective Gymshark sharkhead logo to ankle<br data-mce-fragment=\"1\">- Main: 88% Polyester 12% Elastane. Internal Mesh: 76% Nylon 24% Elastane<br data-mce-fragment=\"1\">- We've cut down our use of swing tags, so this product comes without one<br data-mce-fragment=\"1\">- Model is <meta charset=\"utf-8\"><span data-usefontface=\"true\" data-contrast=\"none\" class=\"TextRun SCXP103297068 BCX0\" lang=\"EN-GB\" data-mce-fragment=\"1\" xml:lang=\"EN-GB\"><span class=\"NormalTextRun SCXP103297068 BCX0\" data-mce-fragment=\"1\">5'3\" and wears a size M</span></span><br>- SKU: B3A3E-BBBB</p>")
}

private extension String {
  func htmlAttributedString() -> NSAttributedString? {
    let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                font-family: -apple-system;
                font-size: 24px;
              }
              p:last-child {
                display: inline;
              }
            </style>
          </head>
          <body>
            \(self)
          </body>
        </html>
        """
    
    guard let data = htmlTemplate.data(using: .utf8) else {
      return nil
    }
    
    guard let attributedString = try? NSAttributedString(
      data: data,
      options: [.documentType: NSAttributedString.DocumentType.html],
      documentAttributes: nil
    ) else {
      return nil
    }
    
    return attributedString.trimmedAttributedString()
  }
}

private extension NSAttributedString {
  func trimmedAttributedString() -> NSAttributedString {
    let nonNewlines = CharacterSet.whitespacesAndNewlines.inverted
    let startRange = string.rangeOfCharacter(from: nonNewlines)
    let endRange = string.rangeOfCharacter(from: nonNewlines, options: .backwards)
    guard let startLocation = startRange?.lowerBound, let endLocation = endRange?.lowerBound else {
      return self
    }
    let range = NSRange(startLocation...endLocation, in: string)
    return attributedSubstring(from: range)
  }
}
