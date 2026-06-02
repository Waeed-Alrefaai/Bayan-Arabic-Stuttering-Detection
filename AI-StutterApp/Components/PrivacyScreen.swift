//
//  PrivacyPopup.swift
//  AI-StutterApp
//
//  Created by May Alqunaytir on 29/04/2026.
//

import SwiftUI

struct PrivacyScreen: View {
    @Binding var allowVoiceData: Bool
    
    var onAccept: () -> Void
    var onRefuse: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        ZStack {
            
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                HStack {
                    
                    Spacer()
                    
                    // Back button
                    Button(action: {
                        onBack()
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
                .padding(.trailing, 16)
                .overlay(
                    HStack {
                        
                        // Center title
                        HStack(spacing: 8) {
                            
                            Text("إعدادات الخصوصية")
                                .foregroundColor(Color("Text"))
                                .font(.title)
                            
                            Image("Shield")
                                .resizable()
                                .frame(width: 25, height: 28)
                        }
                    }
                )
                .padding(.horizontal)
                .padding(.top, 32)
                
                
                // Privacy card
                VStack(alignment: .trailing, spacing: 20) {
                    
                    Text("إعدادات الخصوصية")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Text"))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text("""
                    اسمح لنا باستخدام تسجيلاتك الصوتية لتحسين الذكاء الاصطناعي.

                    تسجيلاتك خاصة ولن يتم مشاركتها أو نشرها أبدًا.

                    هذا الخيار اختياري بالكامل ولن يؤثر على استخدامك للتطبيق.
                    """)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(Color("Text"))
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    HStack {
                        
                        Toggle("", isOn: $allowVoiceData)
                            .labelsHidden()
                        
                        Spacer()
                        
                        Text("السماح باستخدام البيانات الصوتية")
                            .foregroundColor(Color("Text"))
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("ButtonColor").opacity(0.25))
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding()
                .offset(y: 30)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    if allowVoiceData {
                        onAccept()
                    } else {
                        onRefuse()
                    }
                }) {
                    Text("متابعة")
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
                .offset(y: -64)
            }
        }
    }
}
