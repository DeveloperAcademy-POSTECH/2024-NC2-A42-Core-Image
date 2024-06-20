# 2024-NC2-A42-Core-Image
## 🎥 Youtube Link
(추후 만들어진 유튜브 링크 추가)

## 💡 About Core Image
(해당 기술에 대한 조사 내용 정리)

<br/>
1. 필터 지원(CIFilter, CIColorControls, CIGaussianBlur) <br/>
다양한 이미지 필터 제공(블러, 색상조정, 왜곡, 노이즈 감소, 크로마키 등) <br/>
이미지의 색상과 톤 세밀하게 조정<br/>
<br/>
2. 이미지 처리(CIFilter, CIContext) <br/>
여러 필터를 체인 방식으로 결합해 복잡한 이미지 처리 가능 <br/>
GPU를 활용해 고성능 이미지 처리를 지원. 실시간으로 필터를 적용해 결과를 렌더링 <br/>
<br/>
3. 영상 및 이미지 분석(CIDetector, CIFaceFeature, CITextFeature) <br/>
얼굴, 텍스트, QR코드 등을 감지하는 이미지 분석 기능 제공 <br/>
<br/>
4. 이미지 조합 및 생성(CIFilter, CIImage, CIBlendWithMask) <br/>
이미지 오버레이, 마스크, 블렌딩 등 작업 수행 <br/>
<br/>


## 🎯 What we focus on?
Core Image의 CIFilter를 사용해 이미지에 필터를 씌워보자!

## 💼 Use Case
음식 사진을 재미있게 찍고, 편집하자!

## 🖼️ Prototype
(프로토타입과 설명 추가)

## 🛠️ About Code
필터 객체를 생성하고 이미지에 필터를 적용하는 방법 <br/>

```swift
private func getBumpDistortion(_ image: UIImage) -> CIFilter? {
        let filter = CIFilter.bumpDistortion()
        filter.inputImage = CIImage(image: image)
        filter.center = CGPoint(x: image.size.width/2, y: image.size.height/2)
        filter.radius = Float(image.size.width)/2.0
        filter.scale = 0.7
        return filter
    }
```

1. 필터 객체 생성
```swift
filter = CIFilter.bumpDistortion()
```

2. 필터를 적용할 이미지 입력
```swift
filter.inputImage = CIImage(image: image)
```

3. 필터 세부 조정값 입력
```swift
filter.center = CGPoint(x: image.size.width/2, y: image.size.height/2)
filter.radius = Float(image.size.width)/2.0
filter.scale = 0.7
```

4. 필터 적용된 이미지 출력
```swift
filter.outputImage
```





