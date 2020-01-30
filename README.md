# CardScan

CardScan React Native iOS installation guide

## Installation
### Install cardscan-ios SDK

Install and setup permission [cardscan-ios](https://github.com/getbouncer/cardscan-ios#installation)

### Install react-native-cardscan

```
$ npm install getbouncer/cardscan-ios-react
```

### For RN 0.59 and below: Link native dependencies

#### Automatic

```
$ react-native link react-native-cardscan
```

#### Manual

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-cardscan` and add `RNCardscan.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNCardscan.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project `Cmd+R`


### Install CardScan SDK

Install and setup permission for CardScan iOS with directions [here](https://github.com/getbouncer/cardscan-ios#installation)

Also, the instructions to configure your API key in obj-c is [here](https://github.com/getbouncer/cardscan-ios#configure-cardscan-objective-c)

The podfile in your `~/ios/Podfile` in your project should look similar to:
```
platform :ios, '10.0'
  target 'Your App' do
  ...
  pod 'CardScan'
  pod 'react-native-cardscan', :path => '../node_modules/react-native-cardscan/react-native-cardscan.podspec'
end
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
  .then(({ action, payload }) => {
    if (action === 'scanned') {
      const { number, expiryMonth, expiryYear } = payload;
      // Display information
    } else if (action === 'cancelled') {
      // User cancelled
    } else if (action === 'skipped') {
      // User skipped
    }
  })
```

## Troubleshooting

##### `ld: warning: Could not find auto-linked library 'swiftFoundation'`
* A workaround with XCode 11 is to add a bridge header https://stackoverflow.com/a/56176956

##### `error: Failed to build iOS project. We ran "xcodebuild" command but it exited with error code 65`
* A workaround with a newer XCode build system is to switch to the legacy build https://stackoverflow.com/a/51089264
