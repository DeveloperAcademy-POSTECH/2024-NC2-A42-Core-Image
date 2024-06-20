//
//  PhotosPick.swift
//  CoreImageFun_UI
//
//  Created by Jerrie on 6/17/24.
//

import SwiftUI
import PhotosUI


struct PhotoPickView: View {
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
                
                HStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 160, height: 250)
                            .background(.white)
                            .shadow(color: .black.opacity(0.15), radius: 7.5, x: 0, y: 2)
                        
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 140, height: 230)
                                .clipped()
                        } else {
                            Text("?")
                                .font(.system(size: 100))
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 130, height: 250)
                }
                .padding()
                Spacer()
                
                if selectedImage != nil {
                    Text("이 사진으로 할까요?")
                        .font(.body)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    NavigationLink {
                        FilterListView(selectedImage: selectedImage!)
                    } label: {
                        Text("필터 적용하기")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 199, height: 68, alignment: .center)
                            .background(Color(red: 0, green: 0.48, blue: 1))
                            .cornerRadius(12)
                    }
                }
                
                // 사진 불러오기 : 카메라로 촬영하기
                Button{
                    isImagePickerPresented = true
                } label: {
                    HStack(alignment: .center, spacing: 4) {
                        Text("카메라 열기")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .frame(width: 199, height: 68, alignment: .center)
                    .background(Color(red: 0, green: 0.48, blue: 1))
                    .cornerRadius(12)
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(isPresented: $isImagePickerPresented, selectedImage: $selectedImage)
                }
                
                PhotosPicker(selection: Binding(get: {
                    selectedItem
                }, set: { newItem in
                    selectedItem = newItem
                    if let newItem = newItem {
                        Task {
                            do {
                                let data = try await newItem.loadTransferable(type: Data.self)
                                guard let data = data else {
                                    print("No data found")
                                    return
                                }
                                selectedImage = UIImage(data: data)
                            } catch {
                                print("Error loading image: \(error.localizedDescription)")
                            }
                        }
                    }
                }), matching: .images, photoLibrary: .shared()) {
                    HStack(alignment: .center, spacing: 4) {
                        Text("갤러리 열기")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .frame(width: 198, height: 68, alignment: .center)
                    .background(Color(red: 0, green: 0.48, blue: 1))
                    .cornerRadius(12)
                }
            }
            .padding(40)
        }
    }
}

#Preview {
    PhotoPickView()
}
