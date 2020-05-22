//
//  YMRouterURLRequest.h
//  JRClientKit
//
//  Created by yimi on 2020/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMRouterURLRequest : NSObject

- (instancetype)initWithURL:(NSString *)requestURL andUserInfo:(NSDictionary * _Nullable)userInfo;

- (void)setRequestUrl:(NSString *)url;

- (NSString *)getRequestUrl;

- (void)setUserInfo:(NSDictionary *)userInfo;

- (void)setParams:(NSDictionary *)params;

- (NSDictionary *)getParams;

- (void)setCompleteCallback:(void(^)(id obj, int resultCode, NSString *errorMsg))result;

- (void)setResult:(id)obj withCode:(int)resultCode withMsg:(NSString *)errorMsg;

@end

NS_ASSUME_NONNULL_END
