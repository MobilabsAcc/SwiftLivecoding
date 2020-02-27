import UIKit

// MARK: The bakery

class Bakery {
    let name: String

    init(name: String) {
        self.name = name
    }

    func placeOrder(donut: Donut, toppings: [Topping]) {
        let order = Order(donut: donut, toppings: toppings)
        order.finishReceipt()
    }
}

class Order {
    let donut: Donut
    let toppings: [Topping]

    init(donut: Donut, toppings: [Topping]) {
        self.donut = donut
        self.toppings = toppings
    }

    func finishReceipt() {
        let receiptSum = calculateSum(of: [donut] + toppings)
        print("Receipt for donut sized \(donut.size.rawValue) and \(toppings.count) topping\(toppings.count > 1 ? "s" : "") closed with \(receiptSum) PLN")
    }

    private func calculateSum(of sellableItems: [SellableItem]) -> Double {
        return sellableItems.reduce(0, { $0 + $1.price})
    }
}

protocol SellableItem {
    var price: Double { get }
}

class Donut: SellableItem {
    enum Size: String {
        case standard
        case extraLarge = "extra large"
    }

    let size: Size

    var price: Double {
        switch size {
        case .standard: return 2
        case .extraLarge: return 3.5
        }
    }

    init(size: Size) {
        self.size = size
    }
}

enum Topping: SellableItem {
    case cranberryJam
    case blueberryJam
    case raspberryJam
    case strawberryJam
    case nutella

    var price: Double {
        switch self {
        default:
            return 1
        }
    }
}

let bakery = Bakery(name: "Cukiernia - ACC")

bakery.placeOrder(donut: Donut(size: .extraLarge), toppings: [.blueberryJam, .nutella])
