import UIKit

// 5-3 プロトコルと付属型
/**
 -----------------------------------------------------------------
 ■ 付属型の宣言
 プロトコル内でプロパティを定義するも、どんな型かは採用した側が決めてくれ。という
 時に`associatedtype`というキーワードをつければよい。ジェネリクスでいう<T>み
 たいなモノ。<T>を表現するために名前をつけているようなものだと解釈。
 -----------------------------------------------------------------
 */

protocol SimpleVector {
    // 付属型の宣言(<T>をTypeIsFreeという名前で表現)
    associatedtype TypeIsFree

    // プロパティx, yの型はまだ決まってないよ
    var x: TypeIsFree { get }
    var y: TypeIsFree { get }
}

付属型のあるプロトコルSimpleVectorを採用する: do {
    /// TypeIsFreeをInt型で扱うことに決めた
    struct VectorInt: SimpleVector {
        // TypeIsFreeをInt型で宣言し直す
        typealias TypeIsFree = Int
        var x, y: TypeIsFree
    }

    /// TypeIsFreeを型推論によってDouble型で扱うことに決めた
    struct VectorDouble: SimpleVector, CustomStringConvertible {
        var x, y: Double
        /// プロトコルCustomStringConvertibleを採用したら定義しなきゃいけないヤツ
        var description: String { return "[\(x), \(y)]" }

        /// 付属型を型として使い、プロパティを初期化する
        /// - Parameters:
        ///   - x: Double値
        ///   - y: Double値
        init(x: VectorDouble.TypeIsFree, y: VectorDouble.TypeIsFree) {
            self.x = x; self.y = y
        }

        /// 構造体VectorIntを受け取り、Int型のプロパティをDouble型にキャストしながら初期化する
        /// - Parameter d: 構造体VectorInt
        init(vectorInt d: VectorInt) {
            self.init(x: Double(d.x), y: Double(d.y))
        }
    }

    /// TypeIsFreeという名前の列挙体enumを用意し、要素の型はString型で扱うことに決めた
    struct VectorGrade: SimpleVector, CustomStringConvertible {
        enum TypeIsFree: String { case A, B, C, D, X }
        var x, y: TypeIsFree
        var description: String { return "[\(x), \(y)]" }
    }

    // 検証
    var a = VectorInt(x: 10, y: 12)
    print("VectorIntのプロパティはInt型だよ 👉 [\(a.x), \(a.y)]")     // [10, 12]

    let b = VectorDouble(vectorInt: a)
    print("VectorDoubleのプロパティはDouble型だよ 👉 \(b)")           // [10.0, 12.0]

    var g = VectorGrade(x: .A, y: .C)
    print("VectorGradeのプロパティはenumだよ 👉 \(g)")                // [A, C]
}

/**
 -----------------------------------------------------------------
 ■ 自分自身を表すSelf
 プロトコルの定義`Self`を記述した場合、そのプロトコルを採用したインスタンスの型を
 指す。プロトコル自身ではない。
 -----------------------------------------------------------------
 */

protocol TransVector {
    associatedtype TypeIsFree
    var x: TypeIsFree { get }
    var y: TypeIsFree { get }

    /// 何かしらのメソッドを実現して
    /// - Returns: 新しい自分自身と同じ型のインスタンスを返す
    func transposed() -> Self

    /// 自分自身と同じ型同士を受け取る前提で、+演算子をカスタマイズして
    /// - Parameters:
    ///   - val: 何かしらの値
    ///   - val2: 何かしらの値
    /// - Returns: 新しい自分自身と同じ型のインスタンスを返す
    static func +(lhs: Self, rhs: Self) -> Self
}


/// Selfを使ったプロトコルを採用する ※Selfを利用したプロトコルを採用した場合do構文に記述できない
struct VectorInt: TransVector, CustomStringConvertible {
    typealias TypeIsFree = Int      // TypeIsFreeをInt型で扱うと決めた
    let x, y : Int

    /// プロパティxとyの値を入れ替える
    /// - Returns: 値を入れ替えた新しいVectorIntインスタンス
    func transposed() -> VectorInt {
        return VectorInt(x: self.y, y: self.x)
    }

    /// VectorIntインスタンスを2つ受け取り、それぞれのプロパティ同士を合算
    /// - Parameters:
    ///   - lhs: VectorIntインスタンス
    ///   - rhs: VectorIntインスタンス
    /// - Returns: それぞれのプロパティ同士を合算した新しいVectorIntインスタンス
    static func +(lhs: VectorInt, rhs: VectorInt) -> VectorInt {
        return VectorInt(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    var description: String { return "[\(x), \(y)]" }
}

Selfを使ったプロトコルを採用した検証: do {
    // 検証
    let a = VectorInt(x: 10, y: 3)
    print("値が入れ替わるよ 👉 \(a.transposed())")       // [3, 10]
    let b = VectorInt(x: -1, y: 2)
    print("同じプロパティ同士を合算するよ 👉 \(a + b)")     // [9, 5]
}

/**
 -----------------------------------------------------------------
 付属型が適合するプロトコルを指定
 `Equatable`はSwift標準ライブラリのプロトコルで、適合した型は、互いのの値が等
 しいかどうかを「==」「!=」演算子で判断できるようになる。
 なお、タプルは演算子「==」で比較できるが、`Equatable`プロトコルには適合してな
 いから、適合するには`「==」演算子`を独自で実現しないといけない。
 -----------------------------------------------------------------
 */

/// Equatableを継承して比較可能にする
protocol EqVector: Equatable {
    associatedtype TypeIsFree: Equatable
    var x: TypeIsFree { get }
    var y: TypeIsFree { get }
}


/// StringもIntもEquatableに適合している型なので、問題なし
struct LabeledPoint: EqVector, CustomStringConvertible {
    var label: String
    var x, y: Int       // TypeIsFreeをInt型とする
    var description: String { return "[\(x), \(y)]"}
    // Equatableには自動的に準拠している
    // この場合、すべてのプロパティが同じの場合にtrueとみなす
}

/// タプルはEquatableに適合していないため、「==」演算子を実現しなくてはならない
struct ShopOnMap: EqVector, CustomStringConvertible {
    var shop: (name: String, comment: String?)      // タプル
    var x, y: Float                                 // TypeIsFreeをFloat型とする

    /// イニシャライザ
    /// - Parameters:
    ///   - s: 店名
    ///   - N: 東経
    ///   - E: 北緯
    ///   - comment: 一言コメント ※デフォルトでnil
    init(_ s: String, N:Float, E: Float, comment: String? = nil) {
        shop = (name: s, comment: comment)
        x = E; y = N
    }

    /// CustomStringConvertibleを採用したら実現しなきゃいけないヤツ
    var description: String {
        var r = shop.name + "(N\(y), E\(x))"
        // 一言コメントがあるなら結合する。「店名(N東経, E北緯) 一言コメント」
        if let msg = shop.comment { r += " " + msg }
        return r
    }

    /// ShopMap構造体同士を比較
    /// タプルはEquatableに適合していないため、「==」演算子を実現しなくてはならない。
    /// - Parameters:
    ///   - lhs: ShopOnMap
    ///   - rhs: ShopOnMap
    /// - Returns: すべてのプロパティが同じであればtrue
    static func ==(lhs: ShopOnMap, rhs: ShopOnMap) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

比較可能になるプロトコルEquatableを継承したプロトコルEqVectorを採用した検証: do {
    // LabeledPointの比較はすべてのプロパティが同じの場合にtrueとなる
    let a = LabeledPoint(label: "A", x: 10, y: 7)
    var b = LabeledPoint(label: "B", x: 10, y: 7)
    print("aとbはプロパティ'label'が違うからfalseになるよ 👉 \(a == b)")
    b.label = "A"
    print("aとbはすべてのプロパティが同じだからtrueになるよ 👉 \(a == b)")
    print("反転も可能でfalseになるよ 👉 \(a != b)")

    // ShopOnMapの比較はプロパティ'x'と'y'が同じの場合にtrueとなる
    let shop01 = ShopOnMap("たまや", N: 35.030, E: 135.030, comment: "カレー屋さんだよ")
    let shop02 = ShopOnMap("餅屋", N: 35.030, E: 135.030)
    print("shop01とshop02はプロパティ'x'と'y'が同じだからtrueになるよ 👉 \(shop01 == shop02)")
    print(shop01)   // たまや(N35.03, E135.03) カレー屋さんだよ

}
