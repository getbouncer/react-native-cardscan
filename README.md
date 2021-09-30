# CardScan
This repository contains the open source code for [CardScan](https://www.getbouncer.com)'s react-native implementation.

[CardScan](https://www.getbouncer.com/) is a relatively small library that provides fast and accurate payment card scanning.

CardScan is the foundation for CardVerify enterprise libraries, which validate the authenticity of payment cards as they are scanned.

![Android Lint](https://github.com/getbouncer/react-native-cardscan/workflows/Android%20Lint/badge.svg)
![Android Unit Tests](https://github.com/getbouncer/react-native-cardscan/workflows/Android%20Unit%20Tests/badge.svg)
![Android Instrumentation Tests](https://github.com/getbouncer/react-native-cardscan/workflows/Android%20Instrumentation%20Tests/badge.svg)
![Release](https://github.com/getbouncer/react-native-cardscan/workflows/Release/badge.svg)
[![GitHub release](https://img.shields.io/github/release/getbouncer/react-native-cardscan.svg?maxAge=60)](https://github.com/getbouncer/react-native-cardscan/releases)

Native libraries for [android](https://github.com/getbouncer/cardscan-andorid) and [iOS](https://github.com/getbouncer/cardscan-ios) are also available in github.

CardScan is open source, and available under a free-to-try license. See the [license](#license) section for details.

![demo](docs/images/demo.gif)

## Contents
* [Requirements](#requirements)
* [Demo](#demo)
* [Integration](#integration)
* [Customizing](#customizing)
* [Developing](#developing)
* [Troubleshooting](#troubleshooting)
* [Authors](#authors)
* [License](#license)

## Requirements
* Android API level 21 or higher
* iOS version 11 or higher

## Demo
This repository contains a demonstration app for the CardScan product. To build and run the demo app, follow the instructions in the [example app documentation](https://docs.getbouncer.com/card-scan/react-native-integration-guide#example-app).

## Integration
See the [integration documentation](https://docs.getbouncer.com/card-scan/react-native-integration-guide) in the Bouncer Docs.

### Provisioning an API key
CardScan requires a valid API key to run. To provision an API key, visit the [Bouncer API console](https://api.getbouncer.com/console).

### Name and expiration extraction support (BETA)
To test name and/or expiration extraction, please first provision an API key, then reach out to [support@getbouncer.com](mailto:support@getbouncer.com) with details about your use case and estimated volumes.

Follow the [configuration guide](https://docs.getbouncer.com/card-scan/react-native-integration-guide#configuration) to enable name and expiry extraction support.

## Troubleshooting
See the [troubleshooting page](https://docs.getbouncer.com/card-scan/react-native-integration-guide/troubleshooting) in the Bouncer Docs to check if we have covered common issues.

## Authors
Adam Wushensky, Jaime Park, Sam King, and Zain ul Abi Din

## License
This library is available under paid and free licenses. See the [LICENSE](LICENSE) file for the full license text.

### Quick summary
In short, this library will remain free forever for non-commercial applications, but use by commercial applications is limited to 90 days, after which time a licensing agreement is required. We're also adding some legal liability protections.

After this period commercial applications need to convert to a licensing agreement to continue to use this library.
* Details of licensing (pricing, etc) are available at [https://getbouncer.com/pricing](https://getbouncer.com/pricing), or you can contact us at [license@getbouncer.com](mailto:license@getbouncer.com).

### More detailed summary
What's allowed under the license:
* Free use for any app for 90 days (for demos, evaluations, hackathons, etc).
* Contributions (contributors must agree to the [Contributor License Agreement](Contributor%20License%20Agreement))
* Any modifications as needed to work in your app

What's not allowed under the license:
* Commercial applications using the license for longer than 90 days without a license agreement. 
* Using us now in a commercial app today? No worries! Just email [license@getbouncer.com](mailto:license@getbouncer.com) and we’ll get you set up.
* Redistribution under a different license
* Removing attribution
* Modifying logos
* Indemnification: using this free software is ‘at your own risk’, so you can’t sue Bouncer Technologies, Inc. for problems caused by this library

Questions? Concerns? Please email us at [license@getbouncer.com](mailto:license@getbouncer.com) or ask us on [slack](https://getbouncer.slack.com).
