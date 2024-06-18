//
//  FilterListView.swift
//  CoreImageFun_UI
//
//  Created by Jerrie on 6/18/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct FilterModel: Identifiable, Hashable {
    var id: UUID = UUID()
    var filter: CIFilter
    var title: String
}

extension UIImage {
    func getfilterList() -> [FilterModel] {
        var result: [FilterModel] = []
        
        if let sepiatone = getSepiatone(self) {
            result.append(FilterModel(filter: sepiatone, title: "sepia tone"))
        }
        
        if let photoEffectChorme = getPhotoEffectChrome(self) {
            result.append(FilterModel(filter: photoEffectChorme, title: "photo effect chrome"))
        }
        
        // 필터가 잘 작동하지 않아서 일단 뺌
        //        if let bumpDistortion = getBumpDistortion(self) {
        //            result.append(FilterModel(filter: bumpDistortion, title: "bump distortion"))
        //        }
        
        if let colorCrossPolynomial = getColorCrossPolynomial(self) {
            result.append(FilterModel(filter: colorCrossPolynomial, title: "color cross polynomial"))
        }
        
        if let comicEffect = getComicEffect(self) {
            result.append(FilterModel(filter: comicEffect, title: "comic effect"))
        }
        
        return result
    }
    
    private func getSepiatone(_ image: UIImage) -> CIFilter? {
        let filter = CIFilter.sepiaTone()
        filter.inputImage = CIImage(image: image)
        filter.intensity = 0.8
        return filter
    }
    
    private func getPhotoEffectChrome(_ image: UIImage) -> CIFilter? {
        let filter = CIFilter.photoEffectChrome()
        filter.inputImage = CIImage(image: image)
        return filter
    }
    
    private func getBumpDistortion(_ image: UIImage) -> CIFilter? {
        let filter = CIFilter.bumpDistortion()
        filter.inputImage = CIImage(image: image)
        filter.center = CGPoint(x: image.size.width/2, y: image.size.height/2)
        filter.radius = 120.00
        filter.scale = 0.5
        return filter
    }
    
    private func getColorCrossPolynomial(_ image: UIImage) -> CIFilter? {
        let filter = CIFilter.colorCrossPolynomial()
        filter.inputImage = CIImage(image: image)
        filter.redCoefficients = CIVector(values: [0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.1, 1.0, 0.1, 0.0], count: 10)
        filter.greenCoefficients = CIVector(values: [0.0, 0.5, 0.0, 0.0, 0.1, 0.1, 0.0, 0.0, 0.0, 0.0], count: 10)
        filter.blueCoefficients = CIVector(values: [0.2, 0.1, 0.2, 0.1, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0], count: 10)
        return filter
    }
    
    private func getComicEffect(_ image: UIImage) -> CIFilter? {
        let filter = CIFilter.comicEffect()
        filter.inputImage = CIImage(image: image)
        
        return filter
    }
}

// 메인 뷰
struct FilterListView: View {
    var selectedImage: UIImage
    @State private var filterList: [FilterModel] = []
    private let context = CIContext()
    
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                
                ForEach($filterList) { $filter in
                    VStack {
                        NavigationLink {
                            SingleImageView(filter: $filter)
                        } label: {
                            if let outputImage = filter.filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                                
                                Image(uiImage: UIImage(cgImage: cgImage))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150)
                            }
                        }
                        Text("\(filter.title)")
                    }
                }
            }
        }
        .onAppear {
                    self.filterList = selectedImage.getfilterList()
                }
    }
}

#Preview {
    guard let fileURL = Bundle.main.url(forResource: "pudding", withExtension: "jpg"),
          let image = UIImage(contentsOfFile: fileURL.path),
          let ciImage = CIImage(image: image) else {
        return AnyView(Text("이미지를 불러올 수 없습니다."))
    }
    
    return AnyView(FilterListView(selectedImage: image))
}
