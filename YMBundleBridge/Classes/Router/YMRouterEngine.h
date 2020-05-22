//
//  YMRouterEngine.h
//  JRClientKit
//
//  Created by yimi on 2020/2/25.
//

#import <Foundation/Foundation.h>
#import "YMRouterURLRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^YMRouterHandler)(YMRouterURLRequest *request);

@interface YMRouterEngine : NSObject

+ (void)registerURLPattern:(NSString *)urlPattern withHandler:(YMRouterHandler)handler;


+ (void)unregisterURLPattern:(NSString *)urlPattern;


+ (void)openURL:(YMRouterURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
