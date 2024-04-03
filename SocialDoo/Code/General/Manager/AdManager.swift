//
//  AdManager.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 03.04.24.
//

import Foundation
import GoogleMobileAds
import Combine

@Observable
class AdManager: NSObject {
  static let shared = AdManager()
  
  var setupDone: Bool = false
  var interstitial: GADInterstitialAd?
  
  var deactivated: Bool = false
  
  override private init() {
    super.init()
    
    GADMobileAds.sharedInstance().start { [weak self] value in
      guard let self else { return }
    
      self.setupDone = true
      self.loadInterstitial()
    }
  }
  
  func showInterstitial() {
    guard !deactivated else { return }
    guard let interstitial else { return }
    interstitial.present(fromRootViewController: nil)
  }
  
  func deactivateAds() {
    deactivated = true
  }
  
  func loadInterstitial() {
    Task {
      do {
        interstitial = try await GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest())
        interstitial?.fullScreenContentDelegate = self
      } catch {
        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
      }
    }
  }
}

extension AdManager: GADFullScreenContentDelegate {
  /// Tells the delegate that the ad failed to present full screen content.
  func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    print("Ad did fail to present full screen content.")
  }
  
  /// Tells the delegate that the ad will present full screen content.
  func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("Ad will present full screen content.")
  }
  
  /// Tells the delegate that the ad dismissed full screen content.
  func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("Ad did dismiss full screen content.")
    
    interstitial = nil
    loadInterstitial()
  }
}
