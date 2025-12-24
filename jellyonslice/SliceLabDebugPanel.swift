//import SwiftUI
//import Combine
//
//struct SliceLabDebugPanel: View {
//
//    @ObservedObject var scene: SliceLabScene
//
//    @State private var isVisible: Bool = true
//
//    var body: some View {
//        VStack {
//            if isVisible {
//                VStack(alignment: .leading, spacing: 6) {
//                    row("Stars", "\(scene.stars.count)")
//                    row("Ropes", "\(scene.ropes.count)")
//                    row("Score", "\(scene.score)")
//                    row("Combo", "\(scene.combo)")
//                    row("State", scene.isRunning ? "running" : "stopped")
//                }
//                .padding(10)
//                .background(
//                    RoundedRectangle(cornerRadius: 12, style: .continuous)
//                        .fill(Color.black.opacity(0.7))
//                )
//                .overlay(
//                    RoundedRectangle(cornerRadius: 12, style: .continuous)
//                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
//                )
//            }
//
//            Button {
//                withAnimation(.easeInOut(duration: 0.2)) {
//                    isVisible.toggle()
//                }
//            } label: {
//                Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
//                    .font(.system(size: 14, weight: .bold))
//                    .foregroundColor(.white)
//                    .padding(8)
//                    .background(
//                        Circle()
//                            .fill(Color.black.opacity(0.6))
//                    )
//            }
//            .padding(.top, 6)
//        }
//        .padding(12)
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//        .allowsHitTesting(true)
//    }
//
//    private func row(_ title: String, _ value: String) -> some View {
//        HStack {
//            Text(title)
//                .font(.system(size: 12, weight: .medium))
//                .foregroundColor(.white.opacity(0.8))
//
//            Spacer()
//
//            Text(value)
//                .font(.system(size: 12, weight: .bold))
//                .foregroundColor(.white)
//        }
//    }
//}
