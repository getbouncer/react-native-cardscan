# CardScan

CardScan React Native installation guide

Visit our website at https://cardscan.io for examples. Native libraries for [android](https://github.com/getbouncer/cardscan-andorid) and [iOS](https://github.com/getbouncer/cardscan-ios) are also available in github.

CardScan is open source, and available under a free-to-try license. See the [license](#license) section for details.

## Installation
### 1. Install the CardScan SDK into your app

#### iOS

Install and setup permission [cardscan-ios](https://github.com/getbouncer/cardscan-ios#installation)

#### Android

No additional steps are necessary to install [cardscan-android](https://github.com/getbouncer/cardscan-android#installation).

### 2. Install the [react-native-cardscan](https://www.npmjs.com/package/react-native-cardscan) package from NPM

```
$ npm install react-native-cardscan
```

### 3. For RN 0.59 and below: Link native dependencies

#### Automatic

```
$ react-native link react-native-cardscan
```

#### Manual

##### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-cardscan` and add `RNCardscan.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNCardscan.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project `Cmd+R`

##### Android

1. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
    ```
      implementation project(':react-native-cardscan')
    ```
1. Append the following lines to `android/settings.gradle`:
    ```
    include ':react-native-cardscan'
    project(':react-native-cardscan').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-cardscan/android')
    ```
1. Open `android/app/src/main/java/[...]/MainApplication.java`
    - Add `import com.getbouncer.RNCardscanPackage;` to the imports at the top of the file
    - Add `new RNCardscanPackage()` to the list returned by the `getPackages()` method


### Configure CardScan SDK

#### iOS

Install and setup permission for CardScan iOS with directions [here](https://github.com/getbouncer/cardscan-ios#installation)

Also, the instructions to configure your API key in Obj-C is [here](https://github.com/getbouncer/cardscan-ios#configure-cardscan-objective-c)

The podfile in your `~/ios/Podfile` in your project should look similar to:
```ruby
platform :ios, '10.0'
  target 'Your App' do
  ...
  pod 'CardScan'
  pod 'react-native-cardscan', :path => '../node_modules/react-native-cardscan/react-native-cardscan.podspec'
end
```

#### Android

To configure your [API key](https://api.getbouncer.com/console), open up `android/app/src/main/java/[...]/MainApplication.java` and add the following

```java
import com.getbouncer.RNCardscanModule;
...

...
public void onCreate() {
  ...
  RNCardscanModule.apiKey = "<YOUR_API_KEY_HERE>";
}
```

## Using CardScan (React Native)

**Check device support**

```javascript
import Cardscan from 'react-native-cardscan';

Cardscan.isSupportedAsync()
  .then(supported => {
    if (supported) {
      // YES, show scan button
    } else {
      // NO
    }
  })
```

**Scan card**

```javascript
import Cardscan from 'react-native-cardscan';

Cardscan.scan()
  .then(({action, payload, canceled_reason}) => {
    if (action === 'scanned') {
      const { number, expiryMonth, expiryYear, issuer, legalName } = payload;
      // Display information
    } else if (action === 'canceled') {
      if (canceled_reason === 'enter_card_manually') {
        // the user elected to enter a card manually
      } else if (canceled_reason === 'camera_error') {
        // there was an error with the camera
      } else if (canceled_reason === 'fatal_error') {
        // there was an error during the scan
      } else if (canceled_reason === 'user_canceled') {
        // the user canceled the scan
      } else {
        // the scan was canceled for an unknown reason
      }
    } else if (action === 'skipped') {
      // User skipped
    } else if (action === 'unknown') {
      // Unknown reason for scan canceled
    }
  })
```

## Example app

Inside `example`, you can find an example React Native project that you can run.

To run the example app, do the following:
- Navigate to `example`
- `npm install`
- Update API key in `android/app/src/main/java/com/example/MainApplication.java` for Android and `ios/example/AppDelegate.m` for iOS.
- To run Android app: `react-native run-android`
- To run iOS app: `react-native run-ios`

## Troubleshooting

##### `ld: warning: Could not find auto-linked library 'swiftFoundation'`
* A workaround with XCode 11 is to add a bridge header https://stackoverflow.com/a/56176956

##### `error: Failed to build iOS project. We ran "xcodebuild" command but it exited with error code 65`
* A workaround with a newer XCode build system is to switch to the legacy build https://stackoverflow.com/a/51089264

## Authors

Adam Wushensky, Sam King, Zain ul Abi Din, and Stefano Suryanto

## License

This library is available under paid and free licenses. See the [LICENSE](LICENSE) file for the full license text.

### Quick summary
In short, this library will remain free forever for non-commercial applications, but use by commercial applications is limited to 90 days, after which time a licensing agreement is required. We're also adding some legal liability protections.

After this period commercial applications need to convert to a licensing agreement to continue to use this library.
* Details of licensing (pricing, etc) are available at [https://cardscan.io/pricing](https://cardscan.io/pricing), or you can contact us at [license@getbouncer.com](mailto:license@getbouncer.com).

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
