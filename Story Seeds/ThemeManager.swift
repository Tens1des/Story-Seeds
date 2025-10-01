//
//  ThemeManager.swift
//  Story Seeds
//
//  Theme management and color schemes
//

import SwiftUI

// MARK: - Theme Manager

class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme = .light
    
    init() {
        // Load theme from UserDefaults or use system preference
        if let savedTheme = UserDefaults.standard.string(forKey: "app_theme"),
           let theme = AppTheme(rawValue: savedTheme) {
            currentTheme = theme
        } else {
            // Use system appearance
            currentTheme = UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
        }
    }
    
    func setTheme(_ theme: AppTheme) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentTheme = theme
        }
        UserDefaults.standard.set(theme.rawValue, forKey: "app_theme")
    }
    
    var isDarkMode: Bool {
        currentTheme == .dark
    }
}

// MARK: - Color Extensions

extension Color {
    static let primaryGradient = LinearGradient(
        colors: [Color.purple, Color.pink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [Color.blue, Color.cyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let successGradient = LinearGradient(
        colors: [Color.green, Color.mint],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let warningGradient = LinearGradient(
        colors: [Color.orange, Color.yellow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Animation Extensions

extension Animation {
    static let springBounce = Animation.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)
    static let smoothEase = Animation.easeInOut(duration: 0.3)
    static let quickEase = Animation.easeInOut(duration: 0.2)
}

// MARK: - View Modifiers

struct BounceEffect: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.springBounce, value: isPressed)
            .onTapGesture {
                withAnimation(.springBounce) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.springBounce) {
                        isPressed = false
                    }
                }
            }
    }
}

struct ShakeEffect: ViewModifier {
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .offset(x: offset)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true)) {
                    offset = 10
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    offset = 0
                }
            }
    }
}

struct GlowEffect: ViewModifier {
    let color: Color
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.3), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.2), radius: radius * 2, x: 0, y: 0)
    }
}

struct CardStyleModifier: ViewModifier {
    let cornerRadius: CGFloat
    func body(content: Content) -> some View { content }
}

// MARK: - View Extensions

extension View {
    func bounceEffect() -> some View {
        modifier(BounceEffect())
    }
    
    func shakeEffect() -> some View {
        modifier(ShakeEffect())
    }
    
    func glowEffect(color: Color = .purple, radius: CGFloat = 8) -> some View {
        modifier(GlowEffect(color: color, radius: radius))
    }
    
    func cardStyle(cornerRadius: CGFloat = 16) -> some View {
        modifier(CardStyleModifier(cornerRadius: cornerRadius))
    }
    
    func gradientBackground() -> some View {
        self
            .background(
                LinearGradient(
                    colors: [Color.purple.opacity(0.1), Color.pink.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    func adaptiveGradientBackground() -> some View {
        self
            .background(
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.1),
                        Color.pink.opacity(0.1),
                        Color.blue.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

// MARK: - Haptic Feedback

struct HapticFeedback {
    static func light() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    static func medium() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    static func heavy() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    static func success() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
    
    static func warning() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.warning)
    }
    
    static func error() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.error)
    }
}
