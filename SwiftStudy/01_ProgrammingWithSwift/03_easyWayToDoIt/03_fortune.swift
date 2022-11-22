//
//  03_fortune.swift
//  SwiftStudy
//  
//  Created in 2022/11/22
//  
//

import Foundation
/**
 -----------------------------------------------------------------
 ■ ソースプログラムをコンパイルする
 ファイルのあるディレクトリに移動し、以下コマンドを実行する。
 `swiftc 03_fortune.swift`

 特に問題がなければカレントディレクトリにコンパイルされた以下ファイルが生成される。
 `03_fortune`

 この`03_fortune`を実行すると、このファイルで定義した処理が実行される。

 また、以下コマンドを実行すると`解釈実行`というコンパイルせずに、スクリプト言語と
 して解釈実行だけさせることができる。
 `swift 03_fortune.swift`即
 -----------------------------------------------------------------
 */
let fortune = ["大吉\u{2661}", "中吉\u{266a}", "小吉", "末吉", "凶\u{1f61e}", "大凶\u{1f480}"]
let idx = Int(time(nil)) % fortune.count
print(fortune[idx])
