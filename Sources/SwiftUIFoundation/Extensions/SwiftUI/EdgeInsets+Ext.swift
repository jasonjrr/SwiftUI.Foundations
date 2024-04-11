//
//  EdgeInsets+Ext.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

extension EdgeInsets {
    public static var zero: EdgeInsets {
        EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
    }
    
    public static func constant(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: value, leading: value, bottom: value, trailing: value)
    }
}
