//
//  ShopView.swift
//  Counter
//
//  Created by Surasak Phetmanee on 17/02/2026.
//

import SwiftUI

struct ShopView: View {
    @ObservedObject var model: CounterModel

    var body: some View {
        NavigationStack {
            List {
                Section("Your Stats") {
                    statRow("Coins", "\(model.coins)")
                    statRow("Click Power", "+\(model.clickPower)")
                    statRow("Power Level", "x\(model.powerLevel)")
                    statRow("Crit", model.critUnlocked ? "ON" : "OFF")
                    if model.critUnlocked {
                        statRow("Crit Chance", "\(Int((model.critChance * 100).rounded()))%")
                        statRow("Crit Multiplier", String(format: "%.2fx", model.critMultiplier))
                    }
                    statRow("Auto Click", model.autoClickEnabled ? "ON" : "OFF")
                    statRow("Auto Interval", String(format: "%.2fs", model.autoClickInterval))
                }

                Section("Power Upgrade (1 → 2 → 4 → 8 ...)") {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Power Level Up")
                                .font(.headline)
                            Text("Doubles your click power each time.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Next: x\(model.powerLevel * 2)  (+\(model.nextClickPowerGain))")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("Cost: \(model.powerUpgradeCost)")
                                .font(.caption)
                            Button("Buy") { model.buyPowerUpgrade() }
                                .buttonStyle(.borderedProminent)
                                .disabled(!model.canBuyPowerUpgrade)
                        }
                    }
                    .padding(.vertical, 6)
                }

                Section("Critical Click (Unlock 500 coins)") {
                    if !model.critUnlocked {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Unlock Critical Click")
                                    .font(.headline)
                                Text("Chance to do a big click bonus.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("Base: 10% chance, 2.0x multiplier")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 6) {
                                Text("Cost: \(model.critUnlockCost)")
                                    .font(.caption)
                                Button("Unlock") { model.buyCritUnlock() }
                                    .buttonStyle(.borderedProminent)
                                    .disabled(!model.canBuyCritUnlock)
                            }
                        }
                        .padding(.vertical, 6)
                    } else {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Upgrade Critical")
                                    .font(.headline)
                                Text("More chance + higher multiplier.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("Chance: \(Int((model.critChance * 100).rounded()))%")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Text("Multiplier: \(String(format: "%.2fx", model.critMultiplier))")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 6) {
                                Text("Cost: \(model.critUpgradeCost)")
                                    .font(.caption)
                                Button("Buy") { model.buyCritUpgrade() }
                                    .buttonStyle(.borderedProminent)
                                    .disabled(!model.canBuyCritUpgrade)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }

                Section("Auto Click (1 click / 2s → faster)") {
                    autoClickCard
                }

                Section("Controls") {
                    Button(role: .destructive) {
                        model.resetAll()
                    } label: {
                        Text("Reset Game")
                    }
                }
            }
            .navigationTitle("Shop")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var autoClickCard: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Enable Auto Click")
                        .font(.headline)
                    Text("Auto adds coins + value every interval.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Current: \(model.autoClickEnabled ? "ON" : "OFF")")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text("Cost: \(model.autoUnlockCost)")
                        .font(.caption)
                    Button("Buy") { model.buyAutoUnlock() }
                        .buttonStyle(.borderedProminent)
                        .disabled(!model.canBuyAutoUnlock)
                }
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Faster Auto Click")
                        .font(.headline)
                    Text("Reduces interval each purchase.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Next interval: \(String(format: "%.2fs", model.nextAutoInterval))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text("Cost: \(model.autoSpeedCost)")
                        .font(.caption)
                    Button("Buy") { model.buyAutoSpeedUpgrade() }
                        .buttonStyle(.borderedProminent)
                        .disabled(!model.canBuyAutoSpeedUpgrade)
                }
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Auto Power Up")
                        .font(.headline)
                    Text("Adds more per auto tick.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Next auto power: +\(model.autoClickPower + 1)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text("Cost: \(model.autoPowerCost)")
                        .font(.caption)
                    Button("Buy") { model.buyAutoPowerUpgrade() }
                        .buttonStyle(.borderedProminent)
                        .disabled(!model.canBuyAutoPowerUpgrade)
                }
            }
        }
        .padding(.vertical, 6)
    }

    private func statRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .monospacedDigit()
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ShopView(model: CounterModel())
}
