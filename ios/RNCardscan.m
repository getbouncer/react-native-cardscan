//
//  RNCardScan.m
//  RNCardScan
//
//  Created by Jaime Park on 9/23/21.
//  Copyright © 2021 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(RNCardscan, NSObject)
RCT_EXTERN_METHOD(isSupportedAsync:(RCTPromiseResolveBlock)resolve
                  :(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(scan:(RCTPromiseResolveBlock)resolve
                  :(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(setiOSScanViewStyle:(NSDictionary)styleDictionary)
@end
