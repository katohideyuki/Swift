import UIKit

// 12.1 クロージャの宣言

/**
 -----------------------------------------------------------------
 クロージャの概要
 -----------------------------------------------------------------
 */
簡単なクロージャ: do {
    var c1 = { () -> () in print("hello") }
    c1()    // hello

    // 値を返すクロージャはreturn文が必要
    let c2 = { (a: Int, b: Int) -> Double in
        if b == 0 { return 0.0 }
        return Double(a) / Double(b)
    }
    print(c2(10, 8))        // 1.25

    // 値を返すreturn文が1つだけの場合、returnキーワードは省略可
    let c3 = { (a: Int, b: Int) -> Double in
        b == 0 ? 0.0: Double(a) / Double(b)
    }
    print(c3(10, 2))        // 5.0
}


/**
 -----------------------------------------------------------------
 ■ 仮引数と戻り値型の省略
 -----------------------------------------------------------------
 */
全部同じ意味: do {
    var c1 = { () -> () in print("hello") }     // 省略なし
    var c2 = { () -> Void in print("hello") }   // ()とVoidは同じ
    var c3 = { () in print("hello") }           // 戻り値の型を省略
    var c4 = { print("hello") }                 // 引数も省略
}

/**
 -----------------------------------------------------------------
 ■ クロージャと関数の型
 -----------------------------------------------------------------
 */

クロージャ式を変数に体入: do {
    let c1 = { (a: Int, b: Int) -> Double in
        return Double(a) / Double(b)
    }

    var c2: (Int, Int) -> Double = c1
    c2(10, 4)       // 2.5
    print(c2)       // (Function)

    /** 関数を定数や変数に代入 */
    func f1(a: Int, b: Int) -> Double { return Double(a) / Double(b) }
    print(f1)       // (Function)
    c2 = f1         // 問題なく代入可能

    /** 検証 */
    print(f1(a: 17, b: 4))      // 4.25
//    print(c2(a: 17, b: 4))    // 引数ラベルを記述するとエラー
    print(c2(17, 4))            // 4.25
}

/**
 -----------------------------------------------------------------
 ■ オーバーロードされた関数を区別
 -----------------------------------------------------------------
 */
オーバーロードされた関数: do {
    /** 関数1 */
    func bracket(name: String) { print("[\(name)] ", terminator: "") }        // (1)
    /** 関数2 */
    func pr(name: String) { print(name + ": ", terminator: "") }            // (2)
    /** 関数2をオーバーロード */
    func pr(message m: String) { print("\"\(m)\"") }                        // (3)
    /** 関数2をオーバーロード */
    func pr(_ strs: String...) {
        for s in strs { print(s, terminator: " ") }
        print()
    }
    /**  関数2をオーバーロード */
    func pr(_ num: Int) { print(num, terminator: " ") }


    /** 検証 */
    let f1 = bracket                     // オーバーロードがなければ関数名だけでOK
    let f2 = pr(message:)                // 引数ラベルで関数を指定できる
    let f3: (String...) -> () = pr       // 関数の型（引数と返り値）を明示する

    f1("委員長")
    f2("きちんとしなさい")                  // [委員長] "きちんとしなさい"
    f3("cat", "塾", "dount", "春休み")     // cat 塾 dount 春休み

}
