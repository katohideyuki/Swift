import UIKit

// 10-1 拡張の宣言

/**
 -----------------------------------------------------------------
 ■ システムの既存の方に対する拡張定義の例
 -----------------------------------------------------------------
 */
extension String {

    /// 文字全てが0x20 ~ 0x7eの間のASCII文字の場合、trueとなる
    var isHankaku: Bool {
        for ch in self.unicodeScalars {
            if !(0x20 ..< 0x7F ~= ch.value) { return false }
        }
        return true
    }

    static var zenSpaceDouble: Bool = true                          // 全角空白を2つの半角空白にする

    func toHankaku() -> String {
        var r = ""
        for ch in self.unicodeScalars {
            var v = ch.value                                        // 文字コードを取得
            switch v {
                    case 0xFF01 ..< 0xFF5F:                         // 全角文字
                        v -= 0xff01 - 0x21                          // ASCII文字にする
                        r.unicodeScalars.append(Unicode.Scalar(v)!) // ビューの変更
                case 0x3000:                                        // 全角の空白文字
                    r += String.zenSpaceDouble ? "　" : " "
                default:
                    r.unicodeScalars.append(ch)                     // ビューの変更
            }
        }
        return r
    }
}

// 検証
let orig = "Ａsuka \u{3000}2001年12月０４日"
print(orig.isHankaku)                   // false

print("2001-12-04".isHankaku)           // true
String.zenSpaceDouble = false
print(orig.toHankaku())                 // Asuka  2001年12月04日
print(Int("15498".toHankaku())! + 34)   // 15532

/**
 -----------------------------------------------------------------
 ■ 拡張定義とイニシャライザ
 -----------------------------------------------------------------
 */
public struct StringNoBlank {
    public let beforeStr: String                               // オリジナルの文字列
    public let strWithoutBlank: String?                     // 空白抜きの文字列
    public var hasBlank: Bool { strWithoutBlank != nil }    // 空白を含むか？

    /// イニシャライザ
    /// - Parameter string: 文字列
    public init(_ str: String) {
        // 引数の値をまずはそのままメンバ変数に代入
        self.beforeStr = str

        // 空白を取り除いた文字列を代入する
        let s = String(beforeStr.filter{ $0 != " "})
        // 元の文字列と空白抜きの文字列を比較して、文字数が異なれば、空白抜きの文字列を保持する
        self.strWithoutBlank = (s.count != beforeStr.count) ? s : nil;
    }

    /// 比較演算子
    /// - Parameters:
    ///   - lhs: 比較元の文字列
    ///   - rhs: 比較先の文字列
    /// - Returns:
    public static func ==(lhs:StringNoBlank, rhs:StringNoBlank) -> Bool {
        // オプショナルがnilだったら代わりの値を使用する
        let s1 = lhs.strWithoutBlank ?? lhs.beforeStr
        let s2 = rhs.strWithoutBlank ?? rhs.beforeStr
        return s1 == s2
    }
}


// 検証
let a = StringNoBlank("A = B * 10 + X")
print(a.hasBlank)       // true

let b = StringNoBlank("A=B*10+X")
print(b.hasBlank)       // false

print(a == b)           // true
