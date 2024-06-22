//
//  getFilter.swift
//  CoreImageApp
//
//  Created by Jerrie on 6/21/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

// 필터 목록 (새로운 필터는 여기에 추가하면 됨)
// get으로 시작하는 이름의 필터 적용하는 함수 만들고, getfilterList() 함수에서 if let ~ 부분 추가
extension UIImage {
    func getfilterList() -> [FilterModel] {
        var result: [FilterModel] = []
        
        if let sepiatone = getSepiatone(self) {
            result.append(FilterModel(filter: sepiatone, title: "시골 갬성"))
        }
        
        if let photoEffectChorme = getPhotoEffectChrome(self) {
            result.append(FilterModel(filter: photoEffectChorme, title: "새콤달콤"))
        }
        
        
        if let bumpDistortion = getBumpDistortion(self) {
            result.append(FilterModel(filter: bumpDistortion, title: "왕 크니까 왕 맛있다"))
        }
        
        if let colorCrossPolynomial = getColorCrossPolynomial(self) {
            result.append(FilterModel(filter: colorCrossPolynomial, title: "식욕 감퇴 유발"))
        }
        
        if let comicEffect = getComicEffect(self) {
            result.append(FilterModel(filter: comicEffect, title: "뭐 먹었게?"))
        }
        
        if let convolution9Vertical = getConvolution9Vertical(self) {
            result.append(FilterModel(filter: convolution9Vertical, title: "허겁지겁"))
        }
        
        if let bloom = getBloom(self) {
            result.append(FilterModel(filter: bloom, title: "감동적인 맛"))
        }
        
        if let photoeffecttransfer = getPhotoEffectTransfer(self) {
            result.append(FilterModel(filter: photoeffecttransfer, title: "분위기 있는 노란 조명"))
        }
        
        if let photoeffecttonal = getPhotoEffectTonal(self) {
            result.append(FilterModel(filter: photoeffecttonal, title: "음식의 영정사진"))
        }
        
        if let monochrome = getMonochrome(self) {
            result.append(FilterModel(filter: monochrome, title: "포차 바이브"))
        }
        
        if let colorInvert = getColorInvert(self) {
            result.append(FilterModel(filter: colorInvert, title: "아주 그냥 뒤집어지네"))
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
        filter.radius = Float(image.size.width)/2.1
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
    
    private func getMonochrome(_ image: UIImage) -> CIFilter? {
        let filter = CIFilter.colorMonochrome()
        filter.inputImage = CIImage(image: image)
        filter.color = CIColor(color: .blue)
        filter.intensity = 0.7
        return filter
    }
    
    private func getColorInvert(_ image: UIImage) -> CIFilter? {
        let filter = CIFilter.colorInvert()
        filter.inputImage = CIImage(image: image)
        
        return filter
    }
}
