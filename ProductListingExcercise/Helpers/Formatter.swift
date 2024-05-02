//
//  Formatter.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 30/04/2024.
//

import Foundation

struct Formatter {
  static func currencyFormatter() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    formatter.locale = Locale(identifier: "en_GB")
    formatter.currencyCode = "£"
    return formatter
  }
}
