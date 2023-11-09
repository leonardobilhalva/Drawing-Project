//
//  Line.swift
//  Drawing Project
//
//  Created by Leonardo on 09/11/23.
//


import Foundation
import SwiftUI

struct Line: Identifiable {
    
    var points: [CGPoint]
    var color: Color
    var lineWidth: CGFloat

    let id = UUID()
}
