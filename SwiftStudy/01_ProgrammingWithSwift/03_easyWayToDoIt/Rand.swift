//
//  Rand.swift
//  SwiftStudy
//  
//  Created in 2022/11/22
//  
//

import Foundation
/**
 -----------------------------------------------------------------
 ■ 複数のソースファイルからなるプログラムをコンパイルする
 1. 乱数を得るための構造体
 ※本筋から話が逸れるため、ロジックの説明は省く
 -----------------------------------------------------------------
 */
public struct RandGenerator : RandomNumberGenerator {
    private var rnd: UInt64             // そのときの乱数の計算結果
    // 乱数の初期値を与える
    init(seed: Int) {
        rnd = UInt64(seed)
        for _ in 0 ..< 10 { _ = self.next() }
    }

    public mutating func next() -> UInt64 {
        rnd = (rnd &* 10777) &+ 13577   // 混合合同法
        return rnd
    }
}
