//
//  RNCardScanStyle.swift
//  RNCardscan
//
//  Created by Jaime Park on 9/22/21.
//  Copyright © 2021 Facebook. All rights reserved.
//

import CoreGraphics
import Foundation

public enum TorchPosition: Int {
    case topRight = 0
    case bottom = 1
}

public struct RNCardScanStyle: Decodable {
  var backButtonTintColor: String?
  var backButtonText: String?

  var backgroundColor: String?
  var backgroundColorOpacity: CGFloat?

  var cardDetailExpiryTextColor: String?
  var cardDetailNameTextColor: String?
  var cardDetailNumberTextColor: String?

  var descriptionHeaderText: String?
  var descriptionHeaderTextColor: String?
  var descriptionHeaderTextFont: String?
  var descriptionHeaderTextSize: CGFloat?

  var enableCameraPermissionText: String?
  var enableCameraPermissionTextColor: String?
  var enableCameraPermissionTextFont: String?
  var enableCameraPermissionTextSize: CGFloat?

  var instructionText: String?
  var instructionTextFont: String?
  var instructionTextColor: String?
  var instructionTextSize: CGFloat?

  var roiBorderColor: String?
  var roiCornerRadius: CGFloat?

  var torchButtonTintColor: String?
  var torchButtonPosition: Int?
  var torchButtonText: String?
}
