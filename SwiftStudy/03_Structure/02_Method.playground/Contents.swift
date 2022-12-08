import UIKit

/**
 -----------------------------------------------------------------
 ■ インスタンスに対するメソッドの定義
 -----------------------------------------------------------------
 */
メソッド定義を持つ構造体: do {

    /// 時刻(時/分)を持つ構造体
    struct Time {
        let hour, min: Int  // 時間, 分

        /// 指定した経過時間の新しい時刻を持つTime型を返却
        /// - Parameter min: 追加したい時間(分)
        /// - Returns: 新しいTimeインスタンス
        func advanced(min: Int) -> Time {
            var m = self.min + min          // 分を加算
            var h = self.hour
            if m >= 60 {
                h = (h + m / 60) % 24
                m %= 60
            }
            return Time(hour: h, min: m)    // 新しいTimeインスタンスを返却
        }

        /// Time型を文字列で出力する
        /// - Returns: Time型のプロパティを整形して文字列で返却
        func toString() -> String {
            let h = self.hour < 10 ? " \(hour)" : "\(hour)"
            let m = self.min < 10 ? "0\(min)" : "\(min)"
            return h + ":" + m
        }
    }

    let t1 = Time(hour: 22, min: 45)
    let t2 = t1.advanced(min: 140)

    print(t1.toString())        // 22:45  advancedメソッド実行前
    print(t2.toString())        //  1:05  advancedメソッド実行後(140分経過している)
}

/**
 -----------------------------------------------------------------
 ■ 構造体の内容を変更するメソッド
 Swiftでは、同じ内容の構造体のインスタンスをできるだけメモリ上で共有する実装方法
 を採用し、実行効率を向上する方針。構造体の定義では、インスタンスの内容を変更する
 メソッドは、定義の先頭のfuncの直前に`mutating`というキーワードを置かなければ
 ならない。
 -----------------------------------------------------------------
 */
プロパティの値を変更するメソッドを持つ: do {
    struct Clock {
        var hour = 0, min  = 0

        /// Clock構造体が持つ時刻プロパティに加算する
        /// - Parameter min: 加算したい時間(分)
        mutating func advance(min: Int) {
            let m = self.min + min
            if m >= 60 {
                self.min = m % 60
                let t = self.hour + m / 60
                self.hour = t % 24
            } else {
                self.min = m
            }
        }

        /// advanceメソッドを呼び、1分加算する
        mutating func inc() {
            self.advance(min: 1)
        }

        /// Clock型を文字列で出力する
        /// - Returns: Time型のプロパティを整形して文字列で返却
        func toString() -> String {
            let h = self.hour < 10 ? " \(hour)" : "\(hour)"
            let m = self.min < 10 ? "0\(min)" : "\(min)"
            return h + ":" + m
        }
    }

    var tic = Clock(hour: 19, min: 40)      // 19:40分の時刻を持つClockインスタンスを生成
    tic.advance(min: 19)                    // 19分加算
    tic.inc()                               // 1分加算
    print(tic.toString())                   // 20:00 ※20分加算されている
}

/**
 -----------------------------------------------------------------
 ■ タイプメソッド
 ユーティリティなメソッドのことを、`タイプメソッド`と呼ぶ。それらメソッドにはキー
 ワードとして`static`をつける。同じ構造体から呼ぶ場合`Self`をつけて呼ぶこともで
 きる。付けなくてもOK。
 -----------------------------------------------------------------
 */
構造体のタイプメソッド: do {
    struct SimpleDate {
        var year, month, day: Int

        /// うるう年を判定する。
        /// 西暦が4で割り切れ、かつ100で割れない or 400で割り切れる年。
        /// - Parameter y: 西暦
        /// - Returns: うるう年のであればtrueを返却
        static func isLeap(_ y: Int) -> Bool {
            return (y % 4 == 0) && (y % 100 != 0 || y % 400 == 0)
        }

        /// 月を受け取り、その月の日数を返却する。
        /// - Parameters:
        ///   - m: 月
        ///   - year: 年
        /// - Returns: 受け取った月の日数を返却
        static func dayOfMonth(_ m: Int, year: Int) -> Int {
            switch m {
                case 2: return isLeap(year) ? 29 : 28
                case 4, 6, 9, 11: return 30
                default: return 31
            }
        }

        /// インスタンスメソッドleapYearからタイプメソッドisLeapを呼ぶ。
        /// インスタンスのメソッドからタイプメソッドを呼ぶ場合は
        /// 型名またはSelf.タイプメソッド の形式で呼ぶ。
        /// - Returns:タイプメソッド.isLeapの返却値
        func leapYear() -> Bool {
            SimpleDate.isLeap(year)
        }
    }

    print(SimpleDate.isLeap(2000))                 // true
    print(SimpleDate.dayOfMonth(2, year: 2000))    // 29

    let d = SimpleDate(year: 2024, month: 11, day: 7)
    print("うるう年?", d.leapYear())                // うるう年? true
}

/**
 -----------------------------------------------------------------
 ■ イニシャライザとメソッド
 イニシャライザの中でインスタンスメソッドを使う場合には注意が必要。イニシャライザ
 の中で、`プロパティがすべて初期化完了される前にインスタンスメソッドは呼べない`。
 ただし、`すべてのプロパティが初期化されていればOK`。
 または`イニシャライザの中で呼ぶ``メソッドがタイプメソッドであればOK`。
 その他にも実現可能な方法はあるが、ここでは説明を省略する。
 -----------------------------------------------------------------
 */
文字列を持つ日付の構造体_NG: do {
    struct DateWithString {
//        let str: String
        let year, month, day: Int
        init(_ y: Int, _ m: Int, _ d: Int) {
            year = y; month = m; day = d
//            str = "\(y)_" * twoDigits(m) + "_" + twoDigits(d)     // コンパイルエラー。strプロパティが初期化される前にインスタンスメソッドを呼び出しているため。
        }
    }

    /// 引数が1桁であれば0埋めし、2桁以上であれば何もしない
    /// - Parameter n: 整数
    /// - Returns: 整数（1桁であれば0埋め)
    func towDigits(_ n: Int) -> String {
        let i = n % 100
        return i < 10 ? "0\(i)" : "\(i)"
    }
}

文字列を持つ日付の構造体_OK: do {
    struct DateWithString {
        let str: String
        let year, month, day: Int
        init(_ y: Int, _ m: Int, _ d: Int) {
            year = y; month = m; day = d
            // strプロパティが初期化前だが、twoDigitsメソッドはタイプメソッドなので問題なし。
            str = "\(y)_" + DateWithString.twoDigits(m) + "_" + Self.twoDigits(d)
        }

        /// 引数が1桁であれば0埋めし、2桁以上であれば何もしない
        /// - Parameter n: 整数
        /// - Returns: 整数（1桁であれば0埋め)
        static func twoDigits(_ n: Int) -> String {
            let i = n % 100
            return i < 10 ? "0\(i)" : "\(i)"
        }
    }

    let an1 = DateWithString(2015, 6, 22)
    print(an1.str)      // 2015_06_22
}
