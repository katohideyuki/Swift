import UIKit

// 8-3 継承とサブクラス

/**
 -----------------------------------------------------------------
 ■ プロパティの継承
 -----------------------------------------------------------------
 */
計算型プロパティの上書きの方法: do {
    class Prop {
        var attr = 0
    }

    class PropA: Prop {
        override var attr: Int {
            get { return super.attr & 1 }               // この「&」は何？ なぜ0か1だけ返却される？
            set { super.attr = newValue }               // 省略できない
        }
    }

    class PropB: Prop {
        override var attr: Int {
            get { return super.attr }                   // 省略できない
            set { super.attr = newValue / 10 * 2 }      // 受け取った値の20%を設定する
        }
    }

    // 検証
    var prop = Prop()
    print("prop 👉 \(prop.attr)")         // 0

    var propA = PropA()
    print("propA 👉 \(propA.attr)")       // 0

    var propB = PropB()
    print("propB 👉 \(propB.attr)")       // 0

    for i in 0 ..< 3 {
        propA.attr = i
        print("なぜ0か1だけ出力される? 👉 \(propA.attr)")  // 0 1 0
    }

    propB.attr = 100
    print("propB 👉 \(propB.attr)")       // 20
}

/**
 -----------------------------------------------------------------
 ■ 添字付けの継承
 -----------------------------------------------------------------
 */

添字付けの継承の例: do {
    class Polygon {
        let count: Int      // 頂点数
        let radius: Double  // 半径
        let points: [(x: Double, y: Double)]

        /// イニシャライザ
        /// - Parameters:
        ///   - apexes: 頂点
        ///   - radius: 半径
        init(apexes: Int, radius: Double) {
            var apx = [(x: Double, y: Double)]()
            let angle = Double.pi * 2.0 / Double(apexes)        // = 2π / 頂点数
            for i in 0 ..< apexes {
                let a = Double(i) * angle
                apx.append((x: cos(a) * radius, y: sin(a) * radius))
            }
            self.count = apexes
            self.radius = radius
            self.points = apx
        }
        subscript (index: Int) -> (x: Double, y: Double) {
            return points[index]
        }
    }

    class Star: Polygon {
        var ratio = 0.5                                         // 内側の頂点の位置を示す
        /// イニシャライザ)
        /// - Parameters:
        ///   - apexes: 頂点
        ///   - radius: 半径
        override init(apexes: Int, radius: Double) {
            super.init(apexes: apexes * 2, radius: radius)      // 頂点数は2倍
        }
        override subscript(index: Int) -> (x: Double, y: Double) {
            let v = super[index]
            if (index & 1) == 0 { return v }
            return (x: v.x * ratio, y: v.y * ratio)             // 奇数番目の頂点を内側にする
        }
    }
}

/**
 -----------------------------------------------------------------
 ■ 継承とプロパティオブザーバー
 -----------------------------------------------------------------
 */
プロパティオブザーバと継承の関係を示す例: do {
    class PropA {
        var attr = 0
    }

    class PropB: PropA {
        override var attr: Int {
            willSet { print("B: will set") }        // ②
            didSet  { print("B: did set") }         // ③
        }
    }

    class PropY: PropB {
        override var attr: Int {
            willSet { print("Y: will set") }        // ①
            didSet  { print("Y: did set") }         // ④
        }
    }
    // 検証
    var g = PropY()
    g.attr = 1                                      // ①~④の順番で呼び出される
}
