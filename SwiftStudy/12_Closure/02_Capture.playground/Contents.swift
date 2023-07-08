import UIKit

// 12-2 変数のキャプチャ
/**
 -----------------------------------------------------------------
 ■ クロージャが個別にローカル変数をキャプチャする場合
 インスタンスが生成される時、クロージャの外側にある変数の値を取り込んで、あれやこれ
 やとすることを`キャプチャ`と呼ぶ。
 -----------------------------------------------------------------
 */
変数のキャプチャ: do {
    print("------------ 変数のキャプチャ ------------")
    var globalCount = 0 // 各クロージャから参照される

    // () -> Int という型を持つクロージャのインスタンスを作って返す関数
    func maker(_ a: Int, _ b: Int) -> (() -> Int) {
        var localvar = a

        /// クロージャ式
        return { () -> Int in
            globalCount += 1    // クロージャ内から参照
            localvar += b       // bがキャプチャされる
            return localvar
        }
    }

    // 検証
    var m1 = maker(10, 1)                                   // クロージャインスタンス 1
    print("m1() = \(m1()), glocalCount = \(globalCount)")   // m1() = 11, glocalCount = 1
    print("m1() = \(m1()), glocalCount = \(globalCount)")   // m1() = 12, glocalCount = 2

    globalCount = 1000
    print("m1() = \(m1()), globalCount = \(globalCount)")   // m1() = 13, globalCount = 1001

    var m2 = maker(50, 2)                                   // クロージャインスタンス 2
    print("m2() = \(m2()), globalCount = \(globalCount)")   // m2() = 52, globalCount = 1002
    print("m1() = \(m2()), globalCount = \(globalCount)")   // m1() = 54, globalCount = 1003
    print("m2() = \(m2()), globalCount = \(globalCount)")   // m2() = 56, globalCount = 1004

    /**
     クロージャ式を含むコードブロック内で参照可能なローカル変数は、ローカル変数が消滅した後でもクロージャが使われている場合、
     クロージャの中からは、元のローカル変数が総菜し続けているかのように参照、更新が可能。
     ローカル変数を別々にキャプチャした場合、それぞれのクロージャに変数の実態が作れられる。
     グローバル変数は共有される。
     */
}

/**
 -----------------------------------------------------------------
 ■ 複数のクロージャが同じローカル変数をキャプチャする場合
 -----------------------------------------------------------------
 */
変数のキャプチャを調べる: do {
    print("------------ 変数のキャプチャを調べる ------------")

    var m1: (() -> ())! = nil       // クロージャを代入する変数
    var m2: (() -> ())! = nil

    /// 関数内でもクロージャを1回ずつ呼び出す
    /// - Parameter a: 初期値
    func makerW(_ a: Int) {
        var localvar = a            // 共有される
        m1 = { localvar += 1; print("m1: \(localvar)") }
        m2 = { localvar += 5; print("m1: \(localvar)") }

        // クロージャ呼び出し
        m1()                        // m1: 11
        print("--: \(localvar)")

        m2()                        // m1: 16
        print("--: \(localvar)")
    }

    // 検証
    makerW(10)

    // クロージャを交互に呼び出し
    m1()    // m1: 17
    m2()    // m1: 22
    m1()    // m1: 23

    /**
     関数makerWの実行が終わり、ローカル変数localvarがなくなっている時点で
     再び2つのクロージャを呼び出すと、値が保持され、2つのクロージャ間で
     共有関係が保たれる。
     */
}

/**
 -----------------------------------------------------------------
 ■ クロージャが参照型の変数をキャプチャする場合
 -----------------------------------------------------------------
 */
変数のキャプチャを調べる: do {
    print("------------ 変数のキャプチャを調べる ------------")

    /// 整数の値を1つだけ持つクラス
    class MyInt {
        var value = 0

        /// イニシャライザ
        init(_ v: Int) { value = v }

        // インスタンスが解放される直前に呼び出される
        deinit { print("deinit: \(value)") }
    }

    /// 文字列を出力し、MyIntインスタンスが持つプロパティをインクリメントして出力する
    /// - Parameters:
    ///   - a: MyIntインスタンス
    ///   - s: 出力する文字列
    /// - Returns: クロージャ
    func makerZ(_ a: MyInt, _ s: String) -> () -> () {
        let localvar = a
        return {
            localvar.value += 1
            print("\(s): \(localvar.value)")
        }
    }

    // 検証
    var obj: MyInt! = MyInt(10)                 // MyIntインスタンス
    var m1: (()->())! = makerZ(obj, "m1")       // クロージャを代入
    m1()                                        // m1: 11

    var m2: (()->())! = makerZ(obj, "m2")       // クロージャを代入
    obj = nil                                   // この時点では、MyIntインスタンスはまだ解放されない
    m2()                                        // m2: 12

    m1()                                        // m1: 13
    m1 = nil                                    // この時点では、MyIntインスタンスはまだ解放されない

    m2()                                        // m1: 14
    m2 = nil                                    // ここでMyIntインスタンスが解放される。deinit: 14
}

/**
 -----------------------------------------------------------------
 ■ メソッドとイニシャライザ
 通常の関数と同様に、クラスのなどのメソッド、イニシャライザもクロージャとして扱う
 ことができる。
 -----------------------------------------------------------------
 */
簡単なクラス: do {
    print("------------ 簡単なクラス ------------")

    /// 友達クラス
    class Friend {
        let name: String        // 名前
        // イニシャライザ
        init(name: String) { self.name = name }
        // デイニシャライザ
        deinit { print("deinit", name) }

        /// 名乗る
        func sayName() { print("私は\(name)です") }
        /// 挨拶した後に、名乗る
        /// - Parameter f: 友達インスタンス
        func sayHello(to f: Friend) {
            print("こんにちは、\(f.name)さん。\(name)です。")
        }
    }

    // 検証
    let clo1: (String) -> Friend = Friend.init      // イニシャライザ

    var clo2: (Friend) -> ()
    do {
        let fr1 = clo1("烏丸")                       // クロージャからインスタンス生成
        clo2 = fr1.sayHello(to:)                    // インスタンスのメソッドを代入
        fr1.sayName()                               // 私は烏丸です
    } /* deinit 烏丸 - fr1インスタンスはここで消滅 */

    let fr2 = Friend(name: "久我山")
    clo2(fr2)                                       // こんにちは、久我山さん。烏丸です。
    clo2 = fr2.sayHello
}

/**
 -----------------------------------------------------------------
 ■ キャプチャリスト
 先頭に変数名を[]で囲んだものをキャプチャリスト(capture list)と呼ぶ。
 キャプチャリストに書き並べた変数は、クロージャの生成時にコピーが作成され、共有関係
 ではなくなる。元の値に影響がない。キャプチャリストの後に`in`が必須。
 -----------------------------------------------------------------
 */
キャプチャリスト: do {
    print("------------ キャプチャリスト ------------")

    // クロージャを代入する変数
    var a, b, c: () -> ()
    do {
        var count = 0
        var name = "PASCAL"
        a = { print("A: \(count), \(name)") }
        b = { [count] in print("C: \(count), \(name)") }
        c = { [name, count] in print("C: \(count), \(name)") }
        count = 1
        name = "Swift"
    }
    // 検証
    a()  // A: 1, Swift  ← クロージャはローカル変数count, nameと値を共有
    b()  // C: 0, Swift  ← countはコピーが作られる。nameは共有している。
    c()  // C: 0, PASCAL ← nameもcountもコピーが作られている。
}
