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
            
            Text("사진을 편집해보아요")
            
            // 사진 불러오기 : 갤러리에 있는 사진 선택하기
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                // 버튼 디자인
                    Text("사진 선택하기")
                }
                .onChange(of: selectedItem) { newItem, _ in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                            selectedImage = UIImage(data: selectedImageData!)
                        }
                    }
                }
            
            
            // 사진 불러오기 : 카메라로 촬영하기
            Button{
                isImagePickerPresented = true
            } label: {
                // 버튼 디자인
                Text("Open Camera")
            }
            .padding()
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(isPresented: $isImagePickerPresented, selectedImage: $selectedImage)
            }
            
            // 불러온 사진이 있을 경우 보여주기
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            
                // 사진이 있을 경우 다음 페이지로 넘어가는 버튼 활성화
                NavigationLink {
                    FilterListView(selectedImage: selectedImage)
                } label: {
                    // 버튼 디자인
                    Text("필터 적용하기")
                }
            } else {
                Text("사진을 선택하세요")
            }
        }
        
    }
}

#Preview {
    PhotoPickView()
}
