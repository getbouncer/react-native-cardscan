#import "RNCardscan.h"

@import CardScan;

@implementation RNCardscan

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(isCompatible:(RCTPromiseResolveBlock)resolve :(RCTPromiseRejectBlock)reject)
{
    resolve(@([ScanViewController isCompatible]));
}

@end
