#import "RNCardscan.h"
#import <React/RCTBridgeDelegate.h>
@import Foundation;

@import CardScan;

@implementation ScanViewDelegate

- (void)setCallback:(RCTPromiseResolveBlock)resolve {
    self.resolve = resolve;
}

- (void)dismissView {
    UIViewController *rootViewController = UIApplication.sharedApplication.delegate.window.rootViewController;
    [rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidSkip:(ScanViewController * _Nonnull)scanViewController {
    [self dismissView];
    self.resolve(@{ @"action" : @"skipped" });
}

- (void)userDidCancel:(ScanViewController * _Nonnull)scanViewController {
    [self dismissView];
    self.resolve(@{ @"action" : @"canceled" });
}

- (void)userDidScanCard:(ScanViewController * _Nonnull)scanViewController creditCard:(CreditCard * _Nonnull)creditCard {
    [self dismissView];
    NSString *number = creditCard.number;
    NSString *cardholderName = creditCard.name;
    NSString *expiryMonth = creditCard.expiryMonth;
    NSString *expiryYear = creditCard.expiryYear;

    self.resolve(@{
        @"action" : @"scanned",
        @"payload": @{
            @"number": number,
            @"cardholderName": cardholderName ?: [NSNull null],
            @"expiryMonth": expiryMonth ?: [NSNull null],
            @"expiryYear": expiryYear ?: [NSNull null]
        }
    });
}

@end


@implementation RNCardscan

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (id)init {
    if(self = [super init]) {
        self.scanViewDelegate = [[ScanViewDelegate alloc] init];
    }
    return self;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(isSupportedAsync:(RCTPromiseResolveBlock)resolve :(RCTPromiseRejectBlock)reject)
{
    resolve(@([ScanViewController isCompatible]));
}

RCT_EXPORT_METHOD(scan:(RCTPromiseResolveBlock)resolve :(RCTPromiseRejectBlock)reject)
{
    [self.scanViewDelegate setCallback:resolve];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = UIApplication.sharedApplication.delegate.window.rootViewController;
        UIViewController *vc = [ScanViewController createViewControllerWithDelegate:self.scanViewDelegate];

        [rootViewController presentViewController:vc animated:NO completion:nil];
    });
}

@end
