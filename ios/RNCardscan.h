#import <React/RCTBridgeModule.h>
#import "CardScan/CardScan-Swift.h"
@import CardScan;

@interface SimpleScanViewDelegate : NSObject <SimpleScanDelegate>

@property RCTPromiseResolveBlock resolve;

- (void)setCallback:(RCTPromiseResolveBlock)resolve;
- (void)dismissView;

@end

@interface RNCardscan : NSObject <RCTBridgeModule>

@property (nonatomic) SimpleScanViewDelegate * simpleScanViewDelegate;

@end
