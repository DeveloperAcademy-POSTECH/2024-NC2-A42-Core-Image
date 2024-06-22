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
                
                // 선택된 이미지 보여주기
                showSelectedImage()
                
                HStack{
                    // 사진 불러오기 : 카메라로 촬영하기
                    takePhotoButton()
                    
                    // 사진 불러오기 : 갤러리에서 이미지 선택
                    selectPhotoButton()
                }
            }
            .padding(10)
        }
        
        if selectedImage != nil {
            NavigationLink(destination: FilterListView(selectedImage: fixOrientation(img: selectedImage!))) {
                designedButton("필터 적용하기", isAble: true)
            }
        } else {
            designedButton("사진을 선택해주세요", isAble: false)
        }
    }
    
    // 선택된 이미지 보여주기
    @ViewBuilder
    func showSelectedImage() -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 300, height: 380)
                .background(.white)
                .shadow(color: .black.opacity(0.15), radius: 7.5, x: 0, y: 2)
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 350)
                    .clipped()
            } else {
                Image(systemName: "fork.knife")
                    .font(.system(size: 100))
                    .foregroundColor(.gray)
            }
        }
        .padding(20)
    }
    
    // 사진 불러오기 : 카메라로 촬영하기
    @ViewBuilder
    func takePhotoButton() -> some View {
        Button{
            isImagePickerPresented = true
        } label: {
            HStack(alignment: .center, spacing: 4) {
                VStack{
                    Image(systemName: "camera.fill")
                        .font(.system(size: 50))
                        .padding(2)
                    Text("직접 촬영하기")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color.point)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(isPresented: $isImagePickerPresented, selectedImage: $selectedImage)
        }
    }
    
    // 사진 불러오기 : 갤러리에서 이미지 선택
    @ViewBuilder
    func selectPhotoButton() -> some View {
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
                VStack{
                    Image(systemName: "photo.fill")
                        .font(.system(size: 50))
                        .padding(2)
                    Text("사진 선택하기")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color.point)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
        }
    }
    
    // 버튼 디자인
    @ViewBuilder
    func designedButton(_ text: String, isAble: Bool) -> some View {
        if isAble {
            Text(text)
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 359, height: 50, alignment: .center)
                .background(Color(UIColor(named: "PointColor")!))
                .cornerRadius(12)
        } else {
            Text(text)
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 359, height: 50, alignment: .center)
                .background(Color.gray)
                .cornerRadius(12)
        }
    }
    
}

#Preview {
    PhotoPickView()
}
