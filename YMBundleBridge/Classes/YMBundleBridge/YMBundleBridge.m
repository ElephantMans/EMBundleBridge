//
//  YMBundleBridge.m
//  JRClientKit
//
//  Created by yimi on 2020/2/26.
//

#import "YMBundleBridge.h"

@implementation YMBundleBridge

+ (instancetype)sharedInstance {
    static YMBundleBridge *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [YMBundleBridge alloc];
    });
    return instance;
}


- (YMServiceManager *)serviceManager {
    if(!_serviceManager) {
        _serviceManager = [[YMServiceManager alloc]init];
    }
    return _serviceManager;
}

- (YMRouterEngine *)routerEnine {
    if(!_routerEnine) {
        _routerEnine = [[YMRouterEngine alloc]init];
    }
    return _routerEnine;
}

@end
