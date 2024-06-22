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
                                    .scaledToFit()
                                    .frame(width: 150)
                            }
                        }
                        Text("\(filter.title)")
                    }
                    .padding()
                    .background(.white)
                    .shadow(color: .black.opacity(0.15), radius: 7.5, x: 0, y: 2)
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
