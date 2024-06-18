//
//  SingleImageView.swift
//  CoreImageFun_UI
//
//  Created by Jerrie on 6/18/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct SingleImageView: View {
    @Binding var filter: FilterModel
    private let context = CIContext()
    
    var body: some View {
        Text(filter.title)
        if let outputImage = filter.filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            
            Image(uiImage: UIImage(cgImage: cgImage))
                .resizable()
                .scaledToFit()
                .frame(width: 350)
            
            Button("Save to Album") {
                UIImageWriteToSavedPhotosAlbum(UIImage(cgImage: cgImage), self, nil, nil);
            }
            .padding()
            
        }
    }
    
}

#Preview {
    guard let fileURL = Bundle.main.url(forResource: "pudding", withExtension: "jpg"),
          let image = UIImage(contentsOfFile: fileURL.path),
          let ciImage = CIImage(image: image) else {
        return AnyView(Text("이미지를 불러올 수 없습니다."))
    }
    
    var filter = FilterModel(filter: CIFilter.sepiaTone(), title: "Sepia Tone")
    filter.filter.setValue(ciImage, forKey: kCIInputImageKey)
    filter.filter.setValue(0.8, forKey: kCIInputIntensityKey)
    
    return AnyView(SingleImageView(filter: .constant(filter)))
}
