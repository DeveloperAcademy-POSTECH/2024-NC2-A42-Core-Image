//
//  SingleImageView.swift
//  CoreImageFun_UI
//
//  Created by Jerrie on 6/18/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

// 필터가 적용된 이미지 하나를 보여주고, 저장할 수 있는 뷰
struct SingleImageView: View {
    @Binding var filter: FilterModel
    var originalImage: UIImage
    @State var isFiltered = true
    private let context = CIContext()
    
    var cgImage: CGImage? {
        guard
            let outputImage = filter.filter.outputImage,
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return cgImage
    }
    
    var body: some View {
        VStack {
            Button {
                isFiltered.toggle()
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    if let cgImage = cgImage {
                        if isFiltered {
                            imageView(UIImage(cgImage: cgImage)) // 필터 적용된 이미지
                            layerIconView("square.2.layers.3d.top.filled") // 필터 적용 아이콘
                        } else {
                            imageView(originalImage) // 원본 이미지
                            layerIconView("square.2.layers.3d.bottom.filled") // 원본 아이콘
                        }
                    }
                }
                
            }
            
        }
        .toolbar(content: {
            Button {
                if let cgImage {
                    UIImageWriteToSavedPhotosAlbum(UIImage(cgImage: cgImage), self, nil, nil);
                }
            } label: {
                // 버튼 디자인
                Image(systemName: "square.and.arrow.down")
            }
        })
        .navigationTitle(filter.title)
    }
    
    // 사진 View
    @ViewBuilder
    func imageView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: 350)
    }
    
    // 필터/원본 아이콘 View
    @ViewBuilder
    func layerIconView(_ type: String) -> some View {
            Image(systemName: type)
                .foregroundColor(.white)
                .padding(10)
                .background(.black.opacity(0.1))
                .cornerRadius(10)
                .padding(9)
    }
    
}

#Preview {
    guard let fileURL = Bundle.main.url(forResource: "pudding", withExtension: "jpg"),
          let image = UIImage(contentsOfFile: fileURL.path) else {
        return AnyView(Text("이미지를 불러올 수 없습니다."))
    }
    
    @State var filter = FilterModel(filter: CIFilter.sepiaTone(), title: "Sepia Tone")
    let ciImage = CIImage(image: image)
    filter.filter.setValue(ciImage, forKey: kCIInputImageKey)
    filter.filter.setValue(0.8, forKey: kCIInputIntensityKey)
    
    return AnyView(SingleImageView(filter: $filter, originalImage: image))
}

