/*
 * OpenWeather+.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT nOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND nONINFRINGEMENT. IN nO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, dAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER dEALINGS IN
 * THE SOFTWARE.
 */

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public extension OpenWeather {

    // d - day; n - night
    enum Icon: String {

        case d200 = "D200"
        case d201 = "D201"
        case d202 = "D202"
        case d210 = "D210"
        case d211 = "D211"
        case d212 = "D212"
        case d221 = "D221"
        case d230 = "D230"
        case d231 = "D231"
        case d232 = "D232"
        case d300 = "D300"
        case d301 = "D301"
        case d302 = "D302"
        case d310 = "D310"
        case d311 = "D311"
        case d312 = "D312"
        case d313 = "D313"
        case d314 = "D314"
        case d321 = "D321"
        case d500 = "D500"
        case d501 = "D501"
        case d502 = "D502"
        case d503 = "D503"
        case d504 = "D504"
        case d511 = "D511"
        case d520 = "D520"
        case d521 = "D521"
        case d522 = "D522"
        case d531 = "D531"
        case d600 = "D600"
        case d601 = "D601"
        case d602 = "D602"
        case d611 = "D611"
        case d612 = "D612"
        case d615 = "D615"
        case d616 = "D616"
        case d620 = "D620"
        case d621 = "D621"
        case d622 = "D622"
        case d701 = "D701"
        case d711 = "D711"
        case d721 = "D721"
        case d731 = "D731"
        case d741 = "D741"
        case d761 = "D761"
        case d762 = "D762"
        case d781 = "D781"
        case d800 = "D800"
        case d801 = "D801"
        case d802 = "D802"
        case d803 = "D803"
        case d804 = "D804"
        case d900 = "D900"
        case d902 = "D902"
        case d903 = "D903"
        case d904 = "D904"
        case d906 = "D906"
        case d957 = "D957"
        case n200 = "N200"
        case n201 = "N201"
        case n202 = "N202"
        case n210 = "N210"
        case n211 = "N211"
        case n212 = "N212"
        case n221 = "N221"
        case n230 = "N230"
        case n231 = "N231"
        case n232 = "N232"
        case n300 = "N300"
        case n301 = "N301"
        case n302 = "N302"
        case n310 = "N310"
        case n311 = "N311"
        case n312 = "N312"
        case n313 = "N313"
        case n314 = "N314"
        case n321 = "N321"
        case n500 = "N500"
        case n501 = "N501"
        case n502 = "N502"
        case n503 = "N503"
        case n504 = "N504"
        case n511 = "N511"
        case n520 = "N520"
        case n521 = "N521"
        case n522 = "N522"
        case n531 = "N531"
        case n600 = "N600"
        case n601 = "N601"
        case n602 = "N602"
        case n611 = "N611"
        case n612 = "N612"
        case n615 = "N615"
        case n616 = "N616"
        case n620 = "N620"
        case n621 = "N621"
        case n622 = "N622"
        case n701 = "N701"
        case n711 = "N711"
        case n721 = "N721"
        case n731 = "N731"
        case n741 = "N741"
        case n761 = "N761"
        case n762 = "N762"
        case n781 = "N781"
        case n800 = "N800"
        case n801 = "N801"
        case n802 = "N802"
        case n803 = "N803"
        case n804 = "N804"
        case n900 = "N900"
        case n902 = "N902"
        case n903 = "N903"
        case n904 = "N904"
        case n906 = "N906"
        case n957 = "N957"
    }
}

public extension OpenWeather.Icon {

    public init?(condition: Int, icon: String) {
        guard 100...999 ~= condition else { return nil}

        let initial = icon[icon.startIndex] == "n" ? "N" : "D"
        self.init(rawValue: initial + "\(condition)")
    }
}

extension OpenWeather.Icon: CustomStringConvertible {

    public var description: String {
        switch self {

        case .d200: return "\u{f010}"
        case .d201: return "\u{f010}"
        case .d202: return "\u{f010}"
        case .d210: return "\u{f005}"
        case .d211: return "\u{f005}"
        case .d212: return "\u{f005}"
        case .d221: return "\u{f005}"
        case .d230: return "\u{f010}"
        case .d231: return "\u{f010}"
        case .d232: return "\u{f010}"
        case .d300: return "\u{f00b}"
        case .d301: return "\u{f00b}"
        case .d302: return "\u{f008}"
        case .d310: return "\u{f008}"
        case .d311: return "\u{f008}"
        case .d312: return "\u{f008}"
        case .d313: return "\u{f008}"
        case .d314: return "\u{f008}"
        case .d321: return "\u{f00b}"
        case .d500: return "\u{f00b}"
        case .d501: return "\u{f008}"
        case .d502: return "\u{f008}"
        case .d503: return "\u{f008}"
        case .d504: return "\u{f008}"
        case .d511: return "\u{f006}"
        case .d520: return "\u{f009}"
        case .d521: return "\u{f009}"
        case .d522: return "\u{f009}"
        case .d531: return "\u{f00e}"
        case .d600: return "\u{f00a}"
        case .d601: return "\u{f0b2}"
        case .d602: return "\u{f00a}"
        case .d611: return "\u{f006}"
        case .d612: return "\u{f006}"
        case .d615: return "\u{f006}"
        case .d616: return "\u{f006}"
        case .d620: return "\u{f006}"
        case .d621: return "\u{f00a}"
        case .d622: return "\u{f00a}"
        case .d701: return "\u{f009}"
        case .d711: return "\u{f062}"
        case .d721: return "\u{f0b6}"
        case .d731: return "\u{f063}"
        case .d741: return "\u{f003}"
        case .d761: return "\u{f063}"
        case .d762: return "\u{f063}"
        case .d781: return "\u{f056}"
        case .d800: return "\u{f00d}"
        case .d801: return "\u{f000}"
        case .d802: return "\u{f000}"
        case .d803: return "\u{f000}"
        case .d804: return "\u{f00c}"
        case .d900: return "\u{f056}"
        case .d902: return "\u{f073}"
        case .d903: return "\u{f076}"
        case .d904: return "\u{f072}"
        case .d906: return "\u{f004}"
        case .d957: return "\u{f050}"
        case .n200: return "\u{f02d}"
        case .n201: return "\u{f02d}"
        case .n202: return "\u{f02d}"
        case .n210: return "\u{f025}"
        case .n211: return "\u{f025}"
        case .n212: return "\u{f025}"
        case .n221: return "\u{f025}"
        case .n230: return "\u{f02d}"
        case .n231: return "\u{f02d}"
        case .n232: return "\u{f02d}"
        case .n300: return "\u{f02b}"
        case .n301: return "\u{f02b}"
        case .n302: return "\u{f028}"
        case .n310: return "\u{f028}"
        case .n311: return "\u{f028}"
        case .n312: return "\u{f028}"
        case .n313: return "\u{f028}"
        case .n314: return "\u{f028}"
        case .n321: return "\u{f02b}"
        case .n500: return "\u{f02b}"
        case .n501: return "\u{f028}"
        case .n502: return "\u{f028}"
        case .n503: return "\u{f028}"
        case .n504: return "\u{f028}"
        case .n511: return "\u{f026}"
        case .n520: return "\u{f029}"
        case .n521: return "\u{f029}"
        case .n522: return "\u{f029}"
        case .n531: return "\u{f02c}"
        case .n600: return "\u{f02a}"
        case .n601: return "\u{f0b4}"
        case .n602: return "\u{f02a}"
        case .n611: return "\u{f026}"
        case .n612: return "\u{f026}"
        case .n615: return "\u{f026}"
        case .n616: return "\u{f026}"
        case .n620: return "\u{f026}"
        case .n621: return "\u{f02a}"
        case .n622: return "\u{f02a}"
        case .n701: return "\u{f029}"
        case .n711: return "\u{f062}"
        case .n721: return "\u{f0b6}"
        case .n731: return "\u{f063}"
        case .n741: return "\u{f04a}"
        case .n761: return "\u{f063}"
        case .n762: return "\u{f063}"
        case .n781: return "\u{f056}"
        case .n800: return "\u{f02e}"
        case .n801: return "\u{f022}"
        case .n802: return "\u{f022}"
        case .n803: return "\u{f022}"
        case .n804: return "\u{f086}"
        case .n900: return "\u{f056}"
        case .n902: return "\u{f073}"
        case .n903: return "\u{f076}"
        case .n904: return "\u{f072}"
        case .n906: return "\u{f024}"
        case .n957: return "\u{f050}"
        }
    }
}


public extension OpenWeather.Icon {

    func attributedString(withSize size: CGFloat) -> NSMutableAttributedString {
        let name = "Weather Icons", file = "OpenWeather"

        return NSMutableAttributedString(string: self.description).then {
            $0.add(font: .font(withName: name, size: size, fromFile: file))
        }
    }
}
