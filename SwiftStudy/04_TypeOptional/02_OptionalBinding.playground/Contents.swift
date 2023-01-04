import UIKit

// オプショナル束縛構文

/**
 -----------------------------------------------------------------
 ■ if-let文
 オプショナル型の式の値がnilじゃなかったとき、その値をif文のthen節ですぐに使い
 たいとする。
 ```Swift
 if let y = オプショナル型 {
    処理
 }
 ```
 if, while文の条件部にだけ記述できる特殊な構文で、これを`オプショナル束縛(optional binding)`
 と呼ぶ。または`if-let文`とも呼ばれる。
 -----------------------------------------------------------------
 */
オプショナル型の値があるかないかで処理を分岐する: do {
    let year: Int? = Int("1986")
    // yearがnilでない場合、yearの値が開示され、定数yに代入
    // 同時に、if文の条件判定はtrueになり、定数yを使った処理が実行される。
    // また、定数yはthen節でした参照できない
    if let y = year {
        print("ハレー彗星は\(y + 75)年に来る")        // ハレー彗星は2061年に来る

    // yearがnilの場合、if文の条件はfalseになり、定数yは処理に使うことができない
    } else {
        print("オプショナル型yearに値がありません")
    }
}

オプショナル束縛の命名規則: do {
    let halley: Int? = Int("1986")                  // 定数halleyはオプショナルInt型
    // 元のオプショナル型の変数と同じ名前で定義する(分かりやすいように)
    if var halley = halley {                        // 変数halleyはオプショナルInt型の定数halley値を開示したInt型
        print("ハレー彗星は\(halley)年に来た")          // ハレー彗星は1986年に来た
        halley += 75                                // ここで参照しているのは変数halley
        print("次は\(halley)年だと予想される。")        // 次は2061年だと予想される。
    }
}

オプショナル束縛はif_while以外では使えない: do {
    var y = Int("2022")
//    y    -= 2016        // オプショナル型yの値を開示してないため、コンパイルエラー
    print(y)              // Optional(2022)
}

/**
 -----------------------------------------------------------------
 ■ オプショナル束縛と条件式
 複数個のオプショナル型の値を使って処理を行いたい場合、カンマ「,」で区切って複数の
 記述を並べることができる。条件式は左から順に評価され、いずれかがfalseだった場合、
 処理は行われない。すなわち、この記述ではカンマは`「&&」`のような役割を担っている。
 -----------------------------------------------------------------
 */
複数個のオプショナル束縛: do {
    // どちらもnilじゃなかったら処理が実行される
    if let sapporo = Int("1972"), let nagano = Int("1998") {
        print("\(nagano - sapporo) years")      // 26 years
    }

    var nagano = 1998
    // ①普通のif文, ②オプショナル束縛, ③普通のif文
    if nagano < 2000, let tokyo = Int("2022"), tokyo > nagano {
        print("\(tokyo - nagano) years")        // 24 years
    }
}

/**
 -----------------------------------------------------------------
 ■ guard文
 想定外の状況が発生した場合にその処理から抜け出すための構文として`guard文`がある。
 ```Swift
 guard 条件 else { /* break や return */}
 ```
 条件が`成立しなかった場合`にelse節が実行されるため、`必ずelse節は記述する`。
 else節には「break, return, throw, 戻り値のない関数」などを記述する。通常の
 オプショナル束縛と違う点は、条件のオプショナル束縛に記述した変数を、guard文の後
 続でも使用することができる。用途として、条件を満たさなかった場合は処理を進めない
 時などに有効であり、主にバリデーションチェックなど。
 -----------------------------------------------------------------
 */
guard文の例: do {
    let stock = ["01", "02", "04", "05", "8", "q", "x"]

    for str in stock {
        // 取り出した値が整数でなければ、文字列「??」を結合して出力し、処理を終了する
        guard let v = Int(str) else {
            print(str + "??")
            break
        }
        // 取り出した値を出力する
        print(v, terminator: " ")
    }
    // 1 2 4 5 8 q??
}

guard文を使ったバリデーション: do {

    // checkという名前の関数なのに、combineName関数を呼び出し値を加工しているので、本来はイマイチな設計。（ご愛嬌）
    func check(_ name: String?) -> String {
        // 名前がnilまたは空は不正
        guard let name = name, !name.isEmpty else {
            return "NG(nilまたは空)"
        }
        // 名前が2文字以上、10文字以下でなければ不正
        guard name.count >= 2 && name.count <= 10 else {
            return "NG(1文字以下または10文字以上)"
        }
        // バリデーションチェックに引っ掛からなければ、関数を呼び出し、その返却値をそのまま返却する
        return combineName(name)
    }

    // 名前の前に"山田"という名字を付与して返却する
    func combineName(_ name: String) -> String {
        return "山田" + name
    }

    print(check(""))                       // NG(nilまたは空)
    var b: String?
    print(check(b))                        // NG(nilまたは空)
    print(check("楽"))                     // NG(1文字以下または10文字以上)
    print(check("零一二三四五六七八九十"))     // NG(1文字以下または10文字以上)
    print(check("太郎"))                   // 山田太郎
}

/**
 -----------------------------------------------------------------
 ■ nil合体演算子
 nilだった場合に代わりの値を使うときは
 ```Swift
 オプショナル型の変数 ?? 代わりの値
 ```
 -----------------------------------------------------------------
 */
通常の三項演算子 : do {
    var opv: String? = nil
    print((opv != nil) ? opv! : "default")          // default
}

nil合体演算子: do {
    var opv: String? = nil
    print(opv ?? "default")                         // default

    // 左から順に、値があればそれを出力する
    var first: String? = nil, second: String? = nil, third: String? = nil
    print(first ?? second ?? third ?? "default")    // default

    second = "値を入れました"                          // 値を格納したから、secondが出力される
    print(first ?? second ?? third ?? "default")    // 値を入れました
}

/**
 -----------------------------------------------------------------
 ■ オプショナル型と関数
 -----------------------------------------------------------------
 */
関数の引数にオプショナル型を使う: do {
    /// 名前と年齢を受け取り、紹介文を返却する。名前が取得できない場合はデフォルトとして"名無し"とする。
    /// - Parameters:
    ///   - name: 名前
    ///   - age: 年齢
    /// - Returns: 紹介文
    func nickname(_ name: String?, age: Int) -> String {
        let s = name ?? "名無し"
        return "浪速の\(s) \(age)歳"
    }

    print(nickname("シンデレラ", age: 35))       // 浪速のシンデレラ 35歳
    print(nickname(nil, age: 20))              // 浪速の名無し 20歳

    // オプショナル型の引数であれば、オプショナル型の値を開示せずにそのまま指定できる
    var n: String? = "海賊王"
    print(nickname(n, age: 25))                // 浪速の海賊王 25歳

    n = nil
    print(nickname(n, age: 25))                // 浪速の名無し 25歳
}

/**
 -----------------------------------------------------------------
 ■ 関数のinout引数に指定する
 -----------------------------------------------------------------
 */
関数のinout引数にオプショナルを使う: do {
    /// 引数が空文字ならnilを代入する。
    /// - Parameter p: 文字列
    func makeNil(_ p: inout String?) {
        if let s = p, p == "" { p = nil }   // 変数sは引数がnilじゃないか確認したいだけで、実際は使用してない
    }

    // 検証
    var w: String? = ""                    // 空文字
    makeNil(&w)
    print(w ?? "変数wはnilです")             // 変数wはnilです
}
