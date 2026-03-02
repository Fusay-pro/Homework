//
//  HomeView.swift
//  Counter
//
//  Created by Surasak Phetmanee on 17/02/2026.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var model: CounterModel

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [.blue.opacity(0.25), .purple.opacity(0.25), .mint.opacity(0.18)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 18) {

                    // Header card
                    VStack(spacing: 10) {
                        Text("COUNTER")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)

                        Text("\(model.value)")
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .monospacedDigit()

                        // Stats pills
                        HStack(spacing: 10) {
                            StatPill(icon: "bolt.fill", title: "Power", value: "x\(model.powerLevel)")
                            StatPill(icon: "cursorarrow.click", title: "Click", value: "+\(model.clickPower)")
                            StatPill(icon: "dollarsign.circle.fill", title: "Coins", value: "\(model.coins)")
                        }
                        .padding(.top, 6)
                    }
                    .padding(.vertical, 18)
                    .padding(.horizontal, 16)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(.white.opacity(0.25), lineWidth: 1)
                    )
                    .shadow(radius: 18, y: 10)
                    .padding(.horizontal)

                    // Big Tap Button
                    Button {
                        model.manualClick()
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: "hand.tap.fill")
                                .font(.system(size: 44, weight: .bold))
                            Text("TAP  +\(model.clickPower)")
                                .font(.headline.weight(.semibold))
                                .monospacedDigit()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 26)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                    .padding(.horizontal)

                    // Auto click status card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Auto Click", systemImage: "timer")
                                .font(.headline)
                            Spacer()
                            Text(model.autoClickEnabled ? "ON" : "OFF")
                                .font(.subheadline.weight(.semibold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(model.autoClickEnabled ? .green.opacity(0.2) : .secondary.opacity(0.15))
                                .clipShape(Capsule())
                        }

                        HStack(spacing: 10) {
                            InfoRow(title: "Interval", value: String(format: "%.2fs", model.autoClickInterval), icon: "clock")
                            InfoRow(title: "Auto Power", value: "+\(model.autoClickPower)", icon: "wand.and.stars")
                        }
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(.white.opacity(0.22), lineWidth: 1)
                    )
                    .shadow(radius: 12, y: 8)
                    .padding(.horizontal)

                    Spacer(minLength: 10)
                }
                .padding(.top, 12)
            }
            .navigationTitle("Start")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Small UI Components

private struct StatPill: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.white.opacity(0.18), lineWidth: 1)
        )
    }
}

private struct InfoRow: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.headline)
                .frame(width: 26)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.white.opacity(0.18), lineWidth: 1)
        )
    }
}

#Preview {
    HomeView(model: CounterModel())
}
