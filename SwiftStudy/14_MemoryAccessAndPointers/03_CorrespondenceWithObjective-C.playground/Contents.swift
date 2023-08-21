import UIKit
import Foundation

// 14-3 Objective-Cとの対応付け

/**
 -----------------------------------------------------------------
 ■ 数値と数値オブジェクト
 Objective-Cでは、整数や実数、論理値などはオブジェクトではない。これらの値を
 コレクションに格納したり、他のオブジェクトと一緒に扱うにはNSNumberというクラス
 のインスタンスに値を格納して使う。。
 SwiftとObjective-Cの間で対応づけられた型は、`as!`または`as?`演算子で
 キャストできる。
 NSNumberには`intValue, boolValue, doubleValue, stringValue`などの
 プロパティが用意されていれ、プロパティ名の示す型に変換した値を取得できる。
 -----------------------------------------------------------------
 */
数値と数値オブジェクト: do {
    print("------------ 数値と数値オブジェクト ------------")

    var num: NSNumber = 10.25
    if let f = num as? Float { print(f) }         // 10.25      ※Float型にキャスト
    if let m = num as? Int   { print(m) }         // 表示されない ※Int型にキャスト
    print(num.intValue)                           // 10         ※int型に変換された値を取得
    print("str: " + num.stringValue)              // str: 10.25 ※string型に変換された値を取得
}

/**
 -----------------------------------------------------------------
 ■ Foundationフレームワークのクラス
 Foundationフレームワークには、Objective-Cのクラスとほぼ同様の機能を備えた
 Swift向けの値型の定義が用意されている。

 Objective-Cには、インスタンスの内容を変更できない不変なクラスと、変更できる
 可変なクラスの区別があり、`NSStringは不変なクラス、NSMutableStringは可変なクラス`

 -----------------------------------------------------------------
 */
Foundationをインポートすると利用可能になるString機能: do {
    var s: String = "Can you see the meaning inside yourself?"
    // 空白区切りで配列に格納
    print(s.components(separatedBy: " "))       // ["Can", "you", "see", "the", "meaning", "inside", "yourself?"]

    NSMutableStringは参照型のデータであることを確認: do {
        let dragon = NSMutableString(string: "ドラゴン\u{1F409}")
        let dd = dragon
        dd.append(" 子猫\u{1F408}")
        print(dragon)                           // ドラゴン🐉 子猫🐈
    }
}


