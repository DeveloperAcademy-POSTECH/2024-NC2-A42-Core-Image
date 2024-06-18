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
    
    var body: some View {
        NavigationStack {
            
            Text("사진을 편집해보아요")
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Text("사진 선택하기")
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                NavigationLink( destination: FilterListView(selectedImage: uiImage)) {
                    Text("필터 적용하기")
                }
            }
        }
        
    }
}

#Preview {
    PhotoPickView()
}
