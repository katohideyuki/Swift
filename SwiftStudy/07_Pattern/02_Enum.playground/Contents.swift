import UIKit

// 7-2 列挙型

/**
 -----------------------------------------------------------------
 ■ シンプルな列挙型
 ケース名は小文字開始のキャメルケースで記述する。列挙型の名前と「.」で記述する。
 代入先の型が列挙型であると明確なら「.」だけで記述できる。
 -----------------------------------------------------------------
 */
シンプルな列挙型: do {
    enum Direction {
        case up
        case down
        case right
        case left
    }

    let d = Direction.up
    var x: Direction = .right                     // 代入先がDirection列挙型と明確だから「.」の書き方ができる
    print("upとrightは異なるよ 👉 \(d == x)")       // false

    この書き方でもよい: do {
        enum Direction {
            case up, down, right, left
        }
//        let d = .down   // この書き方では変数の型が明確ではないから「.」の書き方はできない
        let d: Direction = .down
        let x: Direction = .down
        print("これは等しいよ 👉 \(d == x)")        // true
    }
}

/**
 -----------------------------------------------------------------
 ■ メソッド定義
 列挙型のケースとそれに依存した手続きを一体のものとして定義する
 -----------------------------------------------------------------
 */
列挙型を使ったメソッド: do {
    enum Direction {
        case up, down, right, left

        /// 時計回りで90°回転する
        /// - Returns: 時計回りで90°回転した向き
        func clockwise() -> Direction {
            // enumで自分自身を使うからselfにする
            switch self {
                case .up:    return .right
                case .down:  return .left
                case .right: return .down
                case .left:  return .up
            }
        }
    }

    // 検証
    let d = Direction.up
    print("upを90°に時計周りした場合は、rightだからfalse 👉 \(d.clockwise() == Direction.down)")                    // false
    // メソッドチェーン？と言うのか分からないけど、それと同じようなことができている。
    print("upを2回90°に時計周りした場合は、downだからtrue 👉 \(d.clockwise().clockwise() == Direction.down)")       //true
}

/**
 -----------------------------------------------------------------
 ■ 値型の列挙型
 列挙型の方を`実体型`と呼ぶ。また各ケースに割り当てられた値を`実体値`と呼ぶ。
 値型の列挙型に記述できるのは`整数、実数、Bool値、文字列リテラル`のみ。
 実体型が整数の場合、リテラルで値を指定しなかったケースは、１つ前のケースの値に`+1`
 した値となる。
 -----------------------------------------------------------------
 */
enumの型がIntのとき_値を指定しなかったら前のケース: do {
    enum Direction: Int {
        case up = 0, down/* 1 */, right/* 2 */, left/* 3 */
    }
    let a = Direction.right
    let b = a.rawValue                  // 2
    let c = Direction.down.rawValue     // 1

    実体値からそれに対応する列挙型のインスタンスを取得: do {
        let b: Direction? = Direction(rawValue: 3)
        print("実体値が3の列挙型インスタンスはleftだからtrueになるよ 👉 \(b! == Direction.left)")         // true
        if let c = Direction(rawValue: 2) {
            print("実体値2の列挙型インスタンスを取得して、その値を出力 👉 \(c.rawValue)")                  // 2
        }
    }
}

// プロトコルCaseIterableを採用すると、列挙型.allCasesメソッドで列挙型のインスタンスを配列で取得できる
関数lockwiseを改良してみる: do {
    enum Direction: Int, CaseIterable {
        case up = 0, right, down, left
        /// 時計回りで90°回転する ※switch文ですべてを列挙する必要がなくなった
        /// - Returns: 計回りで90°回転した向き
        func clockwise() -> Direction {
            let t = (self.rawValue + 1) % 4     // selfはインスタンス自体
            return Direction(rawValue: t)!      // nilにならない
        }
    }

    for e in Direction.allCases {
        print("\(e)を90°したら 👉 \(e.clockwise())")
    }
}

/**
 -----------------------------------------------------------------
 ■ 列挙型に対するメソッドとプロパティ
 列挙型に定義できるプロパティは`計算型のプロパティのみ`。
 -----------------------------------------------------------------
 */
mutating属性を持つ列挙型のメソッド: do {
    enum Direction: Int {
        case up = 0, right, down, left      // 時計回り

        /// 実体値が右が左の水平方向ならばtrue
        var horizontal: Bool {
            switch self {
                case .right, .left: return true
                default: return false
            }
        }
        // 振り返りメモ: mutating ⇨ インスタンスの内容を変更するメソッド
        /// 自分自身の正反対にする
        mutating func turnBack() {
            self = Direction(rawValue: ((self.rawValue + 2) % 4))!
        }
    }
    // 検証
    var d = Direction.left
    print("いまはleftだから実体値は3 👉 \(d.rawValue)")                 // 3
    d.turnBack()
    print("leftからrightに変わったから実体値は1 👉 \(d.rawValue)")       // 1
    print("いまはrightだからtrueになるよ 👉 \(d.horizontal)")           // true
}

/**
 -----------------------------------------------------------------
 ■ 列挙型のイニシャライザとタイプメソッド
 列挙型にも、構造体と同じくタイプメソッド、タイププロパティ、イニシャライザを定義す
 ることができる。キーワード`static`をつければよいだけ。
 イニシャライザでは、`self（自分自身)`に何を代入するか。ということになる。
 -----------------------------------------------------------------
 */
タイププロパティとイニシャライザ: do {
    enum Direction: Int {
        case up = 0, right, down, left
        static var defaultDirection = Direction.up      // 変更可能な初期値 ※意味ある?
        // 初期値でインスタンス化されたDirectionを返却する
        init() {
            self = .defaultDirection
        }
    }

    // 検証
    let beforeVal = Direction()
    print("変更前の初期値 👉 \(beforeVal)")                // up

    // 初期値を変更(right)
    Direction.defaultDirection = .right
    let e = Direction()
    print("変更後の初期値 👉 \(e)")                        // right

    // gはnilかもしれないから if let
    let g = Direction(rawValue: 1)
    if let val = g { print("実体値を元にインスタンス化されたDirection 👉 \(val)")}      // right
}
