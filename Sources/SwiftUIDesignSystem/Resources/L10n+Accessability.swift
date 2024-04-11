//
//  L10n+Accessability.swift
//  
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

extension L10n {
    enum Accessibility {}
}

// MARK: Buttons
extension L10n.Accessibility {
    enum Buttons: Localized {
        static var buttonGroup: Text {
            Text("accessibility.button.group", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var radioButtonGroup: Text {
            Text("accessibility.button.radio.button.group", tableName: tableName, bundle: L10n.bundle)
        }
    }
}

// MARK: ChecklistView
extension L10n.Accessibility {
    enum ChecklistView: Localized {
        static var label: Text {
            Text("accessibility.checklist.view.label", tableName: tableName, bundle: L10n.bundle)
        }
    }
}

// MARK: ListItems
extension L10n.Accessibility {
    enum ListItems: Localized {
        static var titlePrefix: Text {
            Text("accessibility.list.item.title.prefix", tableName: tableName, bundle: L10n.bundle)
        }

        static var subtitlePrefix: Text {
            Text("accessibility.list.item.subtitle.prefix", tableName: tableName, bundle: L10n.bundle)
        }
    }
}

// MARK: StepperView
extension L10n.Accessibility {
    enum StepperView: Localized {
        static var elementName: Text {
            Text("accessibility.stepper.view.element.name", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var complete: Text {
            Text("accessibility.stepper.view.complete", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var incomplete: Text {
            Text("accessibility.stepper.view.incomplete", tableName: tableName, bundle: L10n.bundle)
        }
    }
}

// MARK: Text Fields
extension L10n.Accessibility {
    enum UsernameAndPasswordView: Localized {
        static func nextEnterPassword(passwordFieldLabel: String) -> Text {
            Text("accessibility.username.and.password.view.next.enter.password.\(passwordFieldLabel)", tableName: tableName, bundle: L10n.bundle)
        }
        
        static func nextEnterPasswordHint(passwordFieldLabel: String) -> Text {
            Text("accessibility.username.and.password.view.next.enter.password.hint.\(passwordFieldLabel)", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var passwordValueNotReadAloud: Text {
            Text("accessibility.username.and.password.view.password.value.not.read", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var passwordTextVisible: Text {
            Text("accessibility.username.and.password.view.password.text.visible", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var passwordTextHidden: Text {
            Text("accessibility.username.and.password.view.password.text.hidden", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var showPasswordTextToggleHint: Text {
            Text("accessibility.username.and.password.view.show.password.text.toggle.hint", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var submit: Text {
            Text("accessibility.username.and.password.view.submit", tableName: tableName, bundle: L10n.bundle)
        }
    }
}

// MARK: Validation
extension L10n.Accessibility {
    enum Validation: Localized {
        static var stateValid: Text {
            Text("accessibility.text.validation.view.valid", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var stateInvalid: Text {
            Text("accessibility.text.validation.view.invalid", tableName: tableName, bundle: L10n.bundle)
        }
    }
}

// MARK: Info Alert View
extension L10n.Accessibility {
    enum InfoAlertView: Localized {
        static var success: Text {
            Text("accessibility.info.alert.view.success", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var info: Text {
            Text("accessibility.info.alert.view.info", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var warning: Text {
            Text("accessibility.info.alert.view.warning", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var error: Text {
            Text("accessibility.info.alert.view.error", tableName: tableName, bundle: L10n.bundle)
        }
    }
}

// MARK: Multiselect View
extension L10n.Accessibility {
    enum MultiselectView: Localized {
        static var selected: Text {
            Text("accessibility.multiselect.view.selected", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var unselected: Text {
            Text("accessibility.multiselect.view.unselected", tableName: tableName, bundle: L10n.bundle)
        }
    }
}

// MARK: Rating View
extension L10n.Accessibility {
    enum RatingView: Localized {
        static var label: Text {
            Text("accessibility.rating.view.label", tableName: tableName, bundle: L10n.bundle)
        }
        
        static func rating(value: Int) -> Text {
            Text("accessibility.rating.view.value.\(value)", tableName: tableName, bundle: L10n.bundle)
        }
    }
}

// MARK: Sign in with Pin View
extension L10n.Accessibility {
    enum SignInWithPinView: Localized {
        static var code: Text {
            Text("accessibility.sign.in.with.pin.view.code.label", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var codeRedacted: Text {
            Text("accessibility.sign.in.with.pin.view.code.redacted", tableName: tableName, bundle: L10n.bundle)
        }
        
        static func labelForNumber(_ number: Int) -> Text {
            Text("accessibility.sign.in.with.pin.view.button.number.\(number)", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var deleteLastNumber: Text {
            Text("accessibility.sign.in.with.pin.view.button.delete.last.number", tableName: tableName, bundle: L10n.bundle)
        }
    }
}
