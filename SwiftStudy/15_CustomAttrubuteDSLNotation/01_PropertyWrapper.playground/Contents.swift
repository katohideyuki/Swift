import UIKit

// 15-1 プロパティラッパ

/**
 -----------------------------------------------------------------
 ■ 簡単なプロパティラッパの定義
 基本的に、イニシャライザinit(wrappedValue:)と計算型プロパティwrappedValue
 を記述する。
 プロパティラッパを適用したいプロパティ定義の直前に`@`を先頭に付けたプロパティラッパ
 の名前を属性として置く。
 プロパティにはletは使えず、varで宣言しなければならない。
 -----------------------------------------------------------------
 */

/// イニシャライザの際に暫定的に値を設定した後、1度だけ値を設定し直すことができる
@propertyWrapper
struct Makeshift<Value> {
    private var value: Value
    private var setFlag = false     // 値再設定フラグ

    /// イニシャライザ
    /// - Parameter v: 暫定的な初期値
    init(wrappedValue v: Value) {
        value = v
    }

    /// 計算型プロパティ
    var wrappedValue: Value {
        get { value }
        set {
            // すでに再設定していた場合、エラーとする。
            if setFlag { fatalError("値はすでに設定されています") }
            // 再設定
            value = newValue
            setFlag = true
        }
    }
}


/// レースに出走するまではとりあえず誰かが運転して調整するが、レースが始まったらドライバを変更したり、燃料を追加してはいけない
struct RacingCar {
    @Makeshift var driver = "(テストドライバ)"
    @Makeshift var fuelTank = 2.0               // 調整のための燃料

    /// テストドライバと燃料を出力
    func testRun() {
        print("ドライバ=\(driver), 燃料=\(fuelTank)")
    }

    /// レースドライバと燃料を出力
    /// - Parameters:
    ///   - name: ドライバ名
    ///   - fuel: 燃料
    mutating func race(_ name: String, fuel: Double = 100.0) {
        driver = name
        fuelTank = fuel
        print("ドライバ=\(driver), 燃料=\(fuelTank)")
    }

    /// ピットイン（実行時にエラーを起こす用）
    mutating func pitStop() {
        driver = "代理"       // 2回目の値再設定となり、実行時エラーとなる
        fuelTank += 12.0
    }
}

// 検証
print("------------ 簡単なプロパティラッパの定義 ------------")
var f1 = RacingCar(fuelTank: 1.5)
f1.testRun()           // ドライバ=(テストドライバ), 燃料=1.5
f1.race("相良宗介")     // ドライバ=相良宗介, 燃料=100.0
//f1.pitStop()           // __lldb_expr_1/01_PropertyWrapper.playground:33: Fatal error: 値はすでに設定されています
