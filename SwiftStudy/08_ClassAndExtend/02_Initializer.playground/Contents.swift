import UIKit

// 8-2 イニシャライザ

/**
 -----------------------------------------------------------------
 ■ クラス継承
 -----------------------------------------------------------------
 */
ベースクラス: do {
    class DayOfMonth : CustomStringConvertible {
        var month, day: Int

        /// イニシャライザ
        /// - Parameters:
        ///   - month: 月
        ///   - dat: 日
        init (month: Int, day: Int) {
            self.month = month; self.day = day
        }


        /// 整形された 月/日 の形で表現する
        var description: String {
            return DayOfMonth.twoDigits(month) + "/" + DayOfMonth.twoDigits(day)
        }

        /// 2桁の数字を整形
        /// - Parameter n: 数字
        /// - Returns: 1桁なら0埋めされた数字
        class func twoDigits(_ n: Int) -> String {
            let i = n % 100
            if ( i < 10 ) { return "0\(i)" }
            return "\(i)"
        }
    }

    西暦年と曜日を追加したサブクラス: do {

        /// 渡した年月日の曜日を整数で表して返す。曜日（日曜＝0、月曜=1、...)
        /// - Parameters:
        ///   - y: 年
        ///   - m: 月
        ///   - d: 日
        /// - Returns: 整数で表現した曜日
        func dayOfWeek(_ y: Int, _ m: Int, _ d: Int) -> Int{
            var y = y, m = m

            // 1, 2月であれば、前年の13月、14月として計算する
            if m < 3 { m += 12; y -= 1 }

            let leap = y + y / 4 - y / 100 + y / 400
            return (leap + (13 * m + 8) / 5 + d) % 7
        }

        class DateOInfo: DayOfMonth {
            var year: Int
            var dow: Int
            /// 年、月、日、曜日の初期化を行う。
            /// - Parameters:
            ///   - y: 年
            ///   - m: 月
            ///   - d: 日
            init(_ y: Int, _ m: Int, _ d: Int) {
                year = y
                dow = dayOfWeek(y, m, d)
                super.init(month: m, day: d)
            }
        }
        曜日を文字列で持つサブクラス: do {
            class CalendarDate: DateOInfo {
                static let namesOfDays = [ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ]
                static var defaultYear = 2010   // 年の規定値
                var dweek = String()            // ここに注意

                /// 親クラスのイニシャライザをオーバーライド・・・①
                /// - Parameters:
                ///   - y: 年
                ///   - m: 月
                ///   - d: 日
                override init(_ y: Int, _ m: Int, _ d: Int) {
                    super.init(y, m, d)
                    dweek = CalendarDate.namesOfDays[dow]           // ここに注意。曜日の計算をする・・・1回目
                }

                /// 簡易イニシャライザ
                /// - Parameters:
                ///   - m: 月
                ///   - d: 日
                convenience init( _ m: Int, _ d: Int ) {
                    // ①のイニシャライザを呼び出す
                    self.init(CalendarDate.defaultYear, m, d)
                }

                /// ベースクラスDayOfMonthのdayプロパティを上書きするからoverride
                /// dayプロパティの値を変更されたタイミングでdidsetが呼び出される。
                override var day: Int {
                    didSet {
                        // 整数で表現した曜日を取得
                        dow = dayOfWeek(year, month, day)
                        // 曜日リストから、対象の曜日を取得
                        dweek = CalendarDate.namesOfDays[dow]       // 曜日の計算をやり直す・・・2回目
                    }
                }

                // 計算型プロパティの上書き
                override var description: String {
                    return "\(year)/" + super.description + " (\(dweek))"
                }
            }
            // 検証
            var d = CalendarDate(7, 30)
            print(d)        // 2010/07/30 (Fri)
            d.day += 1      // 計算型プロパティ(didset)が働き、曜日を再計算する
            print(d)        // 2010/07/31 (Sat)
        }
    }
}

/**
 -----------------------------------------------------------------
 ■ 失敗のあるイニシャライザ
 -----------------------------------------------------------------
 */
失敗のあるイニシャライザ: do {
    class NamePlate: CustomStringConvertible {
        var name, title: String     // 名前, 肩書き

        /// 失敗のないイニシャライザ
        init() {
            name = "出席者"; title = ""
        }

        /// 失敗のあるイニシャライザ
        /// - Parameters:
        ///   - name: 名前
        ///   - title: タイトル
        init?(name: String, title: String) {
            // 名前が空の場合、初期化を終了する
            if name == "" { return nil }
            self.name = name
            self.title = title
        }

        var description: String {
            // titleが空であれば、名前のみ返却する
            return title.isEmpty ? name : "[\(title)] \(name)"
        }
    }

    失敗のあるイニシャライザを継承する: do {
        class SpeakerNamePlate : NamePlate {
            /// 失敗のあるイニシャライザをオーバーライドしているが、失敗する可能性あり
            /// - Parameters:
            ///   - name: 名前
            ///   - title: タイトル
            override init?(name: String, title: String) {
                super.init(name: name, title: title)
                // スーパークラスでイニシャライザに失敗したら、ここには戻ってこない
                if self.title == "" { self.title = "講演者" }
            }
        }

        class GuestNamePlate: NamePlate {
            /// 失敗のあるイニシャライザをオーバーライドして、失敗しないイニシャライザにしている
            /// - Parameters:
            ///   - name: 名前
            ///   - title: タイトル
            override init(name :String, title: String) {
                // 名前が空の場合
                if name.isEmpty {
                    // スーパークラスの失敗しないイニシャライザを呼ぶ
                    super.init()
                    // タイトルが空じゃなければ、名前にタイトルを設定
                    if !title.isEmpty { self.name = title }
                // 名前が空でなければ、失敗しない
                } else {
                    super.init(name: name, title: title)!
                }
            }
        }
        // 検証
        NamePlate(name: "山田", title: "主演")              // [主演] 山田
        SpeakerNamePlate(name: "", title: "企画")          // nil
        SpeakerNamePlate(name: "佐々木", title: "")        // [講演者] 佐々木
        GuestNamePlate(name: "", title: "プロデューサー")    // プロデューサー
    }
}

/**
 -----------------------------------------------------------------
 ■ 必須イニシャライザ
 イニシャラザは基本的に継承しないで。
 イニシャラザに`required`を付けたら、サブクラスに「継承してもいいけど、絶対この
 イニシャライザをオーバーライドしろよな。」ってことになる。

 サブクラス側は`overrideはつけなくていい`。requiredがついている時点でオーバーライド
 してもらう事が確定しているから。その代わり`required`ってつけなきゃダメ。
 -----------------------------------------------------------------
 */
そもそも必須イニシャライザが必要になるケースとは: do {
    class NamePlate: CustomStringConvertible {
        var name, title: String
        /// 引数の数だけ、NamePlateインスタンスを生成してリストを返却
        /// - Parameter num: インスタンス生成数
        /// - Returns: NamePlateインスタンスが格納されたリスト
        class func makePlates(_ num: Int) -> [NamePlate] {
            var bulk = [NamePlate]()
            for _ in 0 ..< num {
                bulk.append( self.init() )
            }
            return bulk
        }

        /// 必須イニシャライザ
        required init() {
            name = "出席者"; title = ""
        }

        var description: String {
            // titleが空であれば、名前のみ返却する
            return title.isEmpty ? name : "[\(title)] \(name)"
        }
    }
    // 検証
    var namePlateList = NamePlate.makePlates(2)     // NamePlateインスタンスを2つ格納
    var count = 0                                   // カウンター
    namePlateList.forEach {
        count += 1
        print("\(count) : \($0)")                   // 1 : 出席者 2 : 出席者
    }
}
