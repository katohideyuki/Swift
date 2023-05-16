import UIKit

// 9-4 キーパス

/**
 -----------------------------------------------------------------
 ■ キーパス
 オプショナルチェーンで、参照の経路をプログラムに記述していたが、その経路自体をイン
 スタンスとして保存したり、関数の引数に渡したりできる。これをキーパスと呼ぶ。

 キーパス式の形式
 \経路.パス
 ※パスはプロパティ、添字、またはオプしょなるチェーンの連続
 -----------------------------------------------------------------
 */

/// 学生
class Student {
    let name: String            // 名前
    weak var club: Club?        // 弱い参照
    /// イニシャライザ
    /// - Parameter name: 名前
    init(name: String) { self.name = name }
}

/// 先生
class Teacher {
    let name: String            // 名前
    var subject: String? = nil  // 担当教科
    /// イニシャライザ
    /// - Parameter name: 名前
    init(name: String) { self.name = name }
}

class Club {
    let name: String            // 名前
    weak var teacher: Teacher?  // 弱い参照
    var budget = 0              // 予算
    var members = [Student]()   // クラブに参加している学生リスト
    /// イニシャライザ
    /// - Parameter name: 名前
    init(name: String) { self.name = name }

    /// 学生配列に学生を追加
    /// - Parameter p: 学生
    func add(_ p: Student) {
        members.append(p)
        p.club = self
    }

    /// クラブに所属している学生が5人以上で、尚且つ顧問が存在しているかを確認
    /// - Returns: 学生リストが5人以上かつ顧問が存在すればtrue
    func isOfficial() -> Bool {
        return members.count >= 5 && teacher != nil
    }
}

// 検証
// 学生「タロー」
var who: Student? = Student(name: "taro")
// 顧問「サトシ」、担当教科「数学」
var satoshi: Teacher? = Teacher(name: "satoshi")
satoshi!.subject = "math"

// 野球部に「タロー」を所属させる
var baseballClub: Club? = Club(name: "baseball")
baseballClub!.add(who!)
// 野球部の顧問を「サトシ」にする
baseballClub?.teacher = satoshi

ある学生whoがクラブに所属している場合_そのクラブに顧問がいればその顧問の名前を表示する: do {
    if let name = who?.club?.teacher?.name {
        print(name)         // satoshi
    }

    // オプショナルチェーンの経路が代入された変数teacherNamePath
    let teacherNamePath = \Student.club?.teacher?.name

    // 経路が代入された変数を使用
    if let name2 = who?[keyPath: teacherNamePath] {
        print(name2)        // satoshi
    }
}

/**
 -----------------------------------------------------------------
 ■ キーパス式
 [keyPath: キーパス]と添字付けの記法を使う。
 -----------------------------------------------------------------
 */
キーパス式: do {

    /// キャラクター
    struct Explorer {
        let name: String                            // 冒険者の名前
        var items: [String: Int]                    // 所持品と個数
        var ability: (cure: Int, magic: Int)?       // 特殊能力
        /// イニシャライザ
        /// - Parameters:
        ///   - name: 冒険者の名前
        ///   - items: 所持品と個数
        init(_ name: String, items: [String: Int]) {
            self.name = name
            self.items = items
        }
    }

    /// パーティ
    class Party {
        let name: String                // パーティ名
        var members = [Explorer]()      // メンバー
        /// イニシャライザ
        /// - Parameter name: パーティ名
        init(name: String) { self.name = name }
    }

    // 検証
    var party = Party(name: "ラッキーストライク")
    var fighter1 = Explorer("こなた", items: ["剣": 1, "兜": 1])      // キャラクター1
    var fighter2 = Explorer("つかさ", items: ["槍": 1, "薬草": 3])    // キャラクター2
    var fighter3 = Explorer("かがみ", items: ["薬草": 1, "杖": 1])    // キャラクター3

    fighter3.ability = (cure: 10, magic: 20)                        // キャラクター3に特殊能力を付与
    party.members = [fighter1, fighter2, fighter3]                  // キャラクター1 ~ 3をラッキーストライクに追加

    _2人目のメンバーが薬草を持っていた場合_その個数を代入し出力する: do {
        let keypath1 = \Party.members[1].items["薬草"]
        if let n = party[keyPath: keypath1] {
            print("薬草は\(n)個持っています。")
        }
    }

    _3人目のメンバーのアビリティの魔法値があれば_その値を代入し出力する: do {
        let keypath2 = \Party.members[2].ability?.magic
        if let a = party[keyPath: keypath2] {
            print("魔法値は\(a)%です。")
        }
    }

    キーパスを使って_対象のプロパティの値を変更する: do {
        let keypath1 = \Explorer.items["短刀"]
        print("keypath1の型名を取得: \(type(of: keypath1))")      // WritableKeyPath<Explorer, Optional<Int>>

        let keypath2 = \Party.members[2].items["薬草"]
        print("keypath2の型名を取得: \(type(of: keypath2))")      // ReferenceWritableKeyPath<Party, Optional<Int>>

        let keypath3 = \Party.members[1].name
        print("keypath3の型名を取得: \(type(of: keypath3))")      // KeyPath<Party, String>


        // キャラクター3の所持品に「短刀：1」を追加する
        fighter3[keyPath: keypath1] = 1
        print("fighter3の所持品 👉 \(fighter3.items)")           // ["杖": 1, "薬草": 1, "短刀": 1]

        // パーティに所属している3人目のメンバーの所持品に「薬草：5」を追加。
        party[keyPath: keypath2]! = 5
        print(party.members[2].items)                          // ["杖": 1, "薬草": 5]
    }
}
