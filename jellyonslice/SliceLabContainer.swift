import SwiftUI
import Combine

struct SliceLabContainer: View {

    @StateObject private var scene = SliceLabScene(bounds: UIScreen.main.bounds)

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()

                ForEach(scene.stars) { star in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.white, .yellow.opacity(0.6), .clear],
                                center: .center,
                                startRadius: 1,
                                endRadius: star.radius
                            )
                        )
                        .frame(width: star.radius * 2, height: star.radius * 2)
                        .position(star.position)
                        .animation(.linear(duration: 0.016), value: star.position)
                }

                VStack {
                    HStack {
                        Text("Score \(scene.score)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)

                        Spacer()

                        if scene.combo > 1 {
                            Text("x\(scene.combo)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                    Spacer()
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        scene.slice(at: value.location)
                    }
            )
            .onAppear {
                scene.start()
            }
            .onDisappear {
                scene.stop()
            }
        }
    }
}
