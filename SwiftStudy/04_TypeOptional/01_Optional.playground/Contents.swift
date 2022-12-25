import UIKit

// オプショナル型

/**
 -----------------------------------------------------------------
 ■ オプショナルとnil
 扱うべき値が存在しないことを表すために`nil`という特別な値がある。`null`と同じ
 ようなもの。例えば、通常はInt型の値を持ち、場合によってnilを保持する可能性がある
 Int型であれば`Int?`という型で扱う。

 ■ オプショナル型の値を開示する
 オプショナル型かたデータを取り出すことを、`開示（アンラップ）`と呼ぶ。開示するた
 めには`「！」`という記号を式または変数の後ろに付ける。これを`開示指定`と呼ぶ。
 -----------------------------------------------------------------
 */
オプショナルInt型に値がある場合: do {
    var year : Int? = Int("2022")   // 文字列をInt型にキャストしてオプショナルInt型に代入
    let next : Int  = year! + 4     // オプショナルかた値を取り出して、計算する
    print(next)                     // 2026

    year! += 10                     // オプショナル変数にも代入できる
    print(year!)                    // 2032
}

オプショナルInt型に値がなくnilの場合: do {
    let year : Int? = Int("令和4年")   // 文字列をInt型にキャストするも、失敗してnilが代入される
//    let next : Int  = year! + 4     // 実行時エラー。nilを取り出しているため。
}

/**
 -----------------------------------------------------------------
 ■ 条件判定とオプショナル型
 nilが格納されている変数や定数に対して値を取り出すと、エラーが発生する。そのため、
 オプショナル型の変数、または定数は、`比較の演算子「==」または「!=」`などを使って
 格納されている値を調べる。この場合は、開示指定が適用されていないので、オプショナル
 の中身がnilの場合でもエラーは発生しない。
 -----------------------------------------------------------------
 */
オプショナルを取り出す前に値を確かめる: do {
    var nagano: Int? = Int("1998")
    // nilじゃなければ実行
    if nagano != nil { print("Nagano: \(nagano!)") }            // Nagano: 1998

    // 期待値であれば実行
    if nagano == 2020 { print(2020) }                           // 出力されない
}

オプショナルは_素直に中身を取り出すか_Stringのイニシャラザを使うこと: do {
    var n: Int? = nil, t: Int? = 1000
    print(String(describing: n), "+", String(describing: t))    // nil + Optional(1000)
}