import UIKit

// 9-2 強い参照の循環

/**
 -----------------------------------------------------------------
 ■ インスタンスが解放できない場合
 お互いが参照しあうような構造は、インスタンスが使われなくなっても、メモリ解放されない
 からやめた方がいい。
 -----------------------------------------------------------------
 */
StudentインスタンスとClubインスタンスが互いに参照しあっている場合: do {

    /// 学生情報
    class Student: CustomStringConvertible {
        let name: String    // 名前
        var club: Club?     // 所属クラブ

        /// イニシャライザ
        /// - Parameter name: 名前
        init(name: String) { self.name = name }

        var description: String {
            var s = "\(name)"
            if let mem = club { s += ", \(mem.name)" }
            return s
        }

        // デイニシャライザ
        deinit { print("\(name): deinit") }
    }

    /// クラブ情報
    class Club {
        let name: String                // クラブ名
        var members = [Student]()       // 所属している学生リスト

        /// イニシャライザ
        /// - Parameter name: 名前
        init(name: String) { self.name = name }

        /// 学生リストに追加し、学生情報の所属クラブを書き換える
        /// - Parameter p: 学生
        func add(_ p: Student) {
            members.append(p)
            p.club = self
        }

        // デイニシャライザ
        deinit { print("Club \(name): deinit") }
    }

    // 検証
    do {
        let tinyClub: Club = Club(name: "昼寝同好会")
        let yuji: Student = Student(name: "ゆうじ")
        /* tinyClub.add(yuji) */        // コメント外して実行すると、相互参照でインスタンスが解放されない。。
        print("\(tinyClub.name): \(tinyClub.members.count)人")
        print(yuji)
    }

    print("end")
}
/**
 昼寝同好会: 0人
 ゆうじ
 ゆうじ: deinit
 Club 昼寝同好会: deinit
 end
 */


/**
 -----------------------------------------------------------------
 ■ 弱い参照
 変数や定数などからクラスのインスタンスを参照すると、リファレンスカウンタが1加算され
 ちゃう。これを強い参照(strong reference)よ呼ぶ。

 参照する側のインスタンス変数にweak修飾子をつけると、参照したときにリファレンスカウ
 ンタが加算されない。これを弱い参照(weak reference)と呼ぶ。

 参照先のインスタンスが不要になったとき、インスタンス変数にはnilが代入されるから、
 varじゃないとダメ。あと、nilが代入されることがあるので、オプショナルにすること。
 -----------------------------------------------------------------
 */
弱い参照の場合: do {
    /// 学生情報
    class Student: CustomStringConvertible {
        let name: String    // 名前
        var club: Club?     // 所属クラブ

        /// イニシャライザ
        /// - Parameter name: 名前
        init(name: String) { self.name = name }

        var description: String {
            var s = "\(name)"
            if let mem = club { s += ", \(mem.name)" }
            return s
        }

        // デイニシャライザ
        deinit { print("\(name): deinit") }
    }

    /// クラブ情報
    class Club {
        let name: String                // クラブ名
        var members = [Student]()       // 所属している学生リスト

        /// イニシャライザ
        /// - Parameter name: 名前
        init(name: String) { self.name = name }

        /// 学生リストに追加し、学生情報の所属クラブを書き換える
        /// - Parameter p: 学生
        func add(_ p: Student) {
            members.append(p)
            p.club = self
        }

        // デイニシャライザ
        deinit { print("Club \(name): deinit") }
    }

    // 検証
    weak var who: Student? = nil
    do {
        let kaz: Student = Student(name: "一美")
        who = kaz           // 弱い参照の変数に値を代入
        print(who!)         // 一美
    }
    print(who ?? "nil")     // nil
}
