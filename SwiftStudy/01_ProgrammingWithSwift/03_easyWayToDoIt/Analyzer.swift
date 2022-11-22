//
//  Analyzer.swift
//  SwiftStudy
//  
//  Created in 2022/11/22
//  
//

import Foundation
/**
 -----------------------------------------------------------------
 ■ 複数のソースファイルからなるプログラムをコンパイルする
 2. 表示のためのデータを生成する関数
 ※本筋から話が逸れるため、ロジックの説明は省く
 -----------------------------------------------------------------
 */
func analyzer(_ t: Int) -> [(String, Int)] {
    let elems = ["努力", "怠惰", "信念", "徹夜", "幸運", "偶然", "自身", "根性", "誤鬱", "誤謬", "打算", "天啓", "不安"]
    var rnd = RandGenerator(seed: t)        // 乱数の初期化
    var rates = [Double]()
    for _ in 0 ..< 5 {
        rates.append(Double.random(in: 0.0 ..< 1.0, using: &rnd))
    }
    let total = rates.reduce(0.0, +)        // 合計を計算する
    return [(String, Int)](zip(elems.shuffled(using: &rnd),
                               rates.sorted(by: >).map { Int(Double($0 * 100) / total + 0.5) }))
}
