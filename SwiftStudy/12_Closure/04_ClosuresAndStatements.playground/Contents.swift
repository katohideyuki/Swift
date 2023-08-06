import UIKit

// 12-4 クロージャと強い参照の循環


/**
-----------------------------------------------------------------
 ■ キャプチャによる強い参照
 ローカル変数をキャプチャする時は強い参照になる。そのため、注意しないと参照の循環を
 引き起こす可能性がある。

 [参照の循環]
 参照型の複数のインスタンス同士が強い参照で互いに参照しあうことによって、メモリを
 解放できなくなる現象のこと

 クロージャによる参照の循環が発生するケースは、クロージャがキャプチャしたローカル
 変数が参照型のインスタンスで、しかもそのインスタンスがクロージャを参照している場合。
-----------------------------------------------------------------
 */
_2次元の整数行列を表示する: do {
    print("------------ 2次元の整数行列を表示する ------------")

    /// 2次元の整数データを格納、表示するクラス
    class NumverMatrix {
        let data: [[ Int ]]     // データ
        let maxval: Int         // データの最大値
        var format = { (n: Int) -> String in " \(n)" }  // 桁数整形用クロージャ

        /// データを設定
        /// - Parameter data: データ
        init(data: [[ Int ]]) {
            self.data = data
            // 各行の最大値を求め、それらの最大値を再び求める
            maxval = data.map{ $0.max()! }.max()!
        }

        /// データを1つずつ表示する
        func output() {
            for lin in data {
                for col in lin { print(format(col), terminator: "") }
                print()
            }
        }

        /// データの最大値に対するパーセント表示するクロージャをプロパティformatに代入する
        func makePercent() {
            format = { (n: Int) -> String in
                let m = Int(Double(n * 100) / Double(self.maxval) + 0.5)        // selfにアクセスするため、参照の循環が発生
                return String("   \(m)".suffix(4))                              // 空白を含めて4桁表示する
            }
        }

        // インスタンス解放時の処理
        deinit { print("deinit Matrix") }
    }

    // ■ 検証
    検証1_データを表示してインスタンスを解放する: do {
        print("------------ 検証1_データを表示してインスタンスを解放する ------------")
        let mat = NumverMatrix(data: [[200, 10, 0], [1, 990, 1280]])
        mat.output()
    } /**
       200 10 0
       1 990 1280
      deinit Matrix
      */

    検証2_makePercentを実行してからデータを表示するが_インスタンスは解放されない: do {
        print("------------ makePercentを実行してからデータを表示するが_インスタンスは解放されない ------------")
        let mat = NumverMatrix(data: [ [200, 10, 0], [1, 990, 1280]])
        mat.makePercent()
        mat.output()
    } /**
         16   1   0
          0  77 100
       */
}

/**
 -----------------------------------------------------------------
 ■ キャプチャリストによる解決
 キャプチャリストを指定すると、値のコピーを作成してクロージャ内で利用できる。この
 機能を利用すると、クラスのインスタンスが持つプロパティをクロージャから参照するの
 ではなく、そのコピーをクロージャに渡すことで、参照の循環を回避できる。
 -----------------------------------------------------------------
 */
キャプチャリストを使ったクロージャ: do {
    print("------------ キャプチャリストを使ったクロージャ ------------")

    /// 2次元の整数データを格納、表示するクラス
    class NumverMatrix {
        let data: [[ Int ]]     // データ
        let maxval: Int         // データの最大値
        var format = { (n: Int) -> String in " \(n)" }  // 桁数整形用クロージャ

        /// データを設定
        /// - Parameter data: データ
        init(data: [[ Int ]]) {
            self.data = data
            // 各行の最大値を求め、それらの最大値を再び求める
            maxval = data.map{ $0.max()! }.max()!
        }

        /// データを1つずつ表示する
        func output() {
            for lin in data {
                for col in lin { print(format(col), terminator: "") }
                print()
            }
        }

        /// キャプチャリストを使うことで、参照の循環を防いでいる
        func makePercent() {
            format = { [maxval] (n: Int) -> String in
                let m = Int(Double(n * 100) / Double(maxval) + 0.5)             // selfにアクセスしないため、参照の循環は発生しない
                return String("   \(m)".suffix(4))                              // 空白を含めて4桁表示する
            }
        }

        // インスタンス解放時の処理
        deinit { print("deinit Matrix") }
    }

    検証1_makePercentを実行してからデータを表示してインスタンスを解放する: do {
        print("------------ 検証1_makePercentを実行してからデータを表示してインスタンスを解放する ------------")
        let mat = NumverMatrix(data: [ [200, 10, 0], [1, 990, 1280]])
        mat.makePercent()
        mat.output()
    } /**
         16   1   0
          0  77 100
       deinit Matrix
       */
}

/**
 -----------------------------------------------------------------
 ■ 弱い参照による解決
 前節のやり方では参照の循環を回避できるけど、クロージャ内で参照するプロパティがたく
 さんあった場合、全部列挙しなければいけないから大変。そして面倒。。さらに、値をコ
 ピーして渡すから、クロージャが生成された後でクラスのインスタンスの状態が変化したら
 クロージャの動作に反映できない。

 そのため、以下の2つの機能を使うべし。
 - weak self
 弱い参照としてキャプチャする。クロージャの外部でselfが解放されても、クロージャ内
 ではnilとなる。

 - unowned obj
 非所有参照としてキャプチャする。クロージャの外部でselfが解放された場合、クロージャ
 内でその値を保持せずに使おうとすると実行時エラーとなる。このため、unowned self
 を使用する際は、selfが解放されないことを確実にする必要がある。
 -----------------------------------------------------------------
 */
キャプチャリストによる弱い参照の指定とオプショナル束縛構文: do {
    print("------------ キャプチャリストによる弱い参照の指定とオプショナル束縛構文 ------------")

    /// 2次元の整数データを格納、表示するクラス
    class NumverMatrix {
        let data: [[ Int ]]     // データ
        let maxval: Int         // データの最大値
        var format = { (n: Int) -> String in " \(n)" }  // 桁数整形用クロージャ

        /// データを設定
        /// - Parameter data: データ
        init(data: [[ Int ]]) {
            self.data = data
            // 各行の最大値を求め、それらの最大値を再び求める
            maxval = data.map{ $0.max()! }.max()!
        }

        /// データを1つずつ表示する
        func output() {
            for lin in data {
                for col in lin { print(format(col), terminator: "") }
                print()
            }
        }

        /// キャプチャリスト（弱い参照）を使うことで、参照の循環を防いでいる
        func makePercent() {
            format = { [weak self] (n: Int) -> String in
                guard let self = self else { return " \(n)" }
                let m = Int(Double(n * 100) / Double(self.maxval) + 0.5)        // selfにアクセスしているが、弱い参照なので問題なし
                return String("   \(m)".suffix(4))                              // 空白を含めて4桁表示する
            }
        }

        // インスタンス解放時の処理
        deinit { print("deinit Matrix") }
    }

    検証1_makePercentを実行してからデータを表示してインスタンスを解放する: do {
        print("------------ 検証1_makePercentを実行してからデータを表示してインスタンスを解放する ------------")
        let mat = NumverMatrix(data: [ [200, 10, 0], [1, 990, 1280]])
        mat.makePercent()
        mat.output()
    } /**
         16   1   0
          0  77 100
       deinit Matrix
       */
}

/**
 -----------------------------------------------------------------
 ■ 関数の引数にクロージャを渡す場合
 関数やメソッドの引数としてクロージャを渡す場合、その関数がクロージャをインスタンス
 のプロパティに保存する可能性がある。関数呼び出しが終了した後でも、クロージャが使わ
 れる可能性がある状況をクロージャの離脱、あるいはエスケープと呼ぶ。関数の引数として
 クロージャを受け取り、そのクロージャを変数に保存する場合、
 その引数の方は`@escaping`で修飾する。

 `@escaping属性`は、クロージャを関数の外で保持（エスケープ）することを示すために
 使用されます。つまり、関数のスコープを越えてクロージャが保持される場合に必要となり
 ます。
 -----------------------------------------------------------------
 */
関数setFuncはコンパイルできないけど関数doFuncはできる: do {
    var theFunc: ((Int) -> Int)
//    func setFunc(_ f: (Int) -> Int) { theFunc = f }       // コンパイルエラー
    func doFunc(_ v: Int, _ f: (Int) -> Int) { print(f(v))}
}

次のように定義すれば関数setFuncもコンパイルできる: do {
    var theFunc: ((Int) -> Int)
    func setFunc(_ f:@escaping (Int) -> Int) { theFunc = f }
}
