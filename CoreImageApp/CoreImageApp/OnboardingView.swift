//
//  OnboardingView.swift
//  CoreImageApp
//
//  Created by ChoMinKyung on 6/20/24.
//
import SwiftUI
import PhotosUI

struct OnboardingView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("오늘 먹은 식사를 색다르게 남겨보세요!")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                //샘플 이미지
                Image(.SAMPLE)
                    .padding()
                Spacer()
                
                NavigationLink {
                    PhotoPickView()
                } label: {
                    Text("시작하기")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 359, height: 50, alignment: .center)
                        .background(Color(UIColor(named : "PointColor")!))
                        .cornerRadius(12)
                }
            }
        }
    }
}
    
    #Preview {
        OnboardingView()
    }
