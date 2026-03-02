import SwiftUI

struct ContentView: View {
    @StateObject private var model = CounterModel()

    var body: some View {
        TabView {
            HomeView(model: model)
                .tabItem { Label("Start", systemImage: "hand.tap") }

            ShopView(model: model)
                .tabItem { Label("Shop", systemImage: "cart") }
        }
        .onAppear {
            model.startAutoClickIfNeeded()   // ✅ NO $model
        }
    }
}
