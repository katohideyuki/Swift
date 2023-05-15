import UIKit

// 9-3 オプショナルチェーン

/**
 -----------------------------------------------------------------
 オプショナル型の値を連続使用する場合
 -----------------------------------------------------------------
 */

弱い参照を使った例: do {
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


    参照の順番に正直にif分で判断していく: do {
        // 学生がクラブに所属している場合、そのクラブに顧問が存在していれば、顧問の名前を表示する
        if who != nil {
            if who!.club != nil {
                if who!.club!.teacher != nil {
                    print(who!.club!.teacher!.name)     // satoshi
                }
            }
        }
    }

    オプショナル束縛で見た目の複雑さを少なくするが_新たに定数の意味を把握する必要がある: do {
        if let w = who, let club = w.club, let tc = club.teacher {
            print(tc.name)                              // satoshi
        }
    }

    オプショナルチェーン: do {
        if let name = who?.club?.teacher?.name {
            print(name)                                 // satoshi
        }
    }/**
      経路の途中で値がnilの場合、オプショナルチェーン自体の値はnilとなる
      */

    辞書データに対してもオプショナルチェーンが活用できる: do {
        var studentCouncil = [String: Student]()        // 生徒会の役員
        studentCouncil["会長"] = Student(name: "日高")

        // 常任委員というキーは追加してないからnilとなり、出力されない
        if let name = studentCouncil["常任委員"]?.name {
            print("常任委員: " + name)
        }
    }

    nilじゃなければメソッドを実行し_nilならばメソッドを実行しない: do {
        var recognized = who?.club?.isOfficial()

        // 最初からオプショナル束縛で書けば良いが、流れを把握するため今回は複数行で書く
        if let recognized = recognized {
            print(recognized)                           // false
        }
    }

    オプショナルチェーンで値を返さないメソッドを呼び出し_メソッドが呼び出されたかnilだったかを確認する方法: do {
        var sena = Student(name: "セナ")

        // nilじゃなかったら値を返さないaddメソッドを実行
        if who?.club?.add(sena) != nil {
            print("whoがnilじゃなく、who.clubもnilじゃなかったから、addメソッドが呼び出されました")
        }
    }

    オプショナルチェーンを代入先にも活用できる: do {
        var someTeacher: Teacher? = Teacher(name: "サブ顧問")
        // whoやwho.clubがnilじゃなければ、teacherに代入する
        // nilの場合も右辺は評価される。
        who?.club?.teacher = someTeacher

        // 代入できたかどうかを確認する方法
        if (who?.club?.teacher = someTeacher) != nil {
            /** 代入できていれば何かしらの処理 */
        }
    }
}


