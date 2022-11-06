//
//  FilterRange.swift
//  Photoed
//
//  Created by Beniamin on 29.10.22.
//

import Foundation

//min values source: https://cifilter.io/CIColorControls/
struct FilterRange {
    public static let saturationRange: ClosedRange<Double> = 0...2
    public static let contrastRange: ClosedRange<Double> = 0...2
    public static let brightnessRange: ClosedRange<Double> = -1...1
}
