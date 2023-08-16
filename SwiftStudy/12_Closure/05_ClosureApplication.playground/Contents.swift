import UIKit

// 12-5 クロージャの応用

/**
 -----------------------------------------------------------------
 ■ @autoclosureについて
 関数の引数が`@autoclosure`で修飾されていると、すぐには評価されず、クロージャ
 として関数に渡される。このように自動的に作られるクロージャをオートクロージャと呼ぶ。
 -----------------------------------------------------------------
 */
_autoclosureについて: do {
    print("------------ @autoclosureについて ------------")

    /// 受け取った値を出力して、そのまま返す
    /// - Parameter num: 引数
    func highCost(_ v: Int) -> Int { print("Cost: \(v)"); return v }
    
    通常の場合: do {
        print("------------ 通常の場合 ------------")
        /// 何かしらの条件が成立した場合に処理をスキップする関数
        /// 条件がfalseの場合、第二引数が評価されるも結局使われないため無駄な処理をすることになる。
        /// - Parameters:
        ///   - cond: 何かしらの判定結果
        ///   - arg: 何かしらの処理結果
        func skip(_ cond: Bool, _ arg: Int) {
            print("判定結果 : \(cond)")
            if cond { print("value = \(arg)") }
        }

        // ■ 検証
        skip(false, highCost(100))
    } /**
       Cost: 100        ← 関数skipの処理が実行される前に第二引数に渡した関数が先に評価されている
       判定結果 : false
       */

    _autoclosureを使った場合: do {
        print("------------ @autoclosureを使った場合 ------------")

        /// 何かしらの条件が成立した場合に処理をスキップする関数
        /// 条件がfalseの場合、第二引数が評価されず実行されない。
        /// - Parameters:
        ///   - cond: 何かしらの判定結果
        ///   - arg: 引数のないクロージャ
        func skip(_ cond: Bool, _ arg: @autoclosure () -> Int) {
            print("判定結果 : \(cond)")
            if cond { print("value = \(arg())") }
        }

        // ■ 検証
        skip(false, highCost(100))
    } /**
       判定結果 : false
                                ← 関数skipが実行され、条件に満たしていないため第二引数は評価されていない。
       */
}

/**
 -----------------------------------------------------------------
 ■ 短絡評価をする演算子
 演算子の中には、引数が演算結果に関係しない場合、その引数は評価を省略されるものが
 ある。
 -----------------------------------------------------------------
 */
// 短絡評価を行う演算子
infix operator △: LogicalDisjunctionPrecedence      // 演算子 || と同じ
func △(lhs: Bool, rhs: @autoclosure () -> Bool) -> Bool {
    if lhs { return false }     // 第1引数が真なら、第2引数は評価しなくてもよい
    return !rhs()               // 第2引数が偽なら、結果は第2引数の否定
}

// 短絡評価を行う演算子の定義例(再通報関数)
func △(lhs: Bool, rhs: @autoclosure () throws -> Bool) rethrows -> Bool {
    return lhs ? false : !(try rhs())
}

/**
 -----------------------------------------------------------------
 ■ 既定値が指定できる添字付け定義
 通常の添字付け定義に加え、既定値として利用するための引数を追加した定義を
 オーバーロードすることで可能となる。通常は既定値を使う可能性が低いことが多いので、
 既定値をオートクロージャで指定することで無駄な評価を減らす。
 -----------------------------------------------------------------
 */
添字付けの定義で既定値を指定する: do {
    print("------------ 添字付けの定義で既定値を指定する ------------")

    struct Friends {
        let names: [String]
        subscript(idx: Int) -> String { return names[idx] }
        subscript(idx: Int, default def: String) -> String {
            // idxが0からnamesの要素数より小さい数字であれば、その数字番目に格納されている要素を返却,
            // そうじゃなければ デフォルト値 defを返却する
            guard 0 ..< names.count ~= idx else { return def }
            return self[idx]
        }
    }

    // 検証
    let fri = Friends(names: ["舞夏", "最愛", "元春", "氷華", "春生"])
    print(fri[0])                       // 舞夏
    print(fri[5, default: "INDEX"])     // INDEX
}

添字付けの定義で既定値を指定する_オートクロージャ: do {
    print("------------ 添字付けの定義で既定値を指定する_オートクロージャ ------------")

    struct Friends {
        let names: [String]
        subscript(idx: Int) -> String { return names[idx] }
        subscript(idx: Int, default def: @autoclosure() -> String) -> String {
            guard 0 ..< names.count ~= idx else { return def() }
            return self[idx]
        }
    }
}

/**
 -----------------------------------------------------------------
 ■ 遅延格納型プロパティ
 クラスまたは構造体のインスタンスプロパティのうち、必要になったときにそのプロパティ
 を評価する。
 先頭に`lazy`キーワードをつければ、そのプロパティは遅延悪能型プロパティになる。
 -----------------------------------------------------------------
 */
import Foundation
ファイルの属性を遅延評価によって取得: do {
    print("------------ ファイルの属性を遅延評価によって取得 ------------")

    class FileAttribute {
        let filename: String
        lazy var size: Int = self.getFileSize()     // 遅延評価で値を決定

        // イニシャライザ
        init(file: String) { filename = file }

        ///
        /// - Returns: <#description#>
        func getFileSize() -> Int {
            var buffer = stat()             // 構造体の初期化
            stat(filename/* ファイルパス */, &buffer/* 構造体へのポインタ */)         // statを呼び出す
            print("[getFileSize]")          // 動作確認のための印字
            return Int(buffer.st_size)      // 得られた値をInt型に変換
        }
    }

    // 検証
    let d = FileAttribute(file: "text.txt")
    print(d.filename)   // text.txt
    print(d.size)       // ① [getFileSize] 0 ※今回は用意してないからファイルサイズは0
    print(d.size)       // ② 0 ※今回は用意してないからファイルサイズは0
}/*
  ① プロパティsizeを参照することによって関数getFileSizeが呼び出される。
  ② 一度ファイルの属性が取得できると、次からは関数getFileSizeが呼び出されない。
  */

ファイルの属性を遅延評価によって取得（クロージャ版）: do {
    class FileAttribute {
        let filename: String
        // クロージャの記述開始
        lazy var size: Int = {
            var buffer = stat()
            stat(self.filename, &buffer)
            print("[getFileSize]")
            return Int(buffer.st_size)
        }()

        // イニシャライザ
        init(file: String) { filename = file }
    }
}

