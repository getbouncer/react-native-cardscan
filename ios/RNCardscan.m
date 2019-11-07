#import "RNCardscan.h"

#import <AFNetworking/AFNetworking.h>

@implementation RNCardscan

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(call:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
{
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
	[manager GET:@"https://httpstat.us/200" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
			callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@ resp: %@", numberArgument, stringArgument, responseObject]]);
	} failure:^(NSURLSessionTask *operation, NSError *error) {
			callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@ err: %@", numberArgument, stringArgument, error]]);
	}];
}

@end
