import UIKit
import Foundation       // 現在時刻をCalendarとDateを使って得る

// 失敗のあるイニシャラザ

/**
 -----------------------------------------------------------------
 ■ 失敗のあるイニシャラザの定義
 `init?`でイニシャラザを定義する。通常のイニシャラザ(init)と、失敗のあるイニシャ
 ラザ(init?)が、全く同じ日キスの並びを持つことはできない。
 -----------------------------------------------------------------
 */
失敗のあるイニシャライザ: do {
    struct SimpleTime {
        let hour, min: Int

        /// 時と分を指定する「失敗のある」初期化
        /// - Parameters:
        ///   - h: 時
        ///   - m: 分
        init?(_ h: Int, _ m: Int) {
            // 時と分が不正な値だった場合、初期化失敗
            if h < 0 || h > 23 || m < 0 || m > 59 {
                return nil
            }
            // 不正な値でなければ、通常通り初期化
            hour = h
            min  = m
        }

        /// 時と分を指定しない「失敗のない」初期化
        init() {
            var calendar = Calendar.current                 // Foundationの構造体
            calendar.timeZone = TimeZone(abbreviation: "JST")!
            // タイムゾーンを得る失敗のあるイニシャライザ
            let d = Date()
            hour  = calendar.component(.hour, from: d)      // .hourは列挙型
            min   = calendar.component(.minute, from: d)    // .minuteは列挙型
        }
    }

    // 検証
    if let u = SimpleTime(13, 72) {
        print("\(u.hour):\(u.min)")                         // 初期化に失敗するため、出力されない
    }

    let a: SimpleTime = SimpleTime(14, 30)!                 // オプショナルなので開示指定「!」が必要
    print("\(a.hour):\(a.min)")                             // 14:30

    let c = SimpleTime()
    print("\(c.hour):\(c.min)")                             // 21:7 ※現在時刻
}
