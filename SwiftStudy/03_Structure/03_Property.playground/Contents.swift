import UIKit

/**
 -----------------------------------------------------------------
 ■ タイププロパティ
 構造体のタイププロパティは、定義の際に先頭に`static`というキーワードをつける。
 ここまでの説明を踏まえると、staticは`タイプ`と言い換えることができる。
 staticなメソッドを`タイプメソッド`、staticなプロパティを`タイププロパティ`。
 -----------------------------------------------------------------
 */
日付を2通りの形式で表現: do {
    struct DateWithString {
        // 日付を文字列に変換した値
        let str: String
        // 日付（年、月、日）
        let year, month, day: Int
        // タイププロパティ。配列リテラル
        static let mons = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        // タイププロパティ。フォーマットの判定フラグ
        static var longFormat = false

        /// 受け取った年月日とフォーマットの真偽値によって、プロパティをセットする。
        /// - Parameters:
        ///   - y: 年
        ///   - m: 月
        ///   - d: 日
        init(_ y: Int, _ m: Int, _ d: Int) {
            year = y; month = m; day = d
            // フォーマットの真偽値によって、日付を表す文字列のフォーマットの判定
            str = DateWithString.longFormat
                ? DateWithString.longString(y, m, d)    // 年-月-日フォーマット
                : DateWithString.shortString(y, m, d)   // 日月年フォーマット
        }

        /// 引数が1桁であれば0埋めし、2桁以上であれば何もしない。
        /// - Parameter n: 整数
        /// - Returns: 整数（1桁であれば0埋め)
        static func twoDigits(_ n: Int) -> String {
            let i = n % 100
            return i < 10 ? "0\(i)" : "\(i)"
        }

        /// 年月日を「年-月-日」で表現した文字列を返却する。
        /// - Parameters:
        ///   - y: 年
        ///   - m: 月
        ///   - d: 日
        /// - Returns: 年月日の文字列
        static func longString(_ y: Int, _ m: Int, _ d: Int) -> String {
            return "\(y)-" + twoDigits(m) + "-" + twoDigits(d)
        }

        /// 年月日を「日月年」で表現した文字列を返却する。
        /// なお、月は英字表記となる。
        /// - Parameters:
        ///   - y: 年
        ///   - m: 月
        ///   - d: 日
        /// - Returns: 年月日の文字列
        static func shortString(_ y: Int, _ m: Int, _ d: Int) -> String {
            return twoDigits(d) + mons[m-1] + twoDigits(y)
        }
    }

    let a = DateWithString(2025, 1, 20)     // 20Jan25
    print(a.str)
    DateWithString.longFormat = true        // フォーマットの真偽値を切り替える
    let b = DateWithString(2025, 1, 21)
    print(b.str)                            // 2025-01-21
}

/**
 -----------------------------------------------------------------
 ■ 格納型プロパティの初期値を式で設定する
 例として、stdHeightの値を1200に変更した上で、display2インスタンスを生成してい
 る。その際、stdHeightの値が1200に変更された状態でLCDのインスタンスが生成されて
 いる。
 しかし、同様にstdWidthに値を2560に変更した上で、display3インスタンスを生成した
 場合、2560は反映されない。
 説明しづらいので、詳細は省略するが`タイププロパティの初期化のための式は、値が必要と`
 `されて評価され、それは使われない`ことが原因。stdSizeはdisplay2を生成するときに
 初めて必要とされて値が`定数に差がまり`、その後は再評価されない。
 イニシャライザで初期化をするときに見ているのは、stdSizeということがポイント。
 この例題が分かりづらい気がする。このような実装が活きる時はあるのか。。。
 -----------------------------------------------------------------
 */
// doスコープ内に定義するとアクセスできないので、外側に出す
var serialNumber = 2127

タイププロパティの初期値の設定: do {
    struct LCD {
        struct Size { var width, height : Int }     //  ネスト型
        static var stdHeight = 1080     // 初期値
        static var stdWidth  = 1920     // 初期値
        static var stdSize   = Size(width: stdWidth, height: stdHeight)     // 初期値が設定されたタイププロパティ

        static func sn() -> Int { serialNumber += 1; return serialNumber }
        let size: Size
        let serial = "CZ:" + String(LCD.sn())
        // 引数に規定値があるイニシャライザ(widht, heightの指定がなければ初期値が設定されたstdSizeでインスタンスが生成される)
        // 引数にSize型が渡されなければ、stdSizeが代入される
        init(size: Size = LCD.stdSize) { self.size = size }

        func show() {
            print(serial, "(\(size.width)x\(size.height))")
        }
    }

    let display1 = LCD(size: LCD.Size(width: 800, height: 600))
    display1.show()     // CZ:2128 (800x600)

    LCD.stdHeight = 1200
    let display2 = LCD()
    display2.show()     // CZ:2129 (1920x1200)

    // display2の時点でstdSizeが初めて評価され、stdSize(width: 1920, height: 1200)になっている
    // 以下のLCD.stdWidthで値を2560で代入しようと、stdSizeの値は(width: 1920, height: 1200)になっているので
    // display3には2560の値は反映されない。だって、LCDのイニシャライザはstdSizeを見ていて、stdWidthは初回以降見てないから。
    // stdWidthは初めて評価されたときしか見ないから。
    LCD.stdWidth = 2560
    let display3 = LCD()
    display3.show()     // CZ:2130 (1920x1200)
    print(LCD.stdWidth) // 2560
}

/**
 -----------------------------------------------------------------
 ■ 計算型プロパティ
 値の参照と更新の機能を手続きで構成するプロパティで、アクセスする側からは格納型プロ
 パティと区別なく利用できる。計算型プロパティには、値の参照と更新の両方できる場合と
 参照だけができるものがある。参照だけの場合でも、先頭に`var`を記述する。これは、
 `参照によって返される値が常に一定とは限らないことに対応している。`参照した結果の値
 を計算するのが`get`、指定された値を使ってプロパティ値を更新するのが`set`。setに
 は、指定した値を受け取る仮引数を指定できるが省略も可能。省略した場合、`newValue`
 という名前の引数があるものとして利用できる。
 -----------------------------------------------------------------
 */
ゲッターとセッターの動き: do {
    struct Sample {
        var result: String = "result"        // 初期値
        static let A  = "A"

        /// 引数を計算型プロパティresultにsetする
        /// - Parameter str: 文字列
        init(str: String) {
            self.getSet = str      // 計算型プロパティのsetを使って値を設定
        }

        // 計算型プロパティの定義
        // ① get経由でresultから値をゲットするときは、resultに文字列「B」が結合された上でresultを取得する
        // ② setを使って値をresultにセットするときは、受け取った文字列に「A」が結合された上でresultに代入する
        var getSet: String {
            get { result + "B" }
            set { result = newValue + Sample.A }  // newValueにはinitで受け取った引数が入っている
        }
    }

    // 検証1 getとsetそれぞれの動きを確認する
    var a = Sample(str: "C")            // setを経由してresultに値を代入しているため、文字列「A」が付与される
    print("result : \(a.result)")       // result : CA ※getを経由せず、直接プロパティにアクセスしている
    print("result : \(a.getSet)")       // result : CAB ※getを経由してresultを取得しているため、「B」が付与される

    // 検証2 +=演算子を用いてgetとsetを同時に使用する
    var b = Sample(str: "X")            // setを経由してresultに値を代入しているため、文字列「A」が付与される
    print("result : \(b.result)")       // result : XA ※getを経由せず、直接プロパティにアクセスしている
    b.getSet += "Y"                     // 取得と代入を同時に行なった場合、先にgetが動いて、その後setが動く、つまり右記の通りになる ---> (XA + B) + (Y + A)
    print("result : \(b.result)")       // result : XABYA
}

/**
 -----------------------------------------------------------------
 ■ 関数のinout引数にプロパティを渡す

 -----------------------------------------------------------------
 */
ほげ: do {
    struct Sample {
        var result: String = "result"        // 初期値
        static let A  = "A"

        /// 計算型プロパティを経由してresultを初期化する
        /// - Parameter str: 文字列
        init(str: String) {
            self.getSet = str
        }

        // 計算型プロパティの定義
        var getSet: String {
            get { result + "B" }
            set { result = newValue + Sample.A }
        }
    }

    var a = Sample(str: "A")
    var b = Sample(str: "B")
    print("a : \(a.result), b : \(b.result)")       // a : AA, b : BA
    // インスタンスを指定して、構造体を交換する  ※「&」は実引数
    swap(&a, &b)                                    // 渡された値を入れ替える関数。Swiftの標準ライブラリ
    print("a : \(a.result), b : \(b.result)")       // a : BA, b : AA

    // 格納型プロパティを指定しても問題ない
    swap(&a.result, &b.result)
    print("a : \(a.result), b : \(b.result)")       // a : AA, b : BA

    // 計算型プロパティを指定しても問題ない  ※計算された後に値が交換される
    swap(&a.getSet, &b.getSet)
    print("a : \(a.result), b : \(b.result)")       // a : BABA, b : AABA

    // 計算型プロパティと通常の変数を指定しても問題ない
    var special = "★"
    swap(&a.result, &special)
    print("\(a.result), \(special)")                // ★, BABA
}

/**
 -----------------------------------------------------------------
 ■ プロパティオブザーバ
 プロパティの値が更新されることをきっかけに、何かしらの処理を行うこと。この仕組みを
 `プロパティオブザーバ`と呼ぶ。値を格納する前に処理を行いたい場合、`willSet`を、
 値を格納した後に処理を行いたい場合、`didSet`を記述する。
 どちらも仮引数を省略した場合、willSetの場合は`newValue`で変更される後の新しい
 値にアクセスでき、didSetの場合は`oldValue`で変更される前の値にアクセスできる。
 -----------------------------------------------------------------
 */
プロパティオブザーバの使用例: do {
    struct Stock {
        let buyingPrice: Int                        // 買値
        var high = false                            // 現在価格が買値より高いかどうか
        var count = 0                               // プロパティ値の変更回数

        /// イニシャラザ
        /// - Parameter price: 買値
        init(price: Int) {
            buyingPrice = price
            self.price  = price                     // イニシャラザからはオブザーバは呼び出されない
        }

        // プロパティオブザーバ
        var price: Int {
            willSet {
                count += 1
                high   = newValue > buyingPrice     // 値の格納前に、更新後の値が買値より高いかどうか判定
            }
            didSet {
                print("\(oldValue) => \(price)")    // 値を格納したら変更前と変更後の値を出力
            }
        }
    }

    var st = Stock(price: 400)
    st.price = 410      // 400 => 410に変更
    st.price = 380      // 410 => 380に変更
    st.price = 430      // 280 => 430に変更
    print("値が更新された回数 : \(st.count), 現在価格は買値より高いかどうか : \(st.high)")      // 3, true
}
