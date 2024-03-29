import UIKit
import Foundation

// 14-1 互換なデータ型とポインタ

/**
 -----------------------------------------------------------------
 ■ 変数を用意して関数の結果を書き込む
 構造体tm
 標準ライブラリで提供されていて、年月日や時分秒をメンバーを持つ
 -----------------------------------------------------------------
 */
構造体tm: do {
    print("------------ 構造体tm ------------")

    var current: time_t = time(nil)                      // 現在時刻をtime_tで取得
    var tnow = tm()                                      // 変数を用意して初期化
    localtime_r(&current, &tnow)                         // 変数tnowに情報が書き込まれる
    print("\(tnow.tm_mon + 1)月\(tnow.tm_mday)日")        // 8月19日 ※今日の日付を表示
}

/**
 -----------------------------------------------------------------
 ■ 配列を用意して関数の結果を書き込む
 関数putsは、渡した配列の内容は変更しないため、「&」は付けても付けなくてもどっち
 でもよい。
 -----------------------------------------------------------------
 */
関数ctime_rとputsを使って現在時刻を表示する: do {
    print("------------ 関数ctime_rとputsを使って現在時刻を表示する ------------")

    var buff = [Int8](repeating: 0, count: 26)
    var current: time_t = time(nil)
    ctime_r(&current, &buff)
    puts(buff)      // Sat Aug 19 22:33:15 2023
    puts(&buff)     // Sat Aug 19 22:33:15 2023 ※&があってもなくてもよい
    puts(&buff[0])     // S
}

/**
 -----------------------------------------------------------------
 ■ ポインタを使ってメモリにアクセスする
 ※この例文は一般には動作が保証されない書き方（実験例として記述しているため）
 -----------------------------------------------------------------
 */
Swiftの配列にポインタでアクセスする例: do {
    print("------------ Swiftの配列にポインタでアクセスする例 ------------")
    
    var buffer = [0.01, 10.0, 25.4, 31.9]
    let p = UnsafeMutablePointer<Double>(&buffer)       // &が必須
    var q = UnsafePointer<Double>(buffer)               // &を付けない
    print(p.pointee, p[3])                              // "0.01 31.9"
    p[2] = 100.0                                        // pは定数だけど参照先に代入可能
    q += 2                                              // ポインタを2つ分進める
    print(q.pointee)                                    // "100.0"
}
