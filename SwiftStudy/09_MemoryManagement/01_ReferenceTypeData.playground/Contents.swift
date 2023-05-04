import UIKit

// 9-1 参照型データとARC

/**
 -----------------------------------------------------------------
 ■ リファレンスカウンタの概念
 どこからも参照されなくなったインスタンスを解放する。Javaで言うところガベージ
 コレクション的なこと。
 -----------------------------------------------------------------
 */
シンプルなクラス定義の例: do {
    class Person: CustomStringConvertible {
        let name: String    // 名前
        var age: Int        // 年齢

        // イニシャライザ
        /// Personインスタンスを生成
        /// - Parameters:
        ///   - name: 名前
        ///   - age: 年齢
        init(name: String, age: Int) {
            self.name = name; self.age = age
        }

        var description: String {
            return "名前 : \(name), 年齢 : \(age)"
        }

        // インスタンスが解放される直前に呼び出される
        deinit {
            print("\(name): deinit")
        }
    }

    // 検証
    var yuta: Person! = Person(name: "ゆうた", age: 16)
    print(yuta!)            // 名前 : ゆうた, 年齢 : 16

    var x: Person! = yuta
    x.age += 1
    print(yuta!)            // 名前 : ゆうた, 年齢 : 17
    print(yuta === x)       // true

    // nilを代入してyutaインスタンスの参照しない
    yuta = nil
    x = nil                 // ゆうた: deinit
}

/**
 -----------------------------------------------------------------
 ARCによるメモリ管理
 参照されなくなったタイミングで、参照カウンタ(リファレンスカウンタ)の値を増減して
 ゼロになったらメモリから自動削除する。このメモリ管理方式をARCと呼ぶらしい。。
 -----------------------------------------------------------------
 */
ARCによるメモリ管理: do {
    class Person: CustomStringConvertible {
        let name: String    // 名前
        var age: Int        // 年齢

        // イニシャライザ
        /// Personインスタンスを生成
        /// - Parameters:
        ///   - name: 名前
        ///   - age: 年齢
        init(name: String, age: Int) {
            self.name = name; self.age = age
        }

        var description: String {
            return "名前 : \(name), 年齢 : \(age)"
        }

        // インスタンスが解放される直前に呼び出される
        deinit {
            print("\(name): deinit")
        }

        /// 文字列をキー、Personインスタンスを値とする辞書型のデータを
        /// 配列に格納する。
        /// - Parameter entry: 文字列をキー、Personインスタンスを値とする辞書
        static func temp(_ entry: [String: Person]) {
            var list = [[String:Person]]()
            list.append(entry)
            print("\(list.count)個のエントリー")
        }
    }

    // 検証
    Person.temp(["ほげ": Person(name: "たろう", age: 16)])       // たろう: deinit
}
