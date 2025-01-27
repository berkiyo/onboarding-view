import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
    let iconColor: Color

    static let pages = [
        OnboardingPage(
            image: "lock.shield.fill",
            title: "Secure Password Storage",
            description: "Keep all your passwords safely encrypted and organized in one place",
            iconColor: .blue
        ),
        OnboardingPage(
            image: "key.horizontal.fill",
            title: "Password Generator",
            description: "Create strong, unique passwords with our built-in generator",
            iconColor: .green
        ),
        OnboardingPage(
            image: "icloud.fill",
            title: "iCloud Sync",
            description: "Access your passwords across all your devices with secure iCloud sync",
            iconColor: .purple
        ),
        OnboardingPage(
            image: "faceid",
            title: "Biometric Security",
            description: "Quick and secure access with Face ID or Touch ID",
            iconColor: .orange
        ),
    ]
}

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    @State private var iconScale = 1.0
    @State private var iconOffset: CGSize = .zero
    @State private var themeManager = ThemeManager.shared
    let isModal: Bool

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Animated background gradient
                    LinearGradient(
                        colors: [
                            themeManager.currentTheme.accent.opacity(0.2),
                            Color.gray.opacity(0.1),
                            themeManager.currentTheme.accent.opacity(0.15),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    .hueRotation(.degrees(Double(currentPage) * 45))
                    .animation(.easeInOut(duration: 1.0), value: currentPage)

                    VStack {
                        TabView(selection: $currentPage) {
                            WelcomePage(iconScale: iconScale, iconOffset: $iconOffset)
                                .tag(0)

                            FeaturePage(
                                title: "Secure Storage",
                                description:
                                    "Keep all your passwords safely encrypted and organized in one place",
                                icon: "lock.shield.fill",
                                color: themeManager.currentTheme.accent,
                                iconScale: iconScale,
                                iconOffset: $iconOffset
                            )
                            .tag(1)

                            FeaturePage(
                                title: "Password Generator",
                                description:
                                    "Create strong, unique passwords with our built-in generator",
                                icon: "key.horizontal.fill",
                                color: themeManager.currentTheme.accent,
                                iconScale: iconScale,
                                iconOffset: $iconOffset
                            )
                            .tag(2)

                            FeaturePage(
                                title: "iCloud Sync",
                                description:
                                    "Access your passwords across all your devices with secure iCloud sync",
                                icon: "icloud.fill",
                                color: themeManager.currentTheme.accent,
                                iconScale: iconScale,
                                iconOffset: $iconOffset
                            )
                            .tag(3)

                            FeaturePage(
                                title: "Biometric Security",
                                description: "Quick and secure access with Face ID or Touch ID",
                                icon: "faceid",
                                color: themeManager.currentTheme.accent,
                                isLast: true,
                                iconScale: iconScale,
                                iconOffset: $iconOffset
                            )
                            .tag(4)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))

                        // Custom page indicator
                        HStack(spacing: 8) {
                            ForEach(0..<5) { index in
                                Capsule()
                                    .fill(
                                        currentPage == index
                                            ? themeManager.currentTheme.accent : .gray.opacity(0.3)
                                    )
                                    .frame(width: currentPage == index ? 20 : 8, height: 8)
                                    .animation(.spring(response: 0.3), value: currentPage)
                            }
                        }
                        .padding(.bottom, 20)

                        // Navigation buttons
                        if currentPage == 4 {
                            Button {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                    if !isModal {
                                        hasCompletedOnboarding = true
                                    }
                                    dismiss()
                                }
                            } label: {
                                Text("Get Started")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(width: 200)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(themeManager.currentTheme.gradient)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                    .shadow(
                                        color: themeManager.currentTheme.accent.opacity(0.3),
                                        radius: 15, x: 0, y: 5)
                            }
                            .scaleEffect(iconScale)
                        } else {
                            Button {
                                withAnimation {
                                    currentPage += 1
                                }
                            } label: {
                                HStack(spacing: 8) {
                                    Text("Next")
                                        .font(.headline)
                                    Image(systemName: "chevron.right")
                                        .font(.headline)
                                        .opacity(0.8)
                                }
                                .foregroundStyle(.white)
                                .frame(width: 200)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(themeManager.currentTheme.gradient)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                                .shadow(
                                    color: themeManager.currentTheme.accent.opacity(0.3),
                                    radius: 15, x: 0, y: 5)
                            }
                            .scaleEffect(iconScale)
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
            .toolbar {
                if isModal {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                iconScale = 1.0
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    iconOffset = value.translation
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        iconOffset = .zero
                    }
                }
        )
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isLastPage: Bool
    let isFirstPage: Bool
    let moveToNextPage: () -> Void
    let completion: () -> Void
    @State private var isPulsing = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: page.image)
                .font(.system(size: 100))
                .foregroundStyle(page.iconColor)
                .scaleEffect(isPulsing ? 1.1 : 0.9)
                .animation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isPulsing
                )
                .onAppear {
                    isPulsing = true
                }

            VStack(spacing: 12) {
                Text(page.title)
                    .font(.title)
                    .bold()

                Text(page.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()

            if isLastPage {
                Button {
                    completion()
                } label: {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(page.iconColor.gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 32)
            } else {
                HStack {
                    if !isFirstPage {
                        Button("Skip") {
                            completion()
                        }
                        .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button {
                        moveToNextPage()
                    } label: {
                        Text("Next")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 44)
                            .background(page.iconColor.gradient)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 32)
            }

            Spacer()
                .frame(height: 50)
        }
    }
}

private struct WelcomePage: View {
    let iconScale: Double
    @Binding var iconOffset: CGSize
    @State private var themeManager = ThemeManager.shared
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "lock.shield.fill")
                .font(.system(size: 60))
                .foregroundStyle(themeManager.currentTheme.gradient)
                .padding(40)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .shadow(
                            color: themeManager.currentTheme.accent.opacity(0.3), radius: 20, x: 0,
                            y: 10)
                )
                .overlay(
                    Circle()
                        .stroke(themeManager.currentTheme.gradient, lineWidth: 2)
                        .opacity(0.5)
                )
                .scaleEffect(iconScale)
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .offset(x: iconOffset.width / 3, y: iconOffset.height / 3)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }

            Text("Welcome to PassVault")
                .font(.system(size: 36, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(themeManager.currentTheme.gradient)

            Text("Your secure password manager")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
    }
}

private struct FeaturePage: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    var isLast = false
    var iconScale: Double
    @Binding var iconOffset: CGSize
    var action: (() -> Void)?
    @State private var themeManager = ThemeManager.shared
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(themeManager.currentTheme.gradient)
                .padding(40)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .shadow(
                            color: themeManager.currentTheme.accent.opacity(0.3), radius: 20, x: 0,
                            y: 10)
                )
                .overlay(
                    Circle()
                        .stroke(themeManager.currentTheme.gradient, lineWidth: 2)
                        .opacity(0.5)
                )
                .scaleEffect(iconScale)
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .offset(x: iconOffset.width / 3, y: iconOffset.height / 3)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }

            Text(title)
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(themeManager.currentTheme.gradient)

            Text(description)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
