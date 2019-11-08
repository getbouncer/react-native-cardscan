#import <React/RCTBridgeModule.h>
@import CardScan;

@interface ScanViewDelegate : NSObject <ScanDelegate>

@property RCTPromiseResolveBlock resolve;

- (void)setCallback:(RCTPromiseResolveBlock)resolve;
- (void)dismissView;

@end

@interface RNCardscan : NSObject <RCTBridgeModule>

@property (nonatomic) ScanViewDelegate * scanViewDelegate;

@end
