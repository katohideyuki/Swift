import UIKit

// 7-1 タプルとswitch文

/**
 -----------------------------------------------------------------
 ■ タプルをcaseで使う。
 case節の内部だけで有効な定数、変数を宣言できる。
 -----------------------------------------------------------------
 */

変数dayが月と日からなる日付を表すタプル: do {
    let day = (5, 3)                       // 5月3日
    switch day {
        case (1, 1): print("元旦")
        case (2, 11): print("建国記念日")
        case (5, 3): print("憲法記念日")     // 出力される
        default: break
    }
}

ある範囲の日付を表す: do {
    let day = (5, 4)
    switch day {
        case (1, 1...5): print("年末年始")
        case (5, 3): print("憲法記念日")
        case (4, 29), (5, 2...6): print("連休")
        default: break
    }
}

case節の内部だけで使う変数: do {
    let day = (8, 10)
    switch day {
        case (5, 3): print("憲法記念日")
        case (8, let d): print("day.0が「8」であれば、day.1がどんな値でも出力される 👉 \(d)")
        default: break
    }
}

定数を使う必要がなければアンダースコアでもよい: do {
    let day = (1, 1)
    switch day {
        case (1, _): print("day.0が「1」であれば出力される")        // こっちが出力
        case (2, _): print("day.0が「2」であれば出力される")
        default: break
    }
}

/**
 -----------------------------------------------------------------
 ■ switch文でwhere節を使う
 caseラベルに条件をつける場合、ラベルと「:」の間に、予約後`whereと条件`を記述する。
 定数や変数を使うラベルは、別なラベルと区切って並べる際に制約がある。どのラベルの条件
 に一致したかによって、定数や変数が値を持たない可能性があるから。
 `fallthrough`は直下のケースの処理を実行する。
 -----------------------------------------------------------------
 */

一月の第二月曜日が成人の日であるか: do {

    /// 渡した年月日の曜日を整数で表して返す。曜日（日曜＝0、月曜=1、...)
    /// - Parameters:
    ///   - y: 年
    ///   - m: 月
    ///   - d: 日
    /// - Returns: 整数で表現した曜日
    func dayOfWeek(_ y: Int, _ m: Int, _ d: Int) -> Int{
        // 変数y, mは仮引数とは別物
        var y = y, m = m
        // 1, 2月であれば、前年の13月、14月として計算する
        if m < 3 { m += 12; y -= 1 }

        let leap = y + y / 4 - y / 100 + y / 400
        return (leap + (13 * m + 8) / 5 + d) % 7
    }
    
    let day = (1, 1)
    switch day {
        case (1, let d) where d >= 8 && d <= 14 && dayOfWeek(2023, 1, d) == 1: print("成人の日")
        case (8, _): print("夏休み")
        case (let m, let d) where dayOfWeek(2023, m, d) == 0: print("\(m)/\(d)は日曜日")        // 出力
        default: break
    }
    // タプルの全ての要素を定数に割り当てる場合、タプルの前にletを定義すればよい
    // case let (m, d) where dayOfWeek(2023, m, d) == 0
}

定数や変数を使った場合に複数のラベルを使う場合には注意が必要: do {
    ダメな例: do {
        let t = (1, 2)
        switch t {
                //        case (1, let y), (2, 2): print("\(y)")        // コンパイルエラー。(2, 2)だった場合、let y の値が不明なため
            case (2, _) : fallthrough
                //        case (let x, 2): print("\(z)")                // コンパイルエラー。fallthrough実行後、let z の値が不明なため
            default: break
        }
    }

    よい例: do {
        for t in [ (5, -1), (6, 8), (16, 10), (7, 7), (25, 14), (10, 9) ] {
            // case節で使用する定数・変数が同じ名前かつ同じ型であればOK
            switch t {
                case let (x, y) where x == y, let (x, y) where x <= 0 || y <= 0:
                    print("異なる正整数の組ではありません(\(x), \(y))")
                case (10, let h), (let h, 10):
                    print("一方が10、もう一方は\(h)です")
                default: break
            }
        }
    }
}

/**
 -----------------------------------------------------------------
 ■ オプショナル型をswitch文で使う
 オプショナル型がnil以外の値を持つときにマッチする。マッチしたら、その後のwhere節
 や実行文で開示演算子?を使わないで参照できる。また、nilにマッチしたケースも記述でき
 る。範囲を示すケースの場合は`()`の外に?をつける。
 -----------------------------------------------------------------
 */
オプショナル型のswitch文: do {
    typealias People = (String, Int?)
    var kinmugi = People("金麦くん", 25)

    switch kinmugi {
        case let (name, age?) where age >= 18:
            print("\(name), 免許とれるよ")
        case let (name, (15...18)?):
            print("\(name), まだ高校生だね")
        case (let name, nil):
            print("\(name), きみは何歳なの？")
        default: break
    }
}
