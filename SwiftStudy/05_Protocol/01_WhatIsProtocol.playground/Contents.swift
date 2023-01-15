import UIKit

// プロトコルとは

/**
 -----------------------------------------------------------------------
 ■ プロトコルを採用した定義例
 プロトコルを使ってクラスや構造体、列挙型を定義することを`プロトコルを採用(adopt)する`
 という。なお、プロトコルはjavaで言うインタフェースに近いものだと思って良さそう。例とし
 て`CustomStringConvertibleプロトコル`を採用したデータ型のインスタンスをprint関数
 の引数に渡すと、descriptionの返り値を表示する。toStringみたいなモン。
 -----------------------------------------------------------------------
 */
プロトコルCunstomStringConvertibleを採用した構造体: do {
    // プロトコルを採用した構造体
    struct Message: CustomStringConvertible {
        var msg: String

        /// 文字列を結合する
        /// - Parameter str: 結合したい文字列
        /// - Returns: 新しいMessageインスタンス
        func combineStr(str: String) -> Message {
            var m = self.msg + str          // 文字列を結合
            return Message(msg: m)          // 新しいMessageインスタンスを返却
        }

        // CustomStringConvertibleプロトコルが持っている関数を実現
        // print関数の引数にMessageインスタンスを渡すと、内部でdescriptionが呼び出される
        var description: String {
            return "print関数を呼び出したら「\(msg)」が出力されるよ。"

        }
    }

    // プロトコルを何も採用していない構造体
    struct Normal { var msg: String }

    // 検証
    // CustomStringConvertibleプロトコルを採用してるインスタンス
    let a = Message(msg: "やっほー")         // イニシャライザ
    print(a)                               // print関数を呼び出したら「やっほー」が出力されるよ。
    let b = a.combineStr(str: "さよなら")
    print(b)                               // print関数を呼び出したら「やっほーさよなら」が出力されるよ。

    // CustomStringConvertibleプロトコルを採用していないインスタンス
    let c = Normal(msg: "眠たいね")
    print(c)                               // Normal(msg: "眠たいね")
}

