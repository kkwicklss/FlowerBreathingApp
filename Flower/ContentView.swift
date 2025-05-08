import SwiftUI
import UIKit

struct ContentView: View {
    @State private var rotationAngle = 0.0
    @State private var isBreathing = false
    @State private var breathMessage = "Keep blooming, baby!"
    @State private var breathCount = 0
    @State private var progress: CGFloat = 0.0
    @State private var showFlower = false
    @State private var showText = false

    let totalBreaths = 6

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink, Color.blue.opacity(0.5)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                Spacer()

                // Цветок с вращением и дыханием
                Text("🌸")
                    .font(.system(size: 100))
                    .rotationEffect(.degrees(rotationAngle))
                    .scaleEffect(isBreathing ? 1.2 : 1.0)
                    .opacity(showFlower ? 1 : 0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isBreathing)
                    .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: rotationAngle)

                Text(breathMessage)
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(showText ? 1 : 0)
                    .animation(.easeOut(duration: 1).delay(1), value: showText)

                if isBreathing {
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .padding(.horizontal, 40)
                        .animation(.easeInOut, value: progress)
                }

                Spacer()

                if !isBreathing {
                    Button(action: {
                        startBreathingSession()
                    }) {
                        Text("Start Breathing")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 40)
                    }
                }
            }
        }
        .onAppear {
            showFlower = true
            withAnimation(Animation.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showText = true
            }
        }
    }

    private func startBreathingSession() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        isBreathing = true
        breathMessage = "Inhale..."
        breathCount = 0
        progress = 0.0

        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { timer in
            breathCount += 1
            breathMessage = (breathMessage == "Inhale...") ? "Exhale..." : "Inhale..."
            progress = CGFloat(breathCount) / CGFloat(totalBreaths)

            if breathCount >= totalBreaths {
                timer.invalidate()
                stopBreathingSession()
            }
        }
    }

    private func stopBreathingSession() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isBreathing = false
            breathMessage = "Keep blooming, baby!"
            progress = 0.0
        }
    }
}
