import UIKit

// 8-4 クラスと型

/**
 -----------------------------------------------------------------
 ■ クラスと型
 -----------------------------------------------------------------
 */
キャスト演算子: do {
    let r1 = 1 ..< 10                       // r1は、CountableRange<Int>
    let r2 = (1 ..< 10) as Range            // r2は、Range<Int>
    let r3 = (1 ..< 10) as Range<UInt8>     // r3は、Range<UInt8>
    let s = ["John", "Smith"] as Set<String>

    // キャスト前 as キャスト後
    アップキャスト: do {
        let str: String = "String型からAny型へアップキャスト"
        let any: Any = str as Any
    }

    ダウンキャスト_その1: do {
        // type(of: 変数)で型を取得
        let any: Any = "Any型からOptional<String>型へダウンキャスト"
        let str = any as? String
        print(type(of: str))        // Optional<String>
    }

    ダウンキャスト_その2: do {
        let any: Any = "Any型からOptional<String>型へダウンキャストして、中身も取り出す"
        let str = any as! String
        print(type(of: str))        // String
    }
}

/**
 -----------------------------------------------------------------
 ■ メタタイプとダイアミックタイプ
 type(of: 変数)で、その変数が持っている型を表すオブジェクトを値として取得。この
 オブジェクトのことを`ダイナミックタイプ`とか`タイプインスタンス`と呼ぶ。
 `型.self`でもダイナミックタイプを取得できる。
 ダイナミックタイプを`型.Type`と書き表せる型を持っていて、これを`メタタイプ`と呼ぶ。
 ややこしい。
 まぁ、`型.Type`で型情報を取得しているのかな。。
 -----------------------------------------------------------------
 */

クラスのダイナミックタイプを使う例: do {
    class Avatar {
        class func say() { print("Avatar") }            // クラスメソッド
        required init() { }                             // 必須イニシャライザ
    }

    class Player: Avatar {
        override class func say() { print("Player") }   // クラスメソッド
        let name: String
        init(name: String) {
            self.name = name
            super.init()
        }

        required convenience init() { self.init(name: "(none)") }
    }

    検証_1: do {
        var meta: Avatar.Type = Player.self                 // Avatar.Type型の変数にPlayer型の型情報を代入
        meta.say()                                          // Player
        let p: Avatar = meta.init()                         //

        // pがPlayer型ならpをPlayer型にダウンキャストしてnameプロパティを出力
        if type(of: p) === Player.self {
            print( (p as! Player).name )                    // (none)
        }

        let q = Avatar()                                    // Avatarインスタンスを生成
        meta = type(of: q)                                  // Avatarインスタンスからダイナミックタイプを取得
        meta.say()                                          // Avatar
    }
}

/**
 -----------------------------------------------------------------
 ■ 継承とSelf
 どのサブクラスから呼び出されても、「ここで言う`Self`とは、自分自身（あなた）の
 ことだよ。」ってことにする。
 -----------------------------------------------------------------
 */

クラスで使う場合は_メソッドの戻り値の型にSelfと指定するとき以外で使えないらしい: do {

    /** 時間と分を持つクラス */
    class Time {
        var hour = 0, min = 0

        // イニシャライザ
        required init(hour: Int, min: Int) {
            self.hour = hour; self.min = min
        }

        func advance(min: Int) { /* 何かしらの処理 */ }
        func added(min m: Int) -> Self {
            // Slef.init でも type(of: self).init って書いても同じこと
            let newTime = Self(hour: hour, min: min)

            newTime.advance(min: m)
            return newTime
        }
    }
}

/**
 -----------------------------------------------------------------
 ■ AnyObjectとAny
 「クラスのインスタンスなら何でも入れていいよー。あ、でも、構造体とか関数とかは無理
 だからね」ってやつが`AnyObject`。

 「なんでも入れていいよ。クラスでも構造体でも。だからAnyObjectなんて使わなくてい
 いよ」ってやつが`Any`。

 キャストする時、気をつけてね。

 まぁJavaで言うところのObject型みたいなモンだろう。。きっと。
 とりあえずAny使っとこ。
 -----------------------------------------------------------------
 */
var all: [Any] = [ 1, 2, 3, "いち", "に", "さん" ]
    // Optional<Int>にキャストして、値があれば出力
    if let num = all[0] as? Int {
        print(num)        // 1
    }

    if let str = all[4] as? String {
        print(str)        // に
    }
