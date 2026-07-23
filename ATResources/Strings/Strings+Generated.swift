// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Strings {
    /// Plural format key: "%#@strand_key@"
    public static func chartKeyStrand(_ p1: Int) -> String {
        return Strings.tr("Localizable", "chart_key_strand", p1, fallback: "Plural format key: \"%#@strand_key@\"")
    }
    /// Plural format key: "%#@count_designers_charts@"
    public static func countOfDesignersCharts(_ p1: Int) -> String {
        return Strings.tr("Localizable", "count_of_designers_charts", p1, fallback: "Plural format key: \"%#@count_designers_charts@\"")
    }
    public enum APIError {
        public enum Backend {
            /// A background error occurred: %@
            public static func background(_ p1: Any) -> String {
                return Strings.tr("Localizable", "APIError.Backend.background", String(describing: p1), fallback: "A background error occurred: %@")
            }
            /// The server returned an error with status code %d.
            public static func httpFailed(_ p1: Int) -> String {
                return Strings.tr("Localizable", "APIError.Backend.httpFailed", p1, fallback: "The server returned an error with status code %d.")
            }
            /// The request timed out. Please check your internet connection.
            public static let requestTimeout = Strings.tr("Localizable", "APIError.Backend.requestTimeout", fallback: "The request timed out. Please check your internet connection.")
            /// Localizable.strings
            ///   KLResources
            ///
            ///   Created by Senla on 29.05.2026.
            public static let unauthorized = Strings.tr("Localizable", "APIError.Backend.unauthorized", fallback: "You are not authorized. Please sign in.")
        }
        public enum Common {
            /// An unknown error occurred: %@
            public static func unknown(_ p1: Any) -> String {
                return Strings.tr("Localizable", "APIError.Common.unknown", String(describing: p1), fallback: "An unknown error occurred: %@")
            }
        }
        public enum InternalError {
            /// The server returned an invalid response.
            public static let badResponse = Strings.tr("Localizable", "APIError.InternalError.badResponse", fallback: "The server returned an invalid response.")
            /// Failed to decode data. Please check the data format from the server.
            public static let dataDecoding = Strings.tr("Localizable", "APIError.InternalError.dataDecoding", fallback: "Failed to decode data. Please check the data format from the server.")
            /// Failed to encode data. Please try again.
            public static let dataEncoding = Strings.tr("Localizable", "APIError.InternalError.dataEncoding", fallback: "Failed to encode data. Please try again.")
            /// The request is invalid. Please check the entered data.
            public static let invalidRequest = Strings.tr("Localizable", "APIError.InternalError.invalidRequest", fallback: "The request is invalid. Please check the entered data.")
            /// The URL is invalid. Please contact support.
            public static let invalidURL = Strings.tr("Localizable", "APIError.InternalError.invalidURL", fallback: "The URL is invalid. Please contact support.")
            /// Failed to delete data
            public static let keychainDeleteFailure = Strings.tr("Localizable", "APIError.InternalError.keychainDeleteFailure", fallback: "Failed to delete data")
            /// Failed to write data
            public static let keychainWriteFailure = Strings.tr("Localizable", "APIError.InternalError.keychainWriteFailure", fallback: "Failed to write data")
            /// Network unavailable. Please check your internet connection.
            public static let networkUnavailable = Strings.tr("Localizable", "APIError.InternalError.networkUnavailable", fallback: "Network unavailable. Please check your internet connection.")
        }
    }
    public enum Home {
        public enum ErrorAlert {
            /// Cancel
            public static let cancel = Strings.tr("Localizable", "Home.ErrorAlert.cancel", fallback: "Cancel")
            /// Retry
            public static let retry = Strings.tr("Localizable", "Home.ErrorAlert.retry", fallback: "Retry")
            /// Error
            public static let title = Strings.tr("Localizable", "Home.ErrorAlert.title", fallback: "Error")
        }
        public enum Screen {
            /// Home
            public static let title = Strings.tr("Localizable", "Home.Screen.title", fallback: "Home")
        }
        public enum Section {
            public enum Posts {
                /// Posts
                public static let title = Strings.tr("Localizable", "Home.Section.Posts.title", fallback: "Posts")
            }
        }
    }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
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
