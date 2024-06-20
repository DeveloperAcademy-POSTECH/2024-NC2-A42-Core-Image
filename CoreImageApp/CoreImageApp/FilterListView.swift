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

// 필터 목록 (새로운 필터는 여기에 추가하면 됨)
// get으로 시작하는 이름의 필터 적용하는 함수 만들고, getfilterList() 함수에서 if let ~ 부분 추가
extension UIImage {
    func getfilterList() -> [FilterModel] {
        var result: [FilterModel] = []
        
        if let sepiatone = getSepiatone(self) {
            result.append(FilterModel(filter: sepiatone, title: "sepia tone"))
        }
        
        if let photoEffectChorme = getPhotoEffectChrome(self) {
            result.append(FilterModel(filter: photoEffectChorme, title: "photo effect chrome"))
        }
        
        
        if let bumpDistortion = getBumpDistortion(self) {
            result.append(FilterModel(filter: bumpDistortion, title: "bump distortion"))
        }
        
        if let colorCrossPolynomial = getColorCrossPolynomial(self) {
            result.append(FilterModel(filter: colorCrossPolynomial, title: "color cross polynomial"))
        }
        
        if let comicEffect = getComicEffect(self) {
            result.append(FilterModel(filter: comicEffect, title: "comic effect"))
        }
        
        if let convolution9Vertical = getConvolution9Vertical(self) {
            result.append(FilterModel(filter: convolution9Vertical, title: "convolution 9 vertical"))
        }
        
        if let bloom = getBloom(self) {
            result.append(FilterModel(filter: bloom, title: "bloom"))
        }
        
        if let photoeffecttransfer = getPhotoEffectTransfer(self) {
            result.append(FilterModel(filter: photoeffecttransfer, title: "photo effect transfer"))
        }
        
        if let photoeffecttonal = getPhotoEffectTonal(self) {
            result.append(FilterModel(filter: photoeffecttonal, title: "photo effect tonal"))
        }
        
        return result
    }
    
    private func getSepiatone(_ image: UIImage) -> CIFilter? {
        let filter = CIFilter.sepiaTone()
        filter.inputImage = CIImage(image: image)
        filter.intensity = 0.5
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
        filter.radius = Float(image.size.width)/2.0
        filter.scale = 0.7
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
    
    private func getConvolution9Vertical(_ image: UIImage) -> CIFilter? {
        let filter = CIFilter.convolution9Vertical()
        filter.inputImage = CIImage(image: image)
        filter.weights = CIVector(values: [1.2, -1.3, 1, 0, 1, 0, -1, 1, -1], count: 9)
        filter.bias = 0.0
        
        return filter
    }
    
    private func getBloom(_ image: UIImage) -> CIFilter? {
        let filter = CIFilter.bloom()
        filter.inputImage = CIImage(image: image)
        // filter.radius = 10.00
        //filter.intensity = 1
        
        return filter
    }
    
    private func getPhotoEffectTransfer(_ image: UIImage) -> CIFilter? {
        let filter = CIFilter.photoEffectTransfer()
        filter.inputImage = CIImage(image: image)
        
        return filter
    }
    
    private func getPhotoEffectTonal(_ image: UIImage) -> CIFilter? {
        let filter = CIFilter.photoEffectTonal()
        filter.inputImage = CIImage(image: image)
        
        return filter
    }
}

// 선택된 이미지에 각 필터별로 적용된 모습을 보여주는 화면
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
                        // 각 이미지를 누르면 상세 화면으로 이동
                        NavigationLink {
                            SingleImageView(filter: $filter, originalImage: selectedImage)
                        } label: {
                            
                            if let outputImage = filter.filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                                // 디자인
                                Image(uiImage: UIImage(cgImage: cgImage))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150)
                            }
                        }
                        
                        // 일단 텍스트는 터치 영역에서 제외시켜두었음 ...
                        Text("\(filter.title)")
                    }
                }
            }
            .navigationTitle("필터 갤러리")
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
