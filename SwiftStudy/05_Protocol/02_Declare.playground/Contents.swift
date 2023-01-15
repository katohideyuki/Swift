import UIKit

/**
 -----------------------------------------------------------------
 ■ 宣言の概要
 以下の内容をプロトコルとして定義することができる
 - インスタンスメソッド、タイプメソッド
 - インスタンスプロパティ、タイププロパティ
 - 演算子の関数宣言
 - イニシャライザ
 - 添字付け
 - 付属型宣言(typealias宣言、associatedtype宣言)

 ※ プロトコルは別の宣言内にネストできないため、do構文に記述できない。
 -----------------------------------------------------------------
 */

/// 名前と何か言うメソッドを持つプロトコル
protocol Human {
    var name: String? { get }           // 名前
    func sayHello(to: Human)            // 何か言う
}

/// プロトコルHumanを継承し、肩書きを追加で持つプロトコル
protocol Staff: Human {
    var title: String { get set }       // 肩書き
}

/// 名前と名字を持つプロトコル
protocol Fullname {
    var lastname: String  { get }       // 名字
    var firstname: String { get }       // 名前
}

プロトコルを採用した構造体: do {
    /// プロトコルHumanを採用した構造体
    struct Mob: Human {
        let name: String? = nil         // Humanプロパティ
        /// 挨拶する
        /// ※プロトコルHumanのsayHelloメソッドを実現
        /// ※実現するためにHumanを引数を指定しているが、使っていない。
        /// - Parameter to: Humanを採用したインスタンス
        func sayHello(to: Human){ print("構造体Mobで実現したsayHelloメソッドです。") }
        /// 応援する ※ Humanが持ってないメソッドを追加
        func cheer() { print("がんばれ") }

        /// 名前の一覧を表示する
        /// - Parameter list: Humanを採用したインスタンスを要素とするリスト
        func printNames(list: [Human]) {
            for p in list {
                print((p.name ?? "名無し") + "さん")
                // p.cheer()            // Humanにcheerメソッドは存在しないためコンパイルエラー
            }
        }
    }


    /// プロトコルStaffを採用した構造体
    struct Employee: Staff {
        let name: String?               // Humanプロパティ
        var title: String = ""          // Staffプロパティ

        /// 労いの言葉を伝える
        /// - Parameter p: Humanを採用したインスタンス
        func sayHello(to p: Human) {
            var s = "構造体Staffで実現したsayHelloメソッドです。"
            if let who = p.name { s += who + "さん" } else { s += "名無しさん"}
            print(s)
        }
    }


    /// プロトコルHuman,Fullnameを採用した構造体
    struct Student: Human, Fullname {
        let lastname, firstname: String // Fullnameプロパティ

        /// 名字/名前を結合した文字列を返却する Humanプロパティ
        var name: String? {
            return lastname + firstname
        }

        /// 名前をつけて挨拶する
        /// - Parameter p: Humanを採用したインスタンス
        func sayHello(to p: Human) {
            var s = "構造体Studentで実現したsayhelloメソッドです。"
            if let who = p.name { s += who + "さん" } else { s += "名無しさん" }
            print(s)
        }
    }

    // 検証
    var mob = Mob()
    var employee = Employee(name: "たけし", title: "ボディーガード")
    var student = Student(lastname: "田中", firstname: "太郎")
    mob.sayHello(to: employee)                       // 構造体Mobで実現したsayHelloメソッドです。
    mob.cheer()                                      // がんばれ
    mob.printNames(list: [mob, employee, student])   // 名無しさん たけしさん 田中太郎さん
    employee.sayHello(to: student)                   // 構造体Staffで実現したsayHelloメソッドです。田中太郎さん
    student.sayHello(to: mob)                        // 構造体Studentで実現したsayhelloメソッドです。名無しさん
}
