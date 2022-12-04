import UIKit

/**
 -----------------------------------------------------------------
 ■ 構造体の定義
 `構造体(Structure)は値型のデータ`。代入や関数呼び出しの際に、データの実態がコ
 ピーされ、新しいインスタンスが渡される。構造体のデータの実態は、常にプログラム内
 のどこか1箇所から参照されているだけ。
 構造体に定義した定数や変数は`プロパティ(property)`と呼ぶ。また、メソッドなども
 記述でき、これらを含めて`メンバ`と呼ぶ。
 -----------------------------------------------------------------
 */
構造体の簡単な定義例: do {
    struct SimpleDate {
        var year: Int       // 年
        var month: Int      // 月
        var day: Int        // 日
    }
}

/**
 -----------------------------------------------------------------
 ■ 構造体の初期値
 初期化のために使用する手続きを一般に`イニシャライザ(initializer)`と呼ぶ。Javaで
 言うところのコンストラクタである。構造体ごとに独自に定義することができ、これを
 `カスタムイニシャライザ`と呼ぶ。カスタムイニシャライザが定義されていない場合。自
 動的にシンプルなイニシャライザが利用可能。
 初期値がすべてのプロパティに与えられている場合、型名に実引数なしのリスト()を続け
 た形の式でインスタンスを生成する。これを`既定イニシャライザ(default initializer)`
 と呼ぶ。
 -----------------------------------------------------------------
 */
既定イニシャライザ: do {
    struct SimpleDate {
        var year  = 2010    // 年
        var month = 7       // 月
        var day   = 28      // 日
    }
    var d = SimpleDate()    // 日付 2010年7月28日を持つインスタンスを生成
    d.day = 30              // 値を再代入
    print("\(d.year)年\(d.month)月\(d.day)日")     // 2010年7月30日
}

/**
 -----------------------------------------------------------------
 ■ 全項目イニシャライザ
 構造体に対してイニシャライザを定義していない場合、既定イニシャライザに加え、個々
 のプロパティの値を指定してインスタンスを生成するイニシャライザが利用できる。これ
 を`全項目イニシャライザ(memberwise initializer)`と呼ぶ。また、キーワードは
 `プロパティ名が宣言されている順序`で現れる必要がある。
 初期値が与えられているプロパティは、別の値を指定することもできるし、指定しなければ
 初期値そのまま使われる。
 -----------------------------------------------------------------
 */
全項目イニシャライザ: do {
    struct AnotherDate {
        var month, day: Int // インスタンス生成時に値をセットする
        var year = 1998     // 初期値あり
    }
    var move = AnotherDate(month: 5, day: 6, year: 2020)    // 初期値は使わず、値を指定
    var camp = AnotherDate(month: 8, day: 8)                // プロパティが宣言されている順番
    print(move)     // AnotherDate(month: 5, day: 6, year: 2020)
    print(camp)     // AnotherDate(month: 8, day: 8, year: 1998)
}

/**
 -----------------------------------------------------------------
 ■ 構造体を定数に代入した場合
 定数letに代入された構造体のインスタンス、各プロパティの値を変更できない。この制
 約は構造体が`値型`のためである。
 -----------------------------------------------------------------
 */
定数eventに代入された構造体はいずれのプロパティも変更できない: do {
    struct SimpleDate {
        var year: Int       // 年
        var month: Int      // 月
        var day: Int        // 日
    }
    // 定数にインスタンを格納
    let event = SimpleDate(year: 2000, month: 9, day: 13)

    // いすれも値を更新できない
//    event.day   = 1999
//    event.month = 8
//    event.day   = 12
    
    print(event)            // SimpleDate(year: 2000, month: 9, day: 13)
}

/**
 -----------------------------------------------------------------
 ■ 構造体の定数プロパティ
 定義内で定数に初期値が与えられている場合、全項目イニシャライザで改めて初期値を指
 定することはできない。

 全項目イニシャライザのルール
 1. 引数キーワードは、プロパティが定義されている順に並べる
 2. 初期値が設定されていない変数プロパティ、定数プロパティは、イニシャライザで必ず
    値をセットする。
 3. 初期値が設定されている変数プロパティは、イニシャライザの引数としてセットしなくて
    もよい。
 4. 初期値が設定されている定数プロパティは、イニシャライザで値をセットし直すことはで
    きない。（上書きできない）
 -----------------------------------------------------------------
 */
定数プロパティを含む構造体: do {
    struct Time {
        let in24h: Bool = false                     // 24時制 or 12時制
        var hour = 0, min = 0
    }
    var t1 = Time()                                 // 0:00(12時制)
    print(t1)                                       // Time(in24h: false, hour: 0, min: 0)

//    var t2 = Time(in24h: true, hour: 7, min: 0)   // コンパイルエラー。定数の値は更新できないため。
    var t2 = Time(hour: 7, min: 0)                  // 成功。
    print(t2)                                       // Time(in24h: false, hour: 7, min: 0)
}

初期値の与えられていない定数プロパティを含む構造体: do {
    struct Time {
        let in24h: Bool                             // 24時制 or 12時制
        var hour = 0, min = 0
    }
    var t3 = Time(in24h: true, hour: 7, min: 0)     // 成功。
    print(t3)                                       // Time(in24h: true, hour: 7, min: 0)
}

/**
 -----------------------------------------------------------------
 ■ イニシャライザの定義
 `init`というキーワードを記述してイニシャライザであることを明示する。イニシャライザ
 のコードブロックには初期化のための手続きを記述する。プロパティは識別子だけで指定
 しても構わないが、構造体のプロパティであることを明示するため、`self`を使って、
 self.yearのように記述することもできる。なお、イニシャライザ内で構造体のメソッド
 を使うことができるのはすべてのプロパティの初期設定が済んでから。従って、メソッドを
 使ってプロパティの初期値を決めることはできない。
 -----------------------------------------------------------------
 */
構造体でイニシャライザを定義: do {
    struct SimpleDate {
        var year, month, day: Int
        init() {
            self.year = 2095; self.month = 10; self.day = 31
        }
    }
    // インスタンス生成とともに、カスタムイニシャライザが動作しプロパティに値が格納される。
    print(SimpleDate()) // SimpleDate(year: 2095, month: 10, day: 31)
}

/**
 -----------------------------------------------------------------
 ■ 複数個のイニシャライザ
 initは複数定義可能。ただし、シグニチャは重複していないこと。
 -----------------------------------------------------------------
 */
イニシャライザのオーバーロード: do {
    struct Time {
        let in24h: Bool     // 初期値なし
        var hour = 0, min = 0

        // イニシャライザ その1
        init(hour: Int, min: Int) {
            in24h = false
            self.hour  = hour
            self.min   = min
        }

        // イニシャライザ その2
        init(hourIn24 h: Int) {
            in24h = true
            hour  = h
        }

        // イニシャライザ その3
        init(_ hour: Int) {
            self.init(hourIn24: hour)       // イニシャライザその2を使用
        }
    }

    // インスタンス生成
    var a = Time(hour: 10, min: 30)         // その1
    var b = Time(hourIn24: 15)              // その2
    var c = Time(1)                         // その3
//    var d = Time()                                // コンパイルエラー。こんなイニシャライザは定義してないため。
//    var e = Time(in24h: true, hour: 13, min: 30)  // コンパイルエラー。こんなイニシャライザは定義してないため。

    // 出力
    print("a = \(a), b = \(b), c = \(c)")
    // a = Time(in24h: false, hour: 10, min: 30), b = Time(in24h: true, hour: 15, min: 0), c = Time(in24h: true, hour: 1, min: 0)

}

/**
 -----------------------------------------------------------------
 ■ 他の構造体をプロパティに持つ構造体
 -----------------------------------------------------------------
 */
構造体をプロパティに持つ例: do {
    // 構造体 その1
    struct SimpleDate {
        var year, month, day: Int
        init() {
            self.year = 2095; self.month = 10; self.day = 31
        }
    }
    // 構造体 その2
    struct Time {
        let in24h: Bool
        var hour = 0, min = 0
        init(hour: Int, min: Int) {
            in24h = false; self.hour  = hour; self.min   = min
        }
    }

    // 構造体　その3
    struct DateWithTime {
        var date = SimpleDate()             // 構造体をプロパティに持つ
        var time = Time(hour: 0, min: 15)   // 構造体をプロパティに持つ
    }

    var u = DateWithTime()
    print(u.date.year)  // 2095
    print(u.time.min)   // 15
}

/**
 -----------------------------------------------------------------
 ■ 付属型
 構造体の中の構造体を`ネスト型(nested type)`と呼ぶ。また、既存の型名や、構造体
 などとして定義してある型に別の名前を付けて使うことができる。そのためには別名の前
 に`typealias`という宣言をする。たとえば32ビットの整数を表すInt32型に別名とし
 て「SInteger」という名前をつけてプログラムの中で使いたい場合
 `typealias SInteger = int32`とする。これらネスト型や別名宣言(typealias)
 は、`付属型(associated type)`と呼ぶ。
 -----------------------------------------------------------------
 */
構造体におけるネスト型の例: do {
    struct SimpleTime {
        var hour, min: Int
        init(_ hour: Int, _ min: Int) {
            self.hour = hour; self.min = min
        }
    }

    struct PointOfTime {
        // ネスト型
        struct Date {
            var year, month, day: Int
        }
        typealias Time = SimpleTime     // 別名を宣言

        var date: Date      // ネストしたDate型をプロパティに持つ
        var time: Time      // SimpleTime型をプロパティに持つ(別名宣言でTimeとして扱う)

        // イニシャライザでプロパティの構造体をインスタンス化する
        init(year: Int, month: Int, day: Int, hour: Int, min: Int) {
            date = Date(year: year, month: month, day: day)
            time = Time(hour, min)
        }
    }

    var a = PointOfTime(year: 2024, month: 11, day: 7, hour: 14, min: 55)
    print(a.date.month)                                         // 11
    print(a.time.min)                                           // 55

    var b = PointOfTime.Date(year: 2022, month: 11, day: 6)     // ネスト型のみインスタンス化
    print(b.year)                                               // 2022

    a.time = PointOfTime.Time(10, 21)                           // aインスタンスのtimeプロパティを更新
    print(a.time.min)                                           // 21
}
