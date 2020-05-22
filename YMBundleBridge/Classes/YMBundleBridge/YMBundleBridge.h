//
//  YMBundleBridge.h
//  JRClientKit
//
//  Created by yimi on 2020/2/26.
//

#import <Foundation/Foundation.h>
#import "YMRouterEngine.h"
#import "YMServiceManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMBundleBridge : NSObject

@property (nonatomic, strong) YMServiceManager *serviceManager;
@property (nonatomic, strong) YMRouterEngine *routerEnine;


+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
