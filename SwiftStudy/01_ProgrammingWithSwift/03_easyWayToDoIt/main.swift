//
//  main.swift
//  SwiftStudy
//  
//  Created in 2022/11/22
//  
//

import Foundation
/**
 -----------------------------------------------------------------
 ■ 複数のソースファイルからなるプログラムをコンパイルする
 3. 例題プログラム
 ※本筋から話が逸れるため、ロジックの説明は省く

 なお、`プログラムの起動後、最初に動作するコードはmain.swift`というファイルに記
 述する。

 複数ファイルをコンパイルするには、以下のコマンドを実行する。なお、-oオプションは
 コンパイルされて新しくできる実行ファイルのファイル名を指定できる。
 `swiftc -o brain Rand.swift Analyzer.swift main.swift`
 実行すると以下の実行ファイルができる。
 `brain`
これを実行する。
 `./brain`
 以下のような結果になる。
 ```
 あなたの名前: 名無し
 名無しさんのプログラムは、
  天啓:22% 偶然:21% 努力:21% 根性:19% 信念:17% でできています。
 ```
 -----------------------------------------------------------------
 */
print("あなたの名前: ", terminator: "")
// 文字列を入力して文字コードの和をとる
if let name = readLine() {
    let chars = name.filter{ !$0.isWhitespace }
    let v = chars.unicodeScalars.reduce(0){ $0 &+ $1.value }
    print("\(name)さんのプログラムは、")
    for (elm, val) in analyzer(Int(v)) {
        print(" \(elm):\(val)%", terminator: "")
    }
    print(" でできています。")
}
