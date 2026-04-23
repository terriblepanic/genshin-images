//
//  QuizView.swift
//  genshin images
//
//  Created by Кирилл Паничкин on 4/8/26.
//

import SwiftUI
import AVFoundation
import AudioToolbox

struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var color: Color
    var scale: CGFloat = 1.0
    var opacity: Double = 1.0
}

struct FloatingCircle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
    var duration: Double
}

struct QuizView: View {
    var titleOn: Bool
    var lastViewedPost: Post?
    var regionColor: Color

    @State private var currentPost: Post = posts.randomElement()!
    @State private var options: [Post] = []
    @State private var selectedPost: Post? = nil
    @State private var showAnswer = false
    @State private var cardScale: CGFloat = 0.3
    @State private var cardRotation: Double = -15
    @State private var descriptionExpanded = false

    // Колода — чтобы персонажи не повторялись подряд
    @State private var deck: [Post] = []
    @State private var deckIndex: Int = 0

    @State private var particles: [Particle] = []
    @State private var floatingCircles: [FloatingCircle] = []
    @State private var animateBackground = false

    @State private var audioPlayer: AVAudioPlayer?
    // Один таймер на оба направления — иначе fadeIn и fadeOut могут запуститься одновременно
    @State private var fadeTimer: Timer?
    @State private var questionOpacity: Double = 1.0

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {

                // MARK: Анимированный фон
                GeometryReader { geo in
                    ZStack {
                        ForEach(floatingCircles) { circle in
                            Circle()
                                .fill(Color.indigo.opacity(circle.opacity))
                                .frame(width: circle.size, height: circle.size)
                                .position(
                                    x: circle.x * geo.size.width,
                                    y: animateBackground
                                        ? circle.y * geo.size.height * 0.3
                                        : circle.y * geo.size.height
                                )
                                .animation(
                                    .easeInOut(duration: circle.duration)
                                    .repeatForever(autoreverses: true),
                                    value: animateBackground
                                )
                        }
                    }
                }
                .ignoresSafeArea()

                // MARK: Партиклы
                GeometryReader { _ in
                    ZStack {
                        ForEach(particles) { particle in
                            Circle()
                                .fill(particle.color)
                                .frame(width: 10 * particle.scale, height: 10 * particle.scale)
                                .position(x: particle.x, y: particle.y)
                                .opacity(particle.opacity)
                        }
                    }
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)

                // MARK: Основной слой
                VStack(spacing: 0) {
                    // Невидимый текст вверху — держит высоту чтобы карточка не прыгала
                    Text(currentPost.description)
                        .font(.footnote)
                        .lineLimit(2)
                        .padding(10)
                        .opacity(0)

                    ZStack {
                        if showAnswer {
                            VStack(spacing: 8) {
                                currentPost.image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(14)
                                    .shadow(radius: 8)
                                    .scaleEffect(cardScale)
                                    .rotationEffect(.degrees(cardRotation))
                                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: cardScale)

                                Text(selectedPost?.id == currentPost.id ? "Правильно!" : "Неверно. Это \(currentPost.title)")
                                    .font(.subheadline)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .transition(.opacity)
                            }
                            .transition(.scale.combined(with: .opacity))
                        } else {
                            Text("Кто этот персонаж?")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.secondary)
                                .opacity(questionOpacity)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    // MARK: Кнопки ответов
                    VStack(spacing: 8) {
                        ForEach(options) { option in
                            Button(action: {
                                guard selectedPost == nil else { return }
                                answer(option: option)
                            }) {
                                Text(option.title)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(buttonColor(for: option))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            .disabled(selectedPost != nil)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }

                        Button(action: { nextQuestion() }) {
                            Text("Следующий вопрос →")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedPost != nil ? regionColor : Color.clear)
                                .foregroundColor(selectedPost != nil ? .white : .clear)
                                .cornerRadius(12)
                        }
                        .disabled(selectedPost == nil)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }

                // MARK: Описание сверху
                VStack(alignment: .trailing, spacing: 4) {
                    Text(currentPost.description)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .lineLimit(descriptionExpanded ? nil : 2)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)

                    HStack {
                        Spacer()
                        Image(systemName: descriptionExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .shadow(
                            color: descriptionExpanded ? .black.opacity(0.1) : .clear,
                            radius: 8, x: 0, y: 4
                        )
                )
                .padding(.horizontal)
                .padding(.top, 4)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        descriptionExpanded.toggle()
                    }
                }
                .zIndex(1)
            }
            .navigationTitle(titleOn ? "Викторина" : "")
            .onAppear {
                setupOnAppear()
                setupFloatingCircles()
                startBackgroundMusic()
                fadeInMusic()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation { animateBackground = true }
                }
            }
            .onDisappear {
                fadeOutMusic()
                animateBackground = false
            }
        }
    }

    // MARK: - Setup

    func setupOnAppear() {
        if deck.isEmpty {
            deck = posts.shuffled()
            deckIndex = 0
            currentPost = nextFromDeck()
            generateOptions()
            return
        }
        if selectedPost != nil { return }
        // Если пользователь открыл персонажа в списке — начинаем викторину с него
        if let viewed = lastViewedPost, viewed.id != currentPost.id {
            currentPost = viewed
            generateOptions()
        }
    }

    func setupFloatingCircles() {
        // Не пересоздаём при каждом onAppear — иначе круги прыгают при возврате на вкладку
        if !floatingCircles.isEmpty { return }
        floatingCircles = (0..<8).map { _ in
            FloatingCircle(
                x: CGFloat.random(in: 0.05...0.95),
                y: CGFloat.random(in: 0.3...1.0),
                size: CGFloat.random(in: 40...120),
                opacity: Double.random(in: 0.03...0.08),
                duration: Double.random(in: 4...9)
            )
        }
    }

    // MARK: - Музыка

    func startBackgroundMusic() {
        guard audioPlayer == nil else { return }

        if let dataAsset = NSDataAsset(name: "quiz_music") {
            audioPlayer = try? AVAudioPlayer(data: dataAsset.data)
        } else if let url = Bundle.main.url(forResource: "quiz_music", withExtension: "wav") {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
        }

        audioPlayer?.numberOfLoops = -1
        audioPlayer?.volume = 0
    }

    func fadeInMusic() {
        fadeTimer?.invalidate()
        audioPlayer?.play()

        fadeTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            guard let player = self.audioPlayer else { timer.invalidate(); return }
            let next = min(player.volume + 0.015, 0.3)
            player.volume = next
            if next >= 0.3 { timer.invalidate() }
        }
    }

    func fadeOutMusic() {
        fadeTimer?.invalidate()

        fadeTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            guard let player = self.audioPlayer else { timer.invalidate(); return }
            let next = max(player.volume - 0.015, 0)
            player.volume = next
            if next <= 0 {
                player.pause()
                timer.invalidate()
            }
        }
    }

    // MARK: - Звуковые эффекты

    func playCorrectSound() {
        AudioServicesPlaySystemSound(1025)
    }

    func playWrongSound() {
        AudioServicesPlaySystemSound(1053)
    }

    // MARK: - Логика ответа

    func answer(option: Post) {
        selectedPost = option
        descriptionExpanded = false

        if option.id == currentPost.id {
            playCorrectSound()
            spawnParticles()
        } else {
            playWrongSound()
        }

        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            showAnswer = true
            cardScale = 1.0
            cardRotation = 0
        }
    }

    // MARK: - Партиклы

    func spawnParticles() {
        let colors: [Color] = [.yellow, .orange, .green, .cyan, .purple, .pink]
        let centerX = UIScreen.main.bounds.width / 2
        let centerY = UIScreen.main.bounds.height / 2

        particles = (0..<18).map { _ in
            Particle(
                x: centerX + CGFloat.random(in: -20...20),
                y: centerY + CGFloat.random(in: -20...20),
                color: colors.randomElement()!
            )
        }

        for i in particles.indices {
            let angle = Double.random(in: 0...(2 * .pi))
            let distance = CGFloat.random(in: 80...200)

            withAnimation(.easeOut(duration: 0.8)) {
                particles[i].x = centerX + cos(angle) * distance
                particles[i].y = centerY + sin(angle) * distance
                particles[i].opacity = 0
                particles[i].scale = 0.3
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            particles = []
        }
    }

    // MARK: - Helpers

    func buttonColor(for option: Post) -> Color {
        guard let selected = selectedPost else { return Color(.systemGray) }
        if option.id == currentPost.id { return .green }
        if option.id == selected.id { return .red }
        return Color(.systemGray)
    }

    func generateOptions() {
        let wrong = posts.filter { $0.id != currentPost.id }.shuffled()
        options = (Array(wrong.prefix(2)) + [currentPost]).shuffled()
    }

    func nextFromDeck() -> Post {
        if deckIndex >= deck.count {
            var newDeck = posts.shuffled()
            // Если первый в новой колоде — тот же что сейчас, сдвигаем его в конец
            if newDeck.first?.id == currentPost.id {
                newDeck.append(newDeck.removeFirst())
            }
            deck = newDeck
            deckIndex = 0
        }
        let post = deck[deckIndex]
        deckIndex += 1
        return post
    }

    func nextQuestion() {
        withAnimation(.easeOut(duration: 0.2)) {
            questionOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            selectedPost = nil
            showAnswer = false
            cardScale = 0.3
            cardRotation = -15
            descriptionExpanded = false
            currentPost = nextFromDeck()
            generateOptions()

            withAnimation(.easeIn(duration: 0.3)) {
                questionOpacity = 1
            }
        }
    }
}
