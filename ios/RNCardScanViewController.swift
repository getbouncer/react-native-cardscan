//
//  RNCardScanViewController.swift
//  RNCardScan
//
//  Created by Jaime Park on 9/23/21.
//  Copyright © 2021 Facebook. All rights reserved.
//

import CardScan
import Foundation
import UIKit

// MARK: Custom Scan
@available(iOS 11.2, *)
class RNCardScanViewController: SimpleScanViewController {
    var scanStyle = RNCardScanStyle()
    lazy var instructionLabel = UILabel()

    init(viewStyle: NSDictionary?) {
        super.init(nibName: nil, bundle: nil)
        handleScanStyleDictionary(viewStyle: viewStyle)
    }

    @objc required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
      super.viewDidLoad()
    }

    func handleScanStyleDictionary(viewStyle: NSDictionary?) {
        guard let dict = viewStyle,
              let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
              let decodedScanStyle = try? JSONDecoder().decode(RNCardScanStyle.self, from: data) else {
            return
        }

        self.scanStyle = decodedScanStyle
    }

    override func setupUiComponents() {
        super.setupUiComponents()
        setupInstructionUI()
    }

    override func setupConstraints() {
        super.setupConstraints()

        // only turn on these constraints if we have instructions to show
        if let _ = scanStyle.instructionText {
            instructionLabel.translatesAutoresizingMaskIntoConstraints = false
            instructionLabel.centerXAnchor.constraint(equalTo: roiView.centerXAnchor, constant: 0).isActive = true
            instructionLabel.topAnchor.constraint(equalTo: roiView.bottomAnchor, constant: 15).isActive = true
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        }
    }

    // MARK: -- Instruction UI --
    func setupInstructionUI() {
        if let instructionText = scanStyle.instructionText {
            instructionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 75))
            instructionLabel.text = instructionText
            instructionLabel.textAlignment = .center
            instructionLabel.numberOfLines = 2
            instructionLabel.textColor = .white

            if let instructionTextColor = scanStyle.instructionTextColor {
                instructionLabel.textColor = UIColor(hexString: instructionTextColor)
            }

            if let intructionTextFont = scanStyle.instructionTextFont {
                instructionLabel.font = UIFont(name: intructionTextFont, size: 15)
            }

            if let instructionTextSize = scanStyle.instructionTextSize {
                instructionLabel.font = instructionLabel.font.withSize(instructionTextSize)
            }

            self.view.addSubview(instructionLabel)
        }
    }

    //MARK: -- Background UI --
    override public func setupBlurViewUi() {
        super.setupBlurViewUi()

        if let backgroundColor = scanStyle.backgroundColor {
            blurView.backgroundColor = UIColor(hexString: backgroundColor).withAlphaComponent(scanStyle.backgroundColorOpacity ?? 0.5)
        }
    }

    // MARK: -- ROI UI --
    override public func setupRoiViewUi() {
        super.setupRoiViewUi()
        if let roiCornerRadius = scanStyle.roiCornerRadius {
            regionOfInterestCornerRadius = roiCornerRadius
        }

        if let roiBorderColor = scanStyle.roiBorderColor {
            roiView.layer.borderColor = UIColor(hexString: roiBorderColor).cgColor
        }
    }

    // MARK: -- Description UI --
    override public func setupDescriptionTextUi() {
        super.setupDescriptionTextUi()

        if let descriptionHeaderText = scanStyle.descriptionHeaderText {
            descriptionText.text = descriptionHeaderText
        }

        if let descriptionTextColor = scanStyle.descriptionHeaderTextColor {
            descriptionText.textColor = UIColor(hexString: descriptionTextColor)
        }

        if let descriptionTextFont = scanStyle.descriptionHeaderTextFont {
            descriptionText.font = UIFont(name: descriptionTextFont, size: 30)
        }

        if let descriptionTextSize = scanStyle.descriptionHeaderTextSize {
            descriptionText.font = descriptionText.font.withSize(descriptionTextSize)
        }
    }

    // MARK: -- Close UI --
    override public func setupCloseButtonUi() {
        super.setupCloseButtonUi()
        if let backButtonText = scanStyle.backButtonText {
            closeButton.setTitle(backButtonText, for: .normal)
        } else if let backArrowImage = UIImage(named: "bouncer_scan_back") {
            closeButton.setTitle(scanStyle.backButtonText ?? "", for: .normal)
            closeButton.setImage(backArrowImage, for: .normal)
        }

        if let backButtonTintColor = scanStyle.backButtonTintColor {
            closeButton.tintColor = UIColor(hexString: backButtonTintColor)
        }
    }

    // MARK: -- Torch UI --
    override public func setupTorchButtonUi() {
        super.setupTorchButtonUi()
        if let torchButtonText = scanStyle.torchButtonText {
            torchButton.setTitle(torchButtonText, for: .normal)
        } else if let torchImage = UIImage(named: "bouncer_scan_flash_on") {
            torchButton.setTitle(scanStyle.torchButtonText ?? "", for: .normal)
            torchButton.setImage(torchImage, for: .normal)
        }

        if let torchButtonTintColor = scanStyle.torchButtonTintColor {
            torchButton.tintColor = UIColor(hexString: torchButtonTintColor)
        }
    }

    override public func setupTorchButtonConstraints() {
        let torchButtonPosition = TorchPosition(rawValue: scanStyle.torchButtonPosition ?? 0)
        let margins = view.layoutMarginsGuide

        let topRightConstraints = [
            torchButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 16.0),
            torchButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ]

        let bottomConstraints = [
            torchButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -50.0),
            torchButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0.0)
        ]

        switch torchButtonPosition {
        case .topRight:
            NSLayoutConstraint.activate(topRightConstraints)
        case .bottom:
            NSLayoutConstraint.activate(bottomConstraints)
        case .none:
            NSLayoutConstraint.activate(topRightConstraints)
        }
    }

    override func torchButtonPress() {
        super.torchButtonPress()

        if isTorchOn() {
            torchButton.setImage(UIImage(named: "bouncer_scan_flash_off"), for: .normal)
        } else {
            torchButton.setImage(UIImage(named: "bouncer_scan_flash_on"), for: .normal)
        }
    }

    // MARK: -- Permissions UI --
    override public func setupDenyUi() {
        super.setupDenyUi()

        let text = scanStyle.enableCameraPermissionText ?? RNCardScanViewController.enableCameraPermissionString
        let attributedString = NSMutableAttributedString(string: text)
        enableCameraPermissionsText.text = text

        let textColor = UIColor(hexString: scanStyle.enableCameraPermissionTextColor ?? "#FFFFFF")
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: textColor, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        enableCameraPermissionsText.textColor = textColor

        var font: UIFont? = UIFont.systemFont(ofSize: 20)

        if let enableCameraPermissionFont = scanStyle.enableCameraPermissionTextFont {
            font = UIFont(name: enableCameraPermissionFont, size: 20)
        }

        if let fontSize = scanStyle.enableCameraPermissionTextSize {
            font = font?.withSize(fontSize)
        }

        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: text.count))
        enableCameraPermissionsButton.setAttributedTitle(attributedString, for: .normal)
        enableCameraPermissionsText.textAlignment = .center
    }

    //MARK: -- Card Detail UI --
    override public func setupCardDetailsUi() {
        super.setupCardDetailsUi()

        if let numberColor = scanStyle.cardDetailNumberTextColor {
            numberText.textColor = UIColor(hexString: numberColor)
        }

        if let nameColor = scanStyle.cardDetailNameTextColor {
            nameText.textColor = UIColor(hexString: nameColor)
        }

        if let expiryColor = scanStyle.cardDetailExpiryTextColor {
            expiryText.textColor = UIColor(hexString: expiryColor)
        }
    }
}

