import SwiftUI
import Combine

struct SettingsScreen: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var haptics: HapticsManager

    @StateObject private var vm = SettingsViewModel()

    var body: some View {
        ZStack {
            StarTheme.background
                .ignoresSafeArea()

            VStack(spacing: 18) {
                header

                settingsCard

                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.top, 20)
        }
    }

    private var header: some View {
        HStack {
            Button {
                haptics.tapLight()
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(StarTheme.textPrimary)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(StarTheme.surfaceStrong)
                    )
            }

            Spacer()

//            Text("Settings")
//                .font(StarTheme.titleFont)
//                .foregroundColor(StarTheme.textPrimary)

            Spacer()

            Color.clear
                .frame(width: 36, height: 36)
        }
    }

    private var settingsCard: some View {
        VStack(spacing: 14) {
            toggleRow(
                title: "Haptics",
                subtitle: "Vibration feedback",
                isOn: vm.hapticsEnabled
            ) { value in
                vm.setHaptics(value)
               // haptics.setEnabled(value)
            }

            toggleRow(
                title: "Sound",
                subtitle: "Game sounds",
                isOn: vm.soundEnabled
            ) { value in
                vm.setSound(value)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(StarTheme.surface)
        )
    }

    private func toggleRow(
        title: String,
        subtitle: String,
        isOn: Bool,
        onChange: @escaping (Bool) -> Void
    ) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
//                Text(title)
//                    .font(StarTheme.bodyFont)
//                    .foregroundColor(StarTheme.textPrimary)

//                Text(subtitle)
//                    .font(StarTheme.captionFont)
//                    .foregroundColor(StarTheme.textSecondary)
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { isOn },
                set: { value in
                   // haptics.tapSoft()
                    onChange(value)
                }
            ))
            .labelsHidden()
        }
    }
}
