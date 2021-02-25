#import "RNCardscan.h"
#import <React/RCTBridgeDelegate.h>
@import Foundation;

@import CardScan;

@implementation SimpleScanViewDelegate

- (void)setCallback:(RCTPromiseResolveBlock)resolve {
    self.resolve = resolve;
}

- (void)dismissView {
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    
    [topViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelSimple:(SimpleScanViewController * _Nonnull)scanViewController  API_AVAILABLE(ios(11.2)){
    [self dismissView];
    self.resolve(@{ @"action" : @"canceled" });
}

- (void)userDidScanCardSimple:(SimpleScanViewController * _Nonnull)scanViewController creditCard:(CreditCard * _Nonnull)creditCard  API_AVAILABLE(ios(11.2)){
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
        self.simpleScanViewDelegate = [[SimpleScanViewDelegate alloc] init];
    }
    return self;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(isSupportedAsync:(RCTPromiseResolveBlock)resolve :(RCTPromiseRejectBlock)reject)
{
    if (@available(iOS 11.2, *)) {
        resolve(@([SimpleScanViewController isCompatible]));
    }
}

RCT_EXPORT_METHOD(scan:(RCTPromiseResolveBlock)resolve :(RCTPromiseRejectBlock)reject)
{
    if (@available(iOS 11.2, *)) {
        [self.simpleScanViewDelegate setCallback:resolve];

        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

            while (topViewController.presentedViewController) {
                topViewController = topViewController.presentedViewController;
            }
            
            SimpleScanViewController *vc = [SimpleScanViewController createViewController];
            vc.delegate = self.simpleScanViewDelegate;
            
            [topViewController presentViewController:vc animated:NO completion:nil];
        });
    }
}

@end
