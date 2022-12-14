import UIKit

/**
 -----------------------------------------------------------------
 ■ オーバーロード
 同じ関数名で、引数の型や個数が異なる別の関数を定義することができる（基本的には
 Javaと概念は同じ）。また、戻り値の方が異なる場合でも、オーバーロードとして見なさ
 れる。ただし、戻り値の型が明確になるような使い方をしないとコンパイルが混乱するの
 で、お勧めしない。
 -----------------------------------------------------------------
 */
オーバーロードの例: do {
    /// 2つの引数の値を入れ替える
    /// - Parameters:
    ///   - a: 整数1
    ///   - b: 整数2
    func mySwap(_ a: inout Int, _ b: inout Int) {
        let t = a; a = b; b = t
    }

    /// 3つの引数の値を入れ替える
    /// - Parameters:
    ///   - a: 整数1
    ///   - b: 整数2
    ///   - c: 整数3
    func mySwap(_ a: inout Int, _ b: inout Int, _ c: inout Int) {
        let t = a; a = b; b = c; c = t
    }

    var s = 10, t = 20
    var x =  1, y = 2, z = 3
    mySwap(&s, &t)
    print("s = \(s), t = \(t)")                 // s = 20, t = 10
    mySwap(&x, &y, &z)
    print("x = \(x), y = \(y), z = \(z)")       // x = 2, y = 3, z = 1
}

/**
 -----------------------------------------------------------------
 ■ 引数ラベルを使ったオーバーロード
 引数ラベルが異なっていてもオーバーロードとして見なされる。
 -----------------------------------------------------------------
 */
引数ラベルが異なるオーバーロードの例: do {
    /// 2つの引数の値を入れ替える [その1]
    /// - Parameters:
    ///   - a: 整数1
    ///   - b: 整数2
    func mySwap(_ a: inout Int, _ b: inout Int) {
        let t = a; a = b; b = t
    }

    /// 第一引数の値が第二引数以上であれば、2つの引数の値を入れ替える [その2]
    /// - Parameters:
    ///   - a: 整数1
    ///   - b: 整数2
    func mySwap(little a: inout Int, great b: inout Int) {
        // aがb以上であれば、値を入れ替える
        if a > b {
            let t = a, a = b, b = t
        }
    }
    var s = 10, t = 20
    // [その2]のmySwapが呼び出され、第一引数の値が小さいので値は入れ替わらない
    mySwap(little: &s, great: &t)
    print("s = \(s), t = \(t)")     // s = 10, t = 20

    // [その1]のmySwapが呼び出され、値が入れ替わる
    mySwap(&s, &t)
    print("s = \(s), t = \(t)")     // s = 20, t = 10
}
