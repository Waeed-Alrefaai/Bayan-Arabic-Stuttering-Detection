//
//  MainView.swift
//  AI-StutterApp
//
//  Created by May Alqunaytir on 29/04/2026.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm = MainViewModel()
    
    @State private var activeIndex = 0
    @State private var phase: Double = 0
    @State private var timer: Timer?
    
    @State private var recordingTime: Double = 0
    @State private var recordingTimer: Timer?
    
    @AppStorage("hasSeenPrivacy") var hasSeenPrivacy = false
    @AppStorage("allowVoiceData") var allowVoiceData = false
    
    @State private var screen: ScreenState = .initial
    
    enum ScreenState {
        case initial
        case privacy
        case main
        case result
    }
    
    var body: some View {
        ZStack {
            
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            // Back button
            if screen == .main || screen == .privacy {
                VStack {
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {
                            screen = .initial
                            vm.isRecording = false
                            stopAnimation()
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                    }
                    .padding()
                    .padding()
                    
                    Spacer()
                }
            }
            
            // Screens
            switch screen {
                
            case .initial:
                initialView
                
            case .privacy:
                PrivacyScreen(
                    allowVoiceData: $allowVoiceData,
                    onAccept: {
                        vm.acceptPrivacy()
                        hasSeenPrivacy = true
                        screen = .main
                    },
                    onRefuse: {
                        vm.refusePrivacy()
                        hasSeenPrivacy = true
                        screen = .main
                    },
                    onBack: {
                        screen = .initial
                    }
                )
                
            case .main:
                mainView
                
            case .result:
                resultView
            }
        }
    }
    
    // Initial screen
    var initialView: some View {
        VStack(spacing: 35) {
            
            // Shield button
            HStack {
                
                Button(action: {
                    screen = .privacy
                }) {
                    Image("Shield")
                        .resizable()
                        .frame(width: 25, height: 28)
                        .opacity(0.8)
                }
                
                Spacer()
            
            }
            .padding(.horizontal)
            
            Text("مرحبًا بك في بيان!")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color("Text"))
                .offset(y: -20)
            
            Text("تطبيق كشف التأتأة بالذكاء الاصطناعي")
                .font(.subheadline)
                .foregroundColor(Color("Text"))
                .offset(y: -40)
            
            Image("Wave")
                .offset(y: -50)
            
            Image("Microphone")
                .resizable()
                .frame(width: 180, height: 250)
                .offset(y: -50)
            
            Button(action: {
                if hasSeenPrivacy {
                    screen = .main  
                } else {
                    screen = .privacy
                }
            }) {
                Text("ابدأ التسجيل")
                    .foregroundColor(Color("Text"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color("ButtonColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(Color.white.opacity(0.2))
                            )
                    )
                    .padding(.horizontal, 40)
            }
            .offset(y: -10)
        }
    }
    
    // Main screen
    var mainView: some View {
        VStack(spacing: 8) {
            
            VStack {
                if vm.isRecording {
                    HStack(spacing: 8) {
                        
                        Text("جارٍ التسجيل...")
                            .foregroundColor(Color("Text"))
                            .font(.title)
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                    }
                    
                    Text(String(format: "%05.2f", recordingTime))
                        .foregroundColor(Color("Text"))
                        .monospacedDigit()
                    
                } else {
                    Text("ابدأ التسجيل")
                        .foregroundColor(Color("Text"))
                        .font(.title)
                }
            }
            .frame(height: 80)
            .offset(y: -60)
            
            ZStack {
                Image("Ellipse1")
                    .resizable()
                    .frame(width: 220, height: 220)
                    .opacity(0.3 + 0.7 * smoothPulse(offset: 0.66))
                
                Image("Ellipse2")
                    .resizable()
                    .frame(width: 260, height: 260)
                    .opacity(0.3 + 0.7 * smoothPulse(offset: 0.33))
                
                Image("Ellipse3")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .opacity(0.3 + 0.7 * smoothPulse(offset: 0.0))
                
                Button(action: {
                    if vm.isRecording {
                        stopRecording()
                    } else {
                        vm.startRecording()
                        startRecordingTimer()
                        startSmoothAnimation()
                    }
                }) {
                    Image("Microphone")
                        .resizable()
                        .frame(width: 120, height: 150)
                }
            }
        }
    }
    
    // Result Screen
    var resultView: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            // Title
            HStack {
                
                Spacer()
                
                Text("نتيجة تحليل الكلام")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Text"))
            }
            .padding(.horizontal, 28)
            
            // Card
            VStack(spacing: 22) {
                
                // Detection Section
                if vm.detectedLabels.isEmpty {

                    Text("لم يتم اكتشاف أي أنماط")
                        .foregroundColor(Color("Text"))
                        .fontWeight(.semibold)

                } else {

                    VStack(spacing: 12) {
                        ForEach(vm.detectedLabels, id: \.self) { label in
                            bulletRow(arabicLabel(label))
                        }
                    }
                }
                
                Divider()
                    .background(Color.white.opacity(0.2))
                
                // Confidence
                HStack {
                    Spacer()
                    
                    if !vm.detectedLabels.isEmpty {
                        Text("نسبة الثقة بالتوقع: \(Int(vm.confidence * 100))%")
                            .foregroundColor(Color("Text"))
                            .fontWeight(.medium)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Disclaimer
                HStack {
                    Spacer()
                    
                    Text("""
    تم إنشاء هذه النتيجة بواسطة نموذج ذكاء اصطناعي، وهي ليست تشخيصًا طبيًا.

    إذا كانت لديك مخاوف بشأن أنماط الكلام، يُنصح بمراجعة أخصائي نطق ولغة.
    """)
                    .foregroundColor(Color("Text"))
                    .font(.footnote)
                    .lineSpacing(7)
                    .multilineTextAlignment(.trailing)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color("ButtonColor").opacity(0.25))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 22)
            
            Spacer()
            
            // Done Button
            Button(action: {
                screen = .initial
            }) {
                Text("تم")
                    .foregroundColor(Color("Text"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color("ButtonColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(Color.white.opacity(0.2))
                            )
                    )
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
    
    //Label Mapper
    func arabicLabel(_ label: String) -> String {
        switch label {
        case "Prolongation":
            return "الإطالة"
        case "SoundRep":
            return "تكرار الأصوات"
        case "WordRep":
            return "تكرار الكلمات"
        case "Block":
            return "التوقف المفاجئ"
        case "Interjection":
            return "الكلمات الاعتراضية"
        default:
            return label
        }
    }

    // Bullet Row
    func bulletRow(_ text: String) -> some View {
        HStack(spacing: 6) {
            
            Spacer()
            
            Text(text)
                .foregroundColor(Color("Text"))
            
            Text("•")
                .foregroundColor(Color("Text"))
        }
        .frame(maxWidth: .infinity)
    }
    
    // Animation
    func smoothPulse(offset: Double) -> Double {
        guard vm.isRecording else { return 0 }
        
        let progress = (phase + offset).truncatingRemainder(dividingBy: 1)
        return progress < 0.5 ? progress * 2 : (1 - progress) * 2
    }
    
    func startSmoothAnimation() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            if !vm.isRecording {
                stopAnimation()
                return
            }
            
            phase += 0.01
        }
    }
    
    func stopAnimation() {
        timer?.invalidate()
        timer = nil
        phase = 0
    }
    
    // Timer
    func startRecordingTimer() {
        recordingTime = 0
        recordingTimer?.invalidate()
        
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            recordingTime += 0.01
            
            if recordingTime >= 15 {
                stopRecording()
            }
        }
    }
    
    func stopRecording() {

        vm.stopRecording()

        print(vm.audioURL)

        recordingTimer?.invalidate()
        recordingTimer = nil

        stopAnimation()
        recordingTime = 0

        if let url = vm.audioURL {

            vm.processAudio(
                fileURL: url,
                allowVoiceData: allowVoiceData
            ) {
                screen = .result
            }

        } else {
            screen = .result
        }
    }
}

#Preview {
    MainView()
}
