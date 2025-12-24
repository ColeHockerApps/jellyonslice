import SwiftUI
import Combine
import WebKit

struct PrivacyPageView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var haptics: HapticsManager

    private let privacyURL = URL(string: "https://example.com/privacy")!

    var body: some View {
        ZStack {
            StarTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                WebView(url: privacyURL)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }

    private var header: some View {
        HStack {
            Button {
                haptics.tapLight()
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(StarTheme.textPrimary)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(StarTheme.surfaceStrong)
                    )
            }

            Spacer()

//            Text("Privacy Policy")
//                .font(StarTheme.titleFont)
//                .foregroundColor(StarTheme.textPrimary)

            Spacer()

            Color.clear
                .frame(width: 36, height: 36)
        }
        .padding(.horizontal, 18)
        .padding(.top, 16)
        .padding(.bottom, 10)
    }
}

private struct WebView: UIViewRepresentable {

    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: config)
        view.backgroundColor = UIColor.black
        view.isOpaque = false
        view.load(URLRequest(url: url))
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
