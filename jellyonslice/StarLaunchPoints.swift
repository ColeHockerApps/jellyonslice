import Foundation
import Combine
import SwiftUI

@MainActor
final class StarLaunchPoints: ObservableObject {

    @Published var mainPoint: URL
    @Published var privacyPoint: URL

    private let mainKey = "jellyon.slice.stars.main"
    private let privacyKey = "jellyon.slice.stars.privacy"
    private let resumeKey = "jellyon.slice.stars.resume"
    private let marksKey = "jellyon.slice.stars.marks"

    private var didStoreResume = false

    init() {
        let defaults = UserDefaults.standard

        let defaultMain = "https://doancongbang1991.github.io/mobileapp/mobile/jellyslice/"
        let defaultPrivacy = "https://oktaykaangames.github.io/jellyon-slice-stars-privacy"

        if let saved = defaults.string(forKey: mainKey),
           let value = URL(string: saved) {
            mainPoint = value
        } else {
            mainPoint = URL(string: defaultMain)!
        }

        if let saved = defaults.string(forKey: privacyKey),
           let value = URL(string: saved) {
            privacyPoint = value
        } else {
            privacyPoint = URL(string: defaultPrivacy)!
        }
    }

    func updateMain(_ value: String) {
        guard let point = URL(string: value) else { return }
        mainPoint = point
        UserDefaults.standard.set(value, forKey: mainKey)
    }

    func updatePrivacy(_ value: String) {
        guard let point = URL(string: value) else { return }
        privacyPoint = point
        UserDefaults.standard.set(value, forKey: privacyKey)
    }

    func storeResumeIfNeeded(_ point: URL) {
        guard didStoreResume == false else { return }
        didStoreResume = true

        let defaults = UserDefaults.standard
        if defaults.string(forKey: resumeKey) != nil {
            return
        }

        defaults.set(point.absoluteString, forKey: resumeKey)
    }

    func restoreResume() -> URL? {
        let defaults = UserDefaults.standard
        if let saved = defaults.string(forKey: resumeKey),
           let point = URL(string: saved) {
            return point
        }
        return nil
    }

    func saveMarks(_ items: [[String: Any]]) {
        UserDefaults.standard.set(items, forKey: marksKey)
    }

    func loadMarks() -> [[String: Any]]? {
        UserDefaults.standard.array(forKey: marksKey) as? [[String: Any]]
    }

    func resetAll() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: mainKey)
        defaults.removeObject(forKey: privacyKey)
        defaults.removeObject(forKey: resumeKey)
        defaults.removeObject(forKey: marksKey)
        didStoreResume = false
    }
}
