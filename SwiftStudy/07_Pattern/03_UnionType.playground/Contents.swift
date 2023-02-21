import UIKit

// 7-3 共用型の列挙型

/**
 -----------------------------------------------------------------
 ■ 共用型の列挙型の概要
 意味合いは同じだけど、扱いたい型が違うときに使える？ようなヤツ。いろんな型を扱う
 から実体型（列挙型がどんな型か）を記述できない。いろんな型を扱うから、比較できな
 い。どうしても比較したいときは、==演算子を定義するか、Equatableを採用する。
 共用型の値は、Optionalから値を取り出すみたいに、一手間かけて取り出す必要がある。
 case節の中のletやvarで一度値を取り出す。
 -----------------------------------------------------------------
 */
共用型の列挙型の例: do {
    enum Barcode {
        case UPCA(Int, Int, Int, Int/*Associated Value*/)       // ()の中の値をAssociated Valueと呼ぶ
        case QRCode(String)
    }

    // 検証
    let barcode1 = Barcode.UPCA(8, 85909, 51226, 3)
    let barcode2 = Barcode.QRCode("Hello World")
    let barcodes: [Barcode] = [barcode1, barcode2]              // UPCAもQRCodeをひとまとめにできる

    // 一旦、barcodesを取り出してみる
    for b in barcodes { print(b) }                              // UPCA(8, 85909, 51226, 3), QRCode("Hello World")

    Associated_Valueを取り出してみる: do {
        /// 定義した列挙型であれば、そのAssociated Valueを取り出して出力する
        /// - Parameter barcode: Barcodeの実体値
        func process(barcode: Barcode) {
            switch barcode {
                // Associated Valueを取り出すために、一度定数に格納している。
                case .UPCA(let a, let b, let c, let d):
                    print("UPCAに関連のある値だよ 👉 \(a), \(b), \(c), \(d)")

                // Associated Valueを取り出すために、一度定数に格納している。
                case .QRCode(let str):
                    print("QRCodeに関連のある値だよ 👉 \(str)")
            }
        }
        // 検証
        process(barcode: Barcode.UPCA(11, 22, 33, 44))      // UPCAに関連のある値だよ 👉 11, 22, 33, 44
        process(barcode: .QRCode("あいうえお"))               // QRCodeに関連のある値だよ 👉 あいうえお
    }

    Associated_Valueを取り出す必要がないとき: do {
        /// 定義した列挙型であれば、文字列を出力する。
        /// Associated Valueは使わないから()を省略する。
        /// - Parameter barcode: ケースごとの文字列
            func process(barcode: Barcode) {
                switch barcode {
                    case .UPCA: print("UPCA")
                    case .QRCode: print("QRCode")
                }
            }

        // 検証
        process(barcode: .UPCA(11, 22, 33, 44))             // UPCA
    }
}

// 切符やカードの種類をまとめているが、扱う型を分けている
// いきなり日本語で定義する例がでてきた。。
共用型の列挙型の例2: do {
    enum Ticket {
        case 切符(Int, Bool, 回数券: Bool)                    // 普通券:価格, 小人, 回数券かどうか
        case カード(Int, Bool)                               // プロペイドカード:残高, 小人
        case 敬老パス                                        // 敬老パス

        /// 自分自身の状態を判定して出力する
        func outStatus() {
            switch self {
                    // 切符の場合
                case let .切符(fare, flag, _):
                    print("普通券: \(fare) 👉 " + (flag ? "小人だよ" : "大人だよ"))
                    // カードかつtrueの場合 ※このtrueは条件になる letやvarで受け取れば条件ではなくなる
                case .カード(let r, true) where r < 110:
                    print("カード: 残高不足")
                    // カードかつfalseの場合
                case .カード(let r, false) where r < 230:
                    print("カード: 残高不足")
                case let .カード(fare, flag):
                    print("前にletを置くと変数か定数で受け取る形式になる 👉 \(fare), \(flag)")
                case .敬老パス:
                    print("敬老パス")

            }
        }
    }
    // 検証
    let a = Ticket.切符(500, true, 回数券: true)
    a.outStatus()      // 普通券: 500 👉 小人だよ

    let b = Ticket.カード(100, true)
    b.outStatus()
}

/**
 -----------------------------------------------------------------
 ■ if-case文
 複数の条件のどれかに一致するかではなく、特定の1つの条件にのみ一致するかどうか調べ
 たいとき。
 -----------------------------------------------------------------
 */
if_case文: do {

    enum Ticket {
        case 切符(Int, Bool, 回数券: Bool)                    // 普通券:価格, 小人, 回数券かどうか
        case カード(Int, Bool)                               // プロペイドカード:残高, 小人
        case 敬老パス
    }

    // 検証
    var p = Ticket.カード(230, true)

    一般的な例: do {
        if case .カード = p {
            print("プロペイドカード")
        }
    }

    switch文でも定義できるが_必要ないdefault節を定義しなければならないので面倒: do {
        switch p {
            case .カード: print("プリペイドカード")
            default: break      // 必要ないのに定義しなきゃいけない。。
        }
    }

    複雑な例: do {
        let tickets: [String: Ticket] = ["支倉": .切符(260, false, 回数券: true),
                                         "佐々木": .切符(220, false, 回数券: false)]
        let name = "佐々木"

        // ①オプショナル束縛で定数tにTicket型のインスタンスを取得
        // ②次に定数tが220円の切符かどうか調べる
        if let t = tickets[name]/*①*/, case .切符(220, _ , _) = t/*②*/ {
            print("220円券")
        }

        こんな書き方もできる: do {
            // どういう原理?
            if case .切符(220, _, _)? = tickets[name] {
                print("220円券だよ")
            }
        }
    }
}

/**
 -----------------------------------------------------------------
 ■ for-in文でcaseパターンを使う
 これまでのfor-in文と同様に、配列などのSequenceプロトコルに適合した指揮をinの
 次に置き、インスタンスを次々に取り出します。取り出されたインスタンスとcaseの次の
 パターンが一致した場合にだけ、コードブロックを実行する。
 -----------------------------------------------------------------
 */
for_in文でcaseパターンを使う: do {
    enum Ticket {
        case 切符(Int, Bool, 回数券: Bool)                    // 普通券:価格, 小人, 回数券かどうか
        case カード(Int, Bool)                               // プロペイドカード:残高, 小人
        case 敬老パス
    }

    // 検証
    var passes: [Ticket] = [.切符(200, false, 回数券: false),
                          .カード(300, true),
                          .切符(230, true, 回数券: true),     // これが出力される
                          .敬老パス]

    書き方その1: do {
        // Ticket型の要素を持つ配列passesから次々にインスタンスを取り出し
        // 220円より高い切符の情報を表示する。
        for case let .切符(fare, child, coupon) in passes where fare > 220 {
            var k = coupon ? "回数券": "普通券"
            if child { k += "(小人)" }
            print(k, "\(fare)円")
        }
    }

    書き方その1と同じ意味の書き方: do {
        for t in passes {
            switch t {
                case let .切符(fare, child, 回数券: coupon):
                    if fare > 220 {
                        var k = coupon ? "回数券": "普通券"
                        if child { k += "(小人)" }
                        print(k, "\(fare)円")
                    }
                default: break
            }
        }
    }
}

/**
 -----------------------------------------------------------------
 ■ プロトコルの採用
 -----------------------------------------------------------------
 */
Equatableプロトコルを採用したenum: do {
    enum WebColor: Equatable {
        case name(String)                           // 色の名前
        case code(String)                           // カラーコード
        case white, black, red, blue                // 定番の色
    }

    // 検証
    let indigo = WebColor.name("indigo")            // インディゴ
    let turquoise = WebColor.code("#40E0D0")        // ターコイズ
    print(turquoise == WebColor.code("#40E0D0"))    // true
    print(turquoise == indigo)                      // false
}

/**
 -----------------------------------------------------------------
 ■ 列挙型の付加情報を書き換えるメソッド
 値を変更するには、自分自身(self)に新しいインスタンスを代入して全てを上書きする。
 -----------------------------------------------------------------
 */
付加情報を書き換えるメソッド: do {
    enum Ticket {
        case 切符(Int, Bool, 回数券: Bool)       // 普通券:価格、小人、
        case カード(Int, Bool)
        case 敬老パス

        /// 運賃に対して利用可能かどうか判定。
        /// カードの場合、利用可能ならば残高から運賃を差し引く
        /// - Parameter u: 運賃
        /// - Returns: 利用可能ならばtrue
        mutating func pay(_ u: Int) -> Bool {
            switch self {
                case .切符(let fare, _, _):
                    return u <= fare
                case .カード(let point, let flag):
                    if point < u { return false }       // 早期リターン。残高不足のため ※guradでは分かりづらい
                    self = .カード(point - u, flag)      // 残高から運賃を差し引いた状態を自分自身に上書きする。
                default: break
            }
            return true                                 // カードかつ利用可能ならば到達する行（ちょっと分かりづらいなー）
        }
    }

    // 検証
    var mycard: Ticket = .カード(300, false)                          // 残高300円、大人

    // カードなら、switch文を使わずに残高を表示したい(見づらい。。これなら普通にswitch文を使った方がよい)
    if mycard.pay(260) {
        // カードであれば残高を表示
        if case let .カード(balance, _) = mycard {
            print("利用可能だよ 👉 残高は\(balance)円です。")            // 利用可能だよ 👉 残高は40円です。
        }
        // 切符の場合
        print("利用可能だよ")
    }
    // 2回目のpayメソッド
    if mycard.pay(220) { print("利用可能だよ") }                       // 残高が足りないから出力されない
}

/**
 -----------------------------------------------------------------
 ■ 再帰的な列挙型
 共用型の列挙型で、自分自身を要素として指定したとき。自分自身に該当するcase節の前
 に`indirect`というキーワードをつける。再帰的に行うときに良い？
 -----------------------------------------------------------------
 */
再帰的なデータ構造を許す: do {
    enum message: CustomStringConvertible {
        case DOCUMENTS(String, String)
        case DATA(String, [Int8])
        indirect case FORWARD(String, message)      // 第二引数に自分自身を指定している
        var description: String {
            switch self {
                case let .DOCUMENTS(from, str): return from + "(" + str + ")"
                case let .DATA(from, _):        return from + "[データ]"
                case let .FORWARD(from, msg):   return from + "←\(msg)"
            }
        }
    }

    // 検証
    let m1 = message.DOCUMENTS("伊藤", "休みたい")
    let m2 = message.FORWARD("白石", m1)
    let m3 = message.FORWARD("山田", m2)
    print(m3)       // 山田←白石←伊藤(休みたい)
}
