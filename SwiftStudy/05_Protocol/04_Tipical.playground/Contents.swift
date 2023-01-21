import UIKit

// 5-4 代表的なプロトコルの例

/**
 -----------------------------------------------------------------
 ■ 大小比較のためのプロトコルComparable
 `大小比較可能な機能を表すプロトコルComparable`。
 Comparableはプロトコル`Equatable`を継承している。実現する際は、演算子
 `「==」「<」`だけでよい。これらを実現すれば自動的に`「>」「<=」「>=」`も使える
 ようになる。
 -----------------------------------------------------------------
 */

struct Time: Comparable, CustomStringConvertible {
    let hour, min: Int      // 時刻
    /// 時刻を比較する
    /// - Parameters:
    ///   - lhs: 時刻
    ///   - rhs: 時刻
    /// - Returns: 時刻が同じであればtrue
    static func ==(lhs: Time, rhs: Time) -> Bool {
        return lhs.hour == rhs.hour && lhs.min == rhs.min
    }

    /// 時刻を比較する
    /// - Parameters:
    ///   - lhs: 時刻
    ///   - rhs: 時刻
    /// - Returns: 第一引数より第二引数の時刻が未来であればtrue
    static func <(lhs: Time, rhs: Time) -> Bool {
        return lhs.hour < rhs.hour
        || (lhs.hour == rhs.hour && lhs.min < rhs.min)
    }

    /// 1桁の場合0を付与する
    var description: String {
        let h = hour < 10 ? "0\(hour)" : "\(hour)"
        let m = min  < 10 ? "0\(min)"  : "\(min)"
        return h + ":" + m
    }
}

プロトコルComparableを採用した例: do {
    let t1 = Time(hour: 9, min: 0)
    let t2 = Time(hour: 12, min: 30)
    let t3 = Time(hour: 12, min: 15)
    print("t1とt2は時刻が違うけど、反転式だからtrueになるよ 👉 \(t1 != t2)")
    print("t1はt3よりも過去だからtrueになるよ 👉 \(t1 > t3)")
    print("t1, t2, t3を時刻順にソートできるよ 👉 \([t1, t2, t3].sorted())")     // [09:00, 12:15, 12:30]
}
