import UIKit

// 6-3 文字列と文字

/**
 -----------------------------------------------------------------
 ■ 指定位置の文字および部分文字列の取り出し方
 -----------------------------------------------------------------
 */
部分文字列を取り出す関数: do {
    /// 指定した範囲の文字列を取り出す
    /// - Parameters:
    ///   - str: 元の文字列
    ///   - from: 取り出したい最初の文字位置
    ///   - length: 取り出したい文字数
    /// - Returns: 取り出した文字列
    func mySubString(str :String, from: Int, length: Int) -> String? {
        // 数え始めの文字位置とそこから数える文字数が、全体の文字数を超えたらNG
        guard str.count >= from + length else { return nil }
        let begin = str.index(str.startIndex, offsetBy: from)       // 先頭からfrom文字後の位置
        let upTo  = str.index(begin, offsetBy: length)              // さらにlength文字後の位置
        return String(str[begin ..< upTo])                          // Stringに変換
    }

    // 検証
    let str = "このelse部には問題があるらしい"
    if let result = mySubString(str: str, from: 6, length: 4) {
        print(result)       // 部には問
    }
}

/**
 -----------------------------------------------------------------
 ■ 複数行にわたる文字列リテラルの記述
 Javaのテキストブロックみたいに記述できる。
 -----------------------------------------------------------------
 */
文字列リテラル: do {
    let s1 = """
    文字列の途中で直接Unicodeを指定するには
        "\\u{611B}"
    のように、16進数でコードを記述する。
    """ // この末尾の「"""」の前にある空白の幅が、ブロック内で無視する空白の幅になっている。

    print(s1)
}
ソース上では改行しているけど_出力結果は改行したくない書き方: do {
    let s1 = "alert"
    let s2 = """
        \(s1)の使い方:
            \(s1) [-h] [-v] [-i file] [--] message ...

        ビール飲みたい。\
        「行末にバックスラッシュを置いた次の行、つまりこの行が改行されずに出力されるよ。」
        「これは改行されているよ」
        """
    print(s2)
}
