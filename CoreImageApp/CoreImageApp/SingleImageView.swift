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
    
    var body: some View {
        Text(filter.title)
        if let outputImage = filter.filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            if isFiltered {
                Image(uiImage: UIImage(cgImage: cgImage))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
            } else {
                Image(uiImage: originalImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
            }
            
            Button {
                UIImageWriteToSavedPhotosAlbum(UIImage(cgImage: cgImage), self, nil, nil);
            } label: {
                // 버튼 디자인
                Text("Save to Album")
            }
            .padding()
            
            Button {
                isFiltered.toggle()
            } label: {
                Text("원본사진 보기 on/off")
            }
        }
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

