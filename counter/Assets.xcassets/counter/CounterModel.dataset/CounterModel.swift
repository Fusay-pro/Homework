import Foundation
import Combine

@MainActor
final class CounterModel: ObservableObject {

    // MARK: - Core Game State

    @Published private(set) var value: Int = 0
    @Published private(set) var coins: Int = 0

    // 1,2,4,8,...
    @Published private(set) var powerLevel: Int = 1
    var clickPower: Int { powerLevel }

    // ✅ Injected randomness for tests (default = real randomness)
    var randomRoll: () -> Double = { Double.random(in: 0..<1) }

    // MARK: - Power Upgrade

    @Published private(set) var powerUpgradeCount: Int = 0

    var powerUpgradeCost: Int {
        let base = 50.0
        let mult = 2.2
        return max(1, Int((base * pow(mult, Double(powerUpgradeCount))).rounded(.up)))
    }

    var nextClickPowerGain: Int { powerLevel }
    var canBuyPowerUpgrade: Bool { coins >= powerUpgradeCost }

    func buyPowerUpgrade() {
        guard canBuyPowerUpgrade else { return }
        coins -= powerUpgradeCost
        powerUpgradeCount += 1
        powerLevel *= 2
    }

    // MARK: - Critical Click

    @Published private(set) var critUnlocked: Bool = false
    @Published private(set) var critLevel: Int = 0

    var critUnlockCost: Int { 500 }

    var critUpgradeCost: Int {
        let base = 400.0
        let mult = 1.9
        return max(1, Int((base * pow(mult, Double(critLevel))).rounded(.up)))
    }

    var critChance: Double {
        let chance = 0.10 + (Double(critLevel) * 0.02)
        return min(0.60, max(0.0, chance))
    }

    var critMultiplier: Double {
        let mult = 2.0 + (Double(critLevel) * 0.25)
        return min(6.0, max(1.0, mult))
    }

    var canBuyCritUnlock: Bool { !critUnlocked && coins >= critUnlockCost }
    var canBuyCritUpgrade: Bool { critUnlocked && coins >= critUpgradeCost }

    func buyCritUnlock() {
        guard canBuyCritUnlock else { return }
        coins -= critUnlockCost
        critUnlocked = true
    }

    func buyCritUpgrade() {
        guard canBuyCritUpgrade else { return }
        coins -= critUpgradeCost
        critLevel += 1
    }

    // MARK: - Manual Click (with Critical)

    func manualClick() {
        let gained = computeManualClickGain()
        value += gained
        coins += gained
    }

    private func computeManualClickGain() -> Int {
        let base = clickPower
        guard critUnlocked else { return base }

        let roll = randomRoll()   // ✅ instead of Double.random(...)
        if roll < critChance {
            let critValue = Int((Double(base) * critMultiplier).rounded(.up))
            return max(base, critValue)
        } else {
            return base
        }
    }

    // MARK: - Auto Click

    @Published private(set) var autoClickEnabled: Bool = false
    @Published private(set) var autoUnlockPurchased: Bool = false

    @Published private(set) var autoClickInterval: Double = 2.0
    @Published private(set) var autoSpeedLevel: Int = 0

    @Published private(set) var autoClickPower: Int = 1
    @Published private(set) var autoPowerLevel: Int = 0

    private var timer: Timer?

    var autoUnlockCost: Int { 200 }
    var canBuyAutoUnlock: Bool { !autoUnlockPurchased && coins >= autoUnlockCost }

    func buyAutoUnlock() {
        guard canBuyAutoUnlock else { return }
        coins -= autoUnlockCost
        autoUnlockPurchased = true
        autoClickEnabled = true
        startAutoClickIfNeeded()
    }

    var nextAutoInterval: Double {
        max(0.2, autoClickInterval * 0.85)
    }

    var autoSpeedCost: Int {
        let base = 150.0
        let mult = 1.8
        return Int((base * pow(mult, Double(autoSpeedLevel))).rounded(.up))
    }

    var canBuyAutoSpeedUpgrade: Bool {
        autoUnlockPurchased && coins >= autoSpeedCost && autoClickInterval > 0.2 + 1e-9
    }

    func buyAutoSpeedUpgrade() {
        guard canBuyAutoSpeedUpgrade else { return }
        coins -= autoSpeedCost
        autoSpeedLevel += 1
        autoClickInterval = nextAutoInterval
        restartAutoTimer()
    }

    var autoPowerCost: Int {
        let base = 120.0
        let mult = 1.7
        return Int((base * pow(mult, Double(autoPowerLevel))).rounded(.up))
    }

    var canBuyAutoPowerUpgrade: Bool { autoUnlockPurchased && coins >= autoPowerCost }

    func buyAutoPowerUpgrade() {
        guard canBuyAutoPowerUpgrade else { return }
        coins -= autoPowerCost
        autoPowerLevel += 1
        autoClickPower += 1
    }

    func startAutoClickIfNeeded() {
        guard autoClickEnabled else { return }
        restartAutoTimer()
    }

    private func restartAutoTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: autoClickInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.autoTick()
            }
        }
    }

    private func autoTick() {
        guard autoClickEnabled else { return }
        value += autoClickPower
        coins += autoClickPower
    }

    // MARK: - Reset

    func resetAll() {
        timer?.invalidate()
        timer = nil

        value = 0
        coins = 0

        powerLevel = 1
        powerUpgradeCount = 0

        critUnlocked = false
        critLevel = 0

        autoClickEnabled = false
        autoUnlockPurchased = false

        autoClickInterval = 2.0
        autoSpeedLevel = 0

        autoClickPower = 1
        autoPowerLevel = 0
    }
}
