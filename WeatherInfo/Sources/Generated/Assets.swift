// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let _01d = ImageAsset(name: "01d")
  internal static let _01n = ImageAsset(name: "01n")
  internal static let _02d = ImageAsset(name: "02d")
  internal static let _02n = ImageAsset(name: "02n")
  internal static let _03d = ImageAsset(name: "03d")
  internal static let _03n = ImageAsset(name: "03n")
  internal static let _04d = ImageAsset(name: "04d")
  internal static let _04n = ImageAsset(name: "04n")
  internal static let _09d = ImageAsset(name: "09d")
  internal static let _09n = ImageAsset(name: "09n")
  internal static let _10d = ImageAsset(name: "10d")
  internal static let _10n = ImageAsset(name: "10n")
  internal static let _11d = ImageAsset(name: "11d")
  internal static let _11n = ImageAsset(name: "11n")
  internal static let _13d = ImageAsset(name: "13d")
  internal static let _13n = ImageAsset(name: "13n")
  internal static let _50d = ImageAsset(name: "50d")
  internal static let _50n = ImageAsset(name: "50n")
  internal static let icon = ImageAsset(name: "Icon")
  internal static let iconMono = ImageAsset(name: "Icon_mono")
  internal static let home = ImageAsset(name: "home")
  internal static let index1 = ImageAsset(name: "index1")
  internal static let index2 = ImageAsset(name: "index2")
  internal static let index3 = ImageAsset(name: "index3")
  internal static let index4 = ImageAsset(name: "index4")
  internal static let index5 = ImageAsset(name: "index5")
  internal static let pin = ImageAsset(name: "pin")
  internal static let rain = ImageAsset(name: "rain")
  internal static let setting = ImageAsset(name: "setting")
  internal static let tag = ImageAsset(name: "tag")
  internal static let 晴れ夜 = ImageAsset(name: "晴れ(夜)")
  internal static let 晴れ夜のち曇り = ImageAsset(name: "晴れ(夜)のち曇り")
  internal static let 晴れ夜のち雨 = ImageAsset(name: "晴れ(夜)のち雨")
  internal static let 晴れ夜のち雪 = ImageAsset(name: "晴れ(夜)のち雪")
  internal static let 晴れ夜時々曇り = ImageAsset(name: "晴れ(夜)時々曇り")
  internal static let 晴れ夜時々雨 = ImageAsset(name: "晴れ(夜)時々雨")
  internal static let 晴れ夜時々雪 = ImageAsset(name: "晴れ(夜)時々雪")
  internal static let 晴れ = ImageAsset(name: "晴れ")
  internal static let 晴れのち曇り = ImageAsset(name: "晴れのち曇り")
  internal static let 晴れのち雨 = ImageAsset(name: "晴れのち雨")
  internal static let 晴れのち雪 = ImageAsset(name: "晴れのち雪")
  internal static let 晴れ時々曇り = ImageAsset(name: "晴れ時々曇り")
  internal static let 晴れ時々雨 = ImageAsset(name: "晴れ時々雨")
  internal static let 晴れ時々雪 = ImageAsset(name: "晴れ時々雪")
  internal static let 暴風雨 = ImageAsset(name: "暴風雨")
  internal static let 暴風雪 = ImageAsset(name: "暴風雪")
  internal static let 曇り = ImageAsset(name: "曇り")
  internal static let 曇りのち晴れ夜 = ImageAsset(name: "曇りのち晴れ(夜)")
  internal static let 曇りのち晴れ = ImageAsset(name: "曇りのち晴れ")
  internal static let 曇りのち雨 = ImageAsset(name: "曇りのち雨")
  internal static let 曇りのち雪 = ImageAsset(name: "曇りのち雪")
  internal static let 曇り時々晴れ夜 = ImageAsset(name: "曇り時々晴れ(夜)")
  internal static let 曇り時々晴れ = ImageAsset(name: "曇り時々晴れ")
  internal static let 曇り時々雨 = ImageAsset(name: "曇り時々雨")
  internal static let 曇り時々雪 = ImageAsset(name: "曇り時々雪")
  internal static let 雨のち晴れ夜 = ImageAsset(name: "雨のち晴れ(夜)")
  internal static let 雨のち晴れ = ImageAsset(name: "雨のち晴れ")
  internal static let 雨のち曇り = ImageAsset(name: "雨のち曇り")
  internal static let 雨のち雪 = ImageAsset(name: "雨のち雪")
  internal static let 雨時々晴れ夜 = ImageAsset(name: "雨時々晴れ(夜)")
  internal static let 雨時々晴れ = ImageAsset(name: "雨時々晴れ")
  internal static let 雨時々曇り = ImageAsset(name: "雨時々曇り")
  internal static let 雨時々雪 = ImageAsset(name: "雨時々雪")
  internal static let 雪 = ImageAsset(name: "雪")
  internal static let 雪のち晴れ夜 = ImageAsset(name: "雪のち晴れ(夜)")
  internal static let 雪のち晴れ = ImageAsset(name: "雪のち晴れ")
  internal static let 雪のち曇り = ImageAsset(name: "雪のち曇り")
  internal static let 雪のち雨 = ImageAsset(name: "雪のち雨")
  internal static let 雪時々晴れ夜 = ImageAsset(name: "雪時々晴れ(夜)")
  internal static let 雪時々晴れ = ImageAsset(name: "雪時々晴れ")
  internal static let 雪時々曇り = ImageAsset(name: "雪時々曇り")
  internal static let 雪時々雨 = ImageAsset(name: "雪時々雨")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
