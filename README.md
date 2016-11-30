# vgs-ios-sdk
[![Build Status](https://travis-ci.org/verygoodsecurity/vgs-ios-sdk.svg?branch=rewrite)](https://travis-ci.org/verygoodsecurity/vgs-ios-sdk)
[![CocoaPods](https://img.shields.io/cocoapods/v/VaultSDK.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/verygoodsecurity/vgs-ios-sdk)
[![license](https://img.shields.io/github/license/verygoodsecurity/vgs-ios-sdk.svg)]()

Very Good Security Vault iOS SDK

## Requirements

This SDK is written in Swift 3.0, it requires Xcode 8.0 or above.

## Usage example in Swift 3.0

```Swift
import VaultSDK

let api = VaultAPI(
    baseURL: URL(string: "https://demo.sandbox.verygoodvault.com")!,
    publishableKey: "demo-user"
)
api.createToken(
    payload: "4111111111111111",
    failure: { error in
        // Handle the error here
    },
    success: { token in
        // Use the token here
    }
)
 ```

## Usage example in Objective C

Import the SDK like this

```ObjectiveC
@import VaultSDK;
```

then

```ObjectiveC
VaultAPI *api = [[VaultAPI alloc] initWithBaseURL:[NSURL URLWithString:@"https://demo.sandbox.verygoodvault.com"] publishableKey:@"demo-user" urlSession:[NSURLSession sharedSession]];

[api createTokenWithPayload:@"4111111111111111" failure:^(NSError * _Nonnull error) {
    // Handle the error here
} success:^(NSDictionary<NSString *,id> * _Nonnull token) {
    // Use the token here
}];
```

## Install via CocoaPods

To install the VaultSDK via [CocoaPods](https://cocoapods.org), put following line in your Podfile

```
pod 'VaultSDK', '~> 1.0.0-alpha-3'
```

For Swift 2.3, please use `0.0.x` version instead. You can install it via

```
pod 'VaultSDK', '~> 0.0.1-alpha-1'
```

## Install via Carthage

To install the VaultSDK via [Carthage](https://github.com/Carthage/Carthage), put following line in your Cartfile

```
github "verygoodsecurity/vgs-ios-sdk" ~> 1.0
```

For Swift 2.3, please use `swift-2.3` branch instead. You can install it via

```
github "verygoodsecurity/vgs-ios-sdk" "swift-2.3"
```

## Run example app

Open `VaultSDK.xcworkspace` with Xcode, select target `VaultSDKExample` and a simulator then run it via CMD + R.
