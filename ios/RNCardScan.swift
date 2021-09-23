//
//  RNCardScan.swift
//  RNCardScan
//
//  Created by Jaime Park on 9/22/21.
//  Copyright © 2021 Facebook. All rights reserved.
//

import CardScan
import Foundation
import UIKit

@available(iOS 11.2, *)
@objc(RNCardscan)
class RNCardScan: NSObject {
    var resolve: RCTPromiseResolveBlock?
    var styleDictionary: NSDictionary?

    override init() {
        super.init()
    }

    @objc class func requiresMainQueueSetup() -> Bool {
        return true
    }

    @objc func isSupportedAsync(
        _ resolve: RCTPromiseResolveBlock,
        _ reject: RCTPromiseRejectBlock
    ) -> Void {
        if true {
            resolve([SimpleScanViewController.isCompatible()])
        } else {
            reject(nil, nil, nil)
        }
    }

    @objc func setiOSScanViewStyle(_ styleDictionary: NSDictionary) {
        self.styleDictionary = styleDictionary
    }

    @objc func scan(
        _ resolve: @escaping RCTPromiseResolveBlock,
        _ reject: RCTPromiseRejectBlock
    ) -> Void {
      self.resolve = resolve

      DispatchQueue.main.async {
        let topViewController = self.getTopViewController()
        let vc = RNCardScanViewController(viewStyle: self.styleDictionary)
        vc.delegate = self
        topViewController?.present(vc, animated: true, completion: nil)
      }
    }

    func getTopViewController() -> UIViewController? {
      guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else {
        return nil
      }

      while let nextViewController = topViewController.presentedViewController {
        topViewController = nextViewController
      }

      return topViewController
    }
}

@available(iOS 11.2, *)
extension RNCardScan: SimpleScanDelegate {
    // MARK: -SimpleScanDelegate implementation
    func userDidCancelSimple(_ scanViewController: SimpleScanViewController) {
        if let topViewController = getTopViewController() {
            topViewController.dismiss(animated: true, completion: nil)
        }

        if let resolve = resolve {
            resolve([
                "action": "canceled",
                "canceledReason": "user_canceled"
            ])
        }
    }

    func userDidScanCardSimple(_ scanViewController: SimpleScanViewController, creditCard: CreditCard) {
        if let topViewController = getTopViewController() {
            topViewController.dismiss(animated: true, completion: nil)
        }

        var resolvePayload: [String: Any] = [:]
        resolvePayload["action"] = "scanned"
        resolvePayload["payload"] = {
            var payload: [String: Any] = [:]
            payload["number"] = creditCard.number
            payload["cardholderName"] = creditCard.name
            payload["expiryMonth"] = creditCard.expiryMonth
            payload["expiryYear"] = creditCard.expiryYear
            return payload
        }()

        if let resolve = self.resolve {
            resolve(resolvePayload)
        }
    }
}
