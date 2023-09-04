import UIKit

// 15-2 動的な関数呼び出しとメンバ探索

/**
 -----------------------------------------------------------------
 ■ データの並びをメソッド呼び出しとみなす
 インスタンスが関数かのように振る舞う
 -----------------------------------------------------------------
 */
dynamicallyCallの簡単な例: do {
    print("------------ dynamicallyCallの簡単な例 ------------")

    @dynamicCallable
    struct ArrayMaker {
        func dynamicallyCall(withArguments list: [Int]) -> [Int] {
            return list
        }
    }

    let am = ArrayMaker()
    let newList = am(1, 2, 3, 5, 8, 11, 13)
    print(newList)      // [1, 2, 3, 5, 8, 11, 13]
}

/**
 -----------------------------------------------------------------
 ■ 引数ラベル付きのメソッド呼び出しのように振る舞う
 dynamicallyCall(withKeywordArguments:)の場合、呼び出しでは引数ラベルを
 指定する。自動側は、実引数とそれに対応する文字列のキーペアとして渡される。
 -----------------------------------------------------------------
 */
dynamicallyCallの実装例: do {
    print("------------ dynamicallyCallの実装例 ------------")

    @dynamicCallable
    class Figure {
        enum Tag: String, CustomStringConvertible {
            case x, y, r, line, width, height           // 許容されるラベルを列挙
            var description: String { self.rawValue }
        }
        var attrs = [Tag: Double]()

        /// Tagに含まれる文字列が引数ラベルだった場合、対応する値を辞書型に格納する
        /// - Parameter dic: 格納する辞書
        func dynamicallyCall(withKeywordArguments dic: [String: Double]) {
            for(elem, dim) in dic {
                // 許容される引数ラベルか？
                if let key = Tag(rawValue: elem) {
                    attrs[key] = dim
                }
            }
        }
    }

    let circle = Figure()
    circle(x: 300.0, y: 160.0, r: 154.5, line: 2.0, fill: 0.0)
    print(circle.attrs)     // [r: 154.5, x: 300.0, line: 2.0, y: 160.0] ※fillはTagにふくまれていないため、格納されない。
}

/**
 -----------------------------------------------------------------
 ■ データ型のメンバを動的に呼び出す
 `@dynamicMemberLookup`属性は、本来定義されていないメンバ（プロパティ）が存在
 しているかのように動作できる。
 ただし、綴り間違いがあったとしても、コンパイラは検知できないので注意する必要がある。
 -----------------------------------------------------------------
 */
subscript_dynamicMemberの実装例: do {
    print("------------ subscript_dynamicMemberの実装例 ------------")

    @dynamicMemberLookup
    struct ArmedAvatar<Value> {
        var base: Value
        var dic = [String: Int]()       // 任意の属性を保持

        subscript<T>(dynamicMember kpath: KeyPath<Value, T>) -> T {
            get { base[keyPath: kpath] }
        }

        subscript(dynamicMember s: String) -> Int {
            get { dic[s] ?? 0 }
            set { dic[s] = newValue }
        }
    }

    struct ExPlorer {
        enum Gender { case male, femail }
        let name: String        // 名前
        let gender: Gender      // 性別
    }


    // 検証
    let exp = ExPlorer(name: "多田光良", gender: .male)
    var avt = ArmedAvatar(base: exp)        // イニシャライザ
    avt.power = 100                         // こんなプロパティはない
    avt.magic = 50                          // こんなプロパティはない
    avt.power += 100
    print("\(avt.name)(\(avt.gender)), P:\(avt.power), M:\(avt.magic)")     // 多田光良(male), P:200, M:50
}

/**
 -----------------------------------------------------------------
 ■ タイププロパティで動的なメンバを実装
 -----------------------------------------------------------------
 */
subscript_dynamicMemberをタイププロパティに対して実装する例: do {
    print("------------ subscript_dynamicMemberをタイププロパティに対して実装する例 ------------")

    @dynamicMemberLookup
    struct Citizen {
        let name: String                            // 名前
        var dic = [String: Int]()                   // 任意の属性を保持
        static var attributes = [String: Int]()     // 属性名と初期値を保持

        static subscript(dynamicMember s: String) -> Int {
            get { Self.attributes[s, default: 0] }
            set { Self.attributes[s] = newValue  }
        }
        subscript(dynamicMember s: String) -> Int {
            get { dic[s, default: Self.attributes[s] ?? 0] }
            set {
                if Self.attributes[s] != nil { dic[s] = newValue}
            }
        }
    }
    // 検証
    var ra = Citizen(name: "朝倉涼子")
    Citizen.magic = 80      // 属性 "magic" を初期値 80 で持つようにする
    Citizen.power = 100     // 属性 "power" を初期値 100 で持つようにする
    ra.power += 100
    ra.skill = 3            // この属性は登録されていない
    print("\(ra.name). P: \(ra.power). M: \(ra.magic), S: \(ra.skill)")     // 朝倉涼子. P: 200. M: 80, S: 0
}
