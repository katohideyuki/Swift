import UIKit

// 8-1 クラスの定義

/**
 -----------------------------------------------------------------
 ■ クラスの概要
 構造体、タプル、列挙型は値型のデータ。つまり、値をそのまま生の状態で扱う。
 クラスは参照型。値がメモリ上のどっかに保管された場所のアドレスを使って、操作してい
 く。
 ざっくりとした区別として、ひとまとまりの意味のあるデータを表現するときは構造体。
 システムを構成する構造や、何か役割があって能動的に動作する処理などはクラス。
 (ピンとこない。。）
 クラスは、全項目イニシャライザは使えない。(インスタンス生成時に、プロパティを初期化
 するコンストラクタみたいなやつ)。
 ただし、既定イニシャライザなら使える。（インスタンス生成時に、プロパティの初期化
 が必要なく、`クラス名()`で定義できるやつ)
 構造体は値型のデータだから、値が変わる可能性があるプロパティには`mutating`という
 キーワードをつけるが、クラスには不要。`var`や`let`で定義しようが値は変えられる。
 とはいえ、値を変更させたくない時に使うキーワードがこの先の説明ででてくるだろうと
 予想。。
 -----------------------------------------------------------------
 */

/// 時間と分を持つクラス
class Time {
    // 初期化しておく必要がある
    var hour = 0, min = 0

    //  イニシャライザ
    init(hour: Int, min: Int) {
        self.hour = hour; self.min = min;
    }

    /// 指定した経過時間の新しい時刻を持つTime型を返却
    /// - Parameter min: 分
    func advance(min: Int) {
        let m = self.min + min      // 加算

        // 分が60分以上であれば時間に変換
        if m >= 60 {
            self.min = m % 60
            let t = self.hour + m / 60
            self.hour = t % 24
        } else {
            // 分が60分未満であればそのまま
            self.min = m
        }
    }

    /// 1分加算
    func inc() { self.advance(min: 1) }
    /// 出力用
    func toString() -> String {
        let h = hour < 10 ? " \(hour)": "\(hour)"
        let m = min  < 10 ? " \(min)" : "\(min)"
        return h + ":" + m
    }
}

検証: do {
    let t1 = Time(hour: 13, min: 20)
    let t2 = t1
    let t3 = Time(hour: 30, min: 00)
    print(String(format: "t1の時間 👉 %@", t1.toString()))        // 13:20
    t1.inc()                                                     // t1に1分加算
    print(String(format: "t2の時間 👉 %@", t2.toString()))        // 13:21 (t1を変えれば、t2も変わる)
    print(String(format: "t3の時間 👉 %@", t3.toString()))        // 30: 0 ※表現がおかしい
}
/**
 -----------------------------------------------------------------
 ■ 継承によるクラス定義の例
 スーパークラスと同時にプロトコルを指定する場合、先にスーパークラスを書き、その後に
 プロトコルを「,」で区切って書く。
 `class クラス名: スーパークラス名, プロトコル1, プロトコル2`
 スーパークラスのメソッドやプロパティなどを上書きする場合は`override`キーワードを
 つける。
 スーパークラスのプロパティにアクセスするには、まずsuper.initを呼ぶ必要がある。
 スーパークラスのイニシャラザを呼び出しておく。
 `convenience`イニシャライザは、イニシャライザの中で別のイニシャライザを呼ぶ時に
 つけるキーワード。
 -----------------------------------------------------------------
 */

class Time12: Time, CustomStringConvertible {
    var pm: Bool        // 新しいインスタンス変数。午後ならtrue

    /// スーパークラスにはない新しいイニシャライザ
    /// - Parameters:
    ///   - hour: 時間
    ///   - min: 分
    ///   - pm: trueならPM
    init(hour: Int, min: Int, pm: Bool) {
        self.pm = pm
        super.init(hour: hour, min: min)
    }
    /// イニシャライザの中でさらにイニシャライザを呼ぶ
    /// PMかAMかを自動で判定する。
    /// - Parameters:
    ///   - hour: 時間
    ///   - min: 分
    override convenience init(hour: Int, min: Int) {
        let isPm = hour >= 12
        self.init(hour: isPm ? hour - 12: hour, min: min, pm: isPm)
    }

    /// 定した経過時間の新しい時刻を持つTime型を返却
    /// - Parameter min: 分
    override func advance(min: Int) {
        super.advance(min: min)
        // 12時以上であれば、12時未満になるまで変換され続ける
        while hour >= 12 {
            hour -= 12
            pm = !pm
        }
    }
    /// スーパークラスで定義してるtoStringを使用
    var description: String {
        return toString() + " " + (pm ? "PM": "AM")
    }
}

検証: do {
    var t1 = Time12(hour: 18, min: 30, pm: true)
    print(t1)                           // 18:30 PM ※おかしな時間表現になっている。。

    var t2 = Time12(hour: 50, min: 00)  // 50時00分
    t2.advance(min: 10)                 // 10分加算
    print(t2)                           //  2:10 AM ※advanceで12未満なるまで変換され続けるため、深夜2:10という表現になる
}

/**
 -----------------------------------------------------------------
 ■ 動的結合とキャスト
 演算子isは、`インスタンス is 型`と記述し、インスタンスが右側の型またはそのサブクラスで
 あればtrueを返す。また、Swiftでキャストするときは `インスタンス as 型`と記述し、
 他の書き方で`as?, as!`などもある。`as?`であれば、キャストが正しく行われた場合
 にはインスタンス自身を返すが、失敗した場合`nil`を返す。
 つまり、返す型は`オプショナル型`だということ。
 -----------------------------------------------------------------
 */
Time型とTime12型を扱う: do {
    var array = [Time]()
    array.append(Time(hour: 13, min: 10))
    array.append(Time12(hour: 13, min: 20))
    array.append(Time12(hour: 1, min: 30, pm: true))

    for t in array {
        // Time12型ならprintを使う
        if t is Time12 {
            print(t)
        // そうでなければ先頭に">"を印字
        } else {
            print("Time12型ではないよ 👉 ", t.toString())
        }
    }

    // オプショナル束縛構文で出力する
    if let u = array[2] as? Time12 {
        print(u.pm ? "PM": "AM")                // Time型をTime12型にキャストして扱う
    }

    // オプショナル束縛構文でnilだから出力されない
    if let v = array[0] as? Time12 {
        print(v.pm ? "PM": "AM")                // Time12型ではないから、出力されない
    }
}

/**
 -----------------------------------------------------------------
 ■ クラスメソッドとクラスプロパティ
 構造体と列挙型にはタイプメソッドとタイププロパティがあり、その型に関係する手続き
 や値を定義することができた。これらを書く時`static`をつけていた。
 クラスの場合、タイプメソッドとタイププロパティを書く時に`class`をつけると、継承
 したサブクラスで定義を上書きできる。それらのことをクラスメソッド、クラスプロパティ
 と呼ぶ。（`class`とつけないタイプメソッドやタイププロパティは上書きできない）

 -----------------------------------------------------------------
 */
クラスメソッドとクラスプロパティの例: do {
    // アクセス修飾子を省略した場合は「internal」になる。
    class SuperA: CustomStringConvertible {
        static var className : String { return "A" }        // 計算型タイププロパティ
        static var total = 0                                // 格納型タイププロパティ
        class var level: Int { return 2 }                   // 計算型クラスプロパティ

        /// - Returns: 1,000を返す
        static func point() -> Int { return 1000 }         // タイプメソッド
        /// - Returns: levelから1引いた値に紐づく文字列を返す
        class func say() -> String {
            return ["1st", "2nd", "3rd"][self.level - 1]    // クラスメソッド
        }
        /// - Returns:
        class subscript(i: Int) -> String {
            return ["令和", "平成", "昭和"][i]                // クラスへの添字付け
        }
        // イニシャライザ
        init() { SuperA.total += 1 }

        /// 出力用
        var description: String {
            return "\(SuperA.total): \(SuperA.className), "
                + "Level=\(SuperA.level), \(SuperA.point())pt, \(SuperA.say())"
        }
    }

    /// <#Description#>
    class SubB: SuperA {
        /// イニシャライザ ※スーパークラスのイニシャライザを呼び出す
        override init() { super.init(); SubB.total += 1 }

        /// 出力用 ※スーパークラスのdescriptinoをオーバーライド
        override var description: String {
            return "\(SubB.total): \(SuperA.className), "
                        + "Level=\(SuperA.level), \(SuperA.point())pt, \(SuperA.say())"
        }
    }

    // 検証
    let a = SuperA()
    print("SuperA 👉 \(a)")     // 1: A, Level=2, 1000pt, 2nd
    let b = SubB()
    print("SubB 👉 \(b)")       // 3: A, Level=2, 1000pt, 2nd
    print(SubB[0])              // 令和

    // ある型(class/struct)のインスタンスを使って型メソッドを呼ぶには type(of:)関数を使わないといけない
    type(of: a).level

    // 呼べない ※Static member 'level' cannot be used on instance of type 'SuperA'
//    a.level

    /// クラスメソッドとクラスプロパティを上書きする
    class SubC : SuperA {
        override class var level: Int { return 2 }
        /// - Returns: levelから1引いた値に紐づく文字列を返す
        override class func say() -> String {
            return ["初級", "中級", "上級"][self.level - 1]
        }
        /// 引数の値によって、「親/子」どちらかのsubscriptを使用
        override class subscript (i: Int) -> String {
            // 引数が3より小さいなら、親クラスのsubscript
            if i < 3 { return super[i] }
            return ["大正", "明治", "慶應"][i - 3]
        }
        /// イニシャライザ ※スーパークラスのイニシャライザを呼び出す
        override init() { super.init(); SubC.total += 1 }

        /// 出力用 ※スーパークラスのdescriptinoをオーバーライド
        override var description: String {
            return "\(SubC.total): \(SubC.className), "
            + "Level=\(SubC.level), \(SubC.point())pt, \(SubC.say())"
        }
    }

    // 検証   
    let aa = SuperA()
    print("SuperA 👉 \(aa)")        // 4: A, Level=2, 1000pt, 2nd
    let c = SubC()
    print("SubC 👉 \(c)")           // 6: A, Level=2, 1000pt, 中級
    print("親のsubscript 👉 \(SubC[2]), 子のsubscript 👉 \(SubC[3])")         // 昭和 大正
}

/**
 -----------------------------------------------------------------
 ■ 継承とメソッド呼び出し
 継承関係にある複数のクラスが存在する場合、インスタンスに対してメソッド呼び出しを
 行った時、どのように振る舞われるか。
 -----------------------------------------------------------------
 */
継承関係のある場合のメソッド呼び出しの例: do {
    class A {
        func show() { print("A") }
        func who()  { show() }       // showの呼び出し
    }

    /// クラスAを継承
    class B: A {
        override func show() { print("B") }
    }

    // 検証
    var a = A()
    var b = B()
    a.who()                         // A
    b.who()                         // B
}

継承関係のある場合のクラスメソッドの呼び出しの例: do {
    class A {
        class func show() { print("A") }
        class func who()  { show() }
    }
    /// クラスAを継承
    class B: A {
        override class func show() { print("B") }
    }

    // 検証
    A.who()                         // A
    B.who()                         // B
}
