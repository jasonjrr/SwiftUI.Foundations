//
//  L10n.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

enum L10n {
    static var bundle: Bundle { SwiftUIDesignSystemResources.resourceBundle }
}

protocol Localized {}
extension Localized {
    static var tableName: String { "Localizable" }
}

// MARK: CountdownTimerView
extension L10n {
    enum CountdownTimerView {
        static var ready: String {
            NSLocalizedString("countdown.timer.view.ready", bundle: L10n.bundle, comment: "Comment")
        }
    }
}

// MARK: DateTextField
extension L10n {
    enum DateTextField {
        static var yearYYYY: String {
            NSLocalizedString("date.text.field.placeholder.year.yyyy", bundle: L10n.bundle, comment: "Comment")
        }
        static var monthMM: String {
            NSLocalizedString("date.text.field.placeholder.month.mm", bundle: L10n.bundle, comment: "Comment")
        }
        static var dayDD: String {
            NSLocalizedString("date.text.field.placeholder.day.dd", bundle: L10n.bundle, comment: "Comment")
        }
        static var year: String {
            NSLocalizedString("date.text.field.placeholder.year", bundle: L10n.bundle, comment: "Comment")
        }
        static var month: String {
            NSLocalizedString("date.text.field.placeholder.month", bundle: L10n.bundle, comment: "Comment")
        }
        static var day: String {
            NSLocalizedString("date.text.field.placeholder.day", bundle: L10n.bundle, comment: "Comment")
        }
        static var separator: String {
            NSLocalizedString("date.text.field.separator", bundle: L10n.bundle, comment: "Comment")
        }
        static var noDateAvailable: String {
            NSLocalizedString("date.text.field.no.date.available", bundle: L10n.bundle, comment: "Comment")
        }
        static var keyboardDone: String {
            NSLocalizedString("date.text.field.keyboard.done", bundle: L10n.bundle, comment: "Comment")
        }
    }
}

// MARK: SixDigitCodeView
extension L10n {
    enum SixDigitCodeView: Localized {
        static var keyboardDoneButtonText: Text {
            Text("six.digit.code.keyboard.done.button.text", tableName: tableName, bundle: L10n.bundle)
        }
    }
}

// MARK: TextValidationViewModel
extension L10n {
    enum TextValidationViewModel: Localized {}
}

// MARK: TextValidationViewModel.Criteria
extension L10n.TextValidationViewModel {
    enum Criteria {
        static var containsSpecialCharacter: String {
            NSLocalizedString("text.validation.view.model.criteria.contains.special.character", bundle: L10n.bundle, comment: "Comment")
        }
        
        static var containsNumericCharacter: String {
            NSLocalizedString("text.validation.view.model.criteria.contains.numeric.character", bundle: L10n.bundle, comment: "Comment")
        }
        
        static var containsLowercaseCharacter: String {
            NSLocalizedString("text.validation.view.model.criteria.contains.lowercase.character", bundle: L10n.bundle, comment: "Comment")
        }
        
        static var containsUppercaseCharacter: String {
            NSLocalizedString("text.validation.view.model.criteria.contains.uppercase.character", bundle: L10n.bundle, comment: "Comment")
        }
    }
}

// MARK: TextValidationViewModel.Criteria.NumberOfCharacters
extension L10n.TextValidationViewModel.Criteria {
    enum NumberOfCharacters {
        static func equals(_ value: Int) -> String {
            String(format: NSLocalizedString("text.validation.view.model.criteria.equals.%d", bundle: L10n.bundle, comment: "Comment"), value)
        }
        
        static func lessThan(_ value: Int) -> String {
            String(format: NSLocalizedString("text.validation.view.model.criteria.less.than.%d", bundle: L10n.bundle, comment: "Comment"), value)
        }
        
        static func lessThanOrEqualTo(_ value: Int) -> String {
            String(format: NSLocalizedString("text.validation.view.model.criteria.less.than.or.equals.%d", bundle: L10n.bundle, comment: "Comment"), value)
        }
        
        static func greaterThan(_ value: Int) -> String {
            String(format: NSLocalizedString("text.validation.view.model.criteria.greater.than.%d", bundle: L10n.bundle, comment: "Comment"), value)
        }
        
        static func greaterThanOrEqualTo(_ value: Int) -> String {
            String(format: NSLocalizedString("text.validation.view.model.criteria.greater.than.or.equals.%d", bundle: L10n.bundle, comment: "Comment"), value)
        }
    }
}

// MARK: TipPickerView
extension L10n {
    enum TipPickerView: Localized {
        static var currencySymbol: String {
            NSLocalizedString("tip.picker.view.curreny.symbol", bundle: L10n.bundle, comment: "Comment")
        }
        
        static var other: String {
            NSLocalizedString("tip.picker.view.other", bundle: L10n.bundle, comment: "Comment")
        }
    }
}
