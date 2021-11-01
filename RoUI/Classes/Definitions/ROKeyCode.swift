//
//  KeyCode.swift
//  LamdaXJobController
//
//  Created by seco on 10.10.19.
//  Copyright © 2019 B. Roncaglioni. All rights reserved.
//

import Foundation
//swiftlint:disable identifier_name
//swiftlint:disable colon
public struct ROKeycode {
// Layout-independent Keys
    // eg.These key codes are always the same key on all layouts.
static public let returnKey                 : UInt16 = 0x24
static public let enter                     : UInt16 = 0x4C
static public let tab                       : UInt16 = 0x30
static public let space                     : UInt16 = 0x31
static public let delete                    : UInt16 = 0x33
static public let escape                    : UInt16 = 0x35
static public let command                   : UInt16 = 0x37
static public let shift                     : UInt16 = 0x38
static public let capsLock                  : UInt16 = 0x39
static public let option                    : UInt16 = 0x3A
static public let control                   : UInt16 = 0x3B
static public let rightShift                : UInt16 = 0x3C
static public let rightOption               : UInt16 = 0x3D
static public let rightControl              : UInt16 = 0x3E
static public let leftArrow                 : UInt16 = 0x7B
static public let rightArrow                : UInt16 = 0x7C
static public let downArrow                 : UInt16 = 0x7D
static public let upArrow                   : UInt16 = 0x7E
static public let volumeUp                  : UInt16 = 0x48
static public let volumeDown                : UInt16 = 0x49
static public let mute                      : UInt16 = 0x4A
static public let help                      : UInt16 = 0x72
static public let home                      : UInt16 = 0x73
static public let pageUp                    : UInt16 = 0x74
static public let forwardDelete             : UInt16 = 0x75
static public let end                       : UInt16 = 0x77
static public let pageDown                  : UInt16 = 0x79
static public let function                  : UInt16 = 0x3F
static public let f1                        : UInt16 = 0x7A
static public let f2                        : UInt16 = 0x78
static public let f4                        : UInt16 = 0x76
static public let f5                        : UInt16 = 0x60
static public let f6                        : UInt16 = 0x61
static public let f7                        : UInt16 = 0x62
static public let f3                        : UInt16 = 0x63
static public let f8                        : UInt16 = 0x64
static public let f9                        : UInt16 = 0x65
static public let f10                       : UInt16 = 0x6D
static public let f11                       : UInt16 = 0x67
static public let f12                       : UInt16 = 0x6F
static public let f13                       : UInt16 = 0x69
static public let f14                       : UInt16 = 0x6B
static public let f15                       : UInt16 = 0x71
static public let f16                       : UInt16 = 0x6A
static public let f17                       : UInt16 = 0x40
static public let f18                       : UInt16 = 0x4F
static public let f19                       : UInt16 = 0x50
static public let f20                       : UInt16 = 0x5A
// US-ANSI Keyboard Positions
    // eg. These key codes are for the physical key (in any keyboard layout)
    // at the location of the named key in the US-ANSI layout.
static public let a                         : UInt16 = 0x00
static public let b                         : UInt16 = 0x0B
static public let c                         : UInt16 = 0x08
static public let d                         : UInt16 = 0x02
static public let e                         : UInt16 = 0x0E
static public let f                         : UInt16 = 0x03
static public let g                         : UInt16 = 0x05
static public let h                         : UInt16 = 0x04
static public let i                         : UInt16 = 0x22
static public let j                         : UInt16 = 0x26
static public let k                         : UInt16 = 0x28
static public let l                         : UInt16 = 0x25
static public let m                         : UInt16 = 0x2E
static public let n                         : UInt16 = 0x2D
static public let o                         : UInt16 = 0x1F
static public let p                         : UInt16 = 0x23
static public let q                         : UInt16 = 0x0C
static public let r                         : UInt16 = 0x0F
static public let s                         : UInt16 = 0x01
static public let t                         : UInt16 = 0x11
static public let u                         : UInt16 = 0x20
static public let v                         : UInt16 = 0x09
static public let w                         : UInt16 = 0x0D
static public let x                         : UInt16 = 0x07
static public let y                         : UInt16 = 0x10
static public let z                         : UInt16 = 0x06
static public let zero                      : UInt16 = 0x1D
static public let one                       : UInt16 = 0x12
static public let two                       : UInt16 = 0x13
static public let three                     : UInt16 = 0x14
static public let four                      : UInt16 = 0x15
static public let five                      : UInt16 = 0x17
static public let six                       : UInt16 = 0x16
static public let seven                     : UInt16 = 0x1A
static public let eight                     : UInt16 = 0x1C
static public let nine                      : UInt16 = 0x19
static public let equals                    : UInt16 = 0x18
static public let minus                     : UInt16 = 0x1B
static public let semicolon                 : UInt16 = 0x29
static public let apostrophe                : UInt16 = 0x27
static public let comma                     : UInt16 = 0x2B
static public let period                    : UInt16 = 0x2F
static public let forwardSlash              : UInt16 = 0x2C
static public let backslash                 : UInt16 = 0x2A
static public let grave                     : UInt16 = 0x32
static public let leftBracket               : UInt16 = 0x21
static public let rightBracket              : UInt16 = 0x1E
static public let keypadDecimal             : UInt16 = 0x41
static public let keypadMultiply            : UInt16 = 0x43
static public let keypadPlus                : UInt16 = 0x45
static public let keypadClear               : UInt16 = 0x47
static public let keypadDivide              : UInt16 = 0x4B
static public let keypadEnter               : UInt16 = 0x4C
static public let keypadMinus               : UInt16 = 0x4E
static public let keypadEquals              : UInt16 = 0x51
static public let keypad0                   : UInt16 = 0x52
static public let keypad1                   : UInt16 = 0x53
static public let keypad2                   : UInt16 = 0x54
static public let keypad3                   : UInt16 = 0x55
static public let keypad4                   : UInt16 = 0x56
static public let keypad5                   : UInt16 = 0x57
static public let keypad6                   : UInt16 = 0x58
static public let keypad7                   : UInt16 = 0x59
static public let keypad8                   : UInt16 = 0x5B
static public let keypad9                   : UInt16 = 0x5C
}
//swiftlint:ensable identifier_name
