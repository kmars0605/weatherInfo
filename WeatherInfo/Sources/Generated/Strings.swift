// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum CommunicationErrorView {
    internal enum Title {
      /// 通信に失敗しました
      internal static let text = L10n.tr("Localizable", "CommunicationErrorView.Title.Text")
    }
  }

  internal enum InitialInputOfPlace {
    /// 位置情報を登録してください
    internal static let text = L10n.tr("Localizable", "InitialInputOfPlace.Text")
  }

  internal enum InputOfPlace {
    /// 位置情報を入力
    internal static let text = L10n.tr("Localizable", "InputOfPlace.Text")
  }

  internal enum LaundryIndexErrorView {
    internal enum Title {
      /// エラー
      internal static let text = L10n.tr("Localizable", "LaundryIndexErrorView.Title.Text")
    }
  }

  internal enum LaundryIndexLevel1 {
    internal enum TiTle {
      /// 乾かない
      internal static let text = L10n.tr("Localizable", "LaundryIndexLevel1.TiTle.Text")
    }
  }

  internal enum LaundryIndexLevel2 {
    internal enum TiTle {
      /// あまり乾かない
      internal static let text = L10n.tr("Localizable", "LaundryIndexLevel2.TiTle.Text")
    }
  }

  internal enum LaundryIndexLevel3 {
    internal enum TiTle {
      /// やや乾く
      internal static let text = L10n.tr("Localizable", "LaundryIndexLevel3.TiTle.Text")
    }
  }

  internal enum LaundryIndexLevel4 {
    internal enum TiTle {
      /// 乾く
      internal static let text = L10n.tr("Localizable", "LaundryIndexLevel4.TiTle.Text")
    }
  }

  internal enum LaundryIndexLevel5 {
    internal enum TiTle {
      /// よく乾く
      internal static let text = L10n.tr("Localizable", "LaundryIndexLevel5.TiTle.Text")
    }
  }

  internal enum LocationErrorView {
    internal enum Message {
      /// 他の位置情報を\n入力してください。
      internal static let text = L10n.tr("Localizable", "LocationErrorView.Message.Text")
    }
    internal enum Title {
      /// 位置情報なし
      internal static let text = L10n.tr("Localizable", "LocationErrorView.Title.Text")
    }
  }

  internal enum SafariURL {
    /// https://forms.gle/U6PhvHVNUxH6zgJD9
    internal static let text = L10n.tr("Localizable", "SafariURL.Text")
  }

  internal enum SearchErrorView {
    internal enum Title {
      /// 検索に失敗しました。
      internal static let text = L10n.tr("Localizable", "SearchErrorView.Title.Text")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
