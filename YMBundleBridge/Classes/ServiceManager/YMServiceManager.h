//
//  YMServiceManager.h
//  YMBundleBridge
//
//  Created by yimi on 2020/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMServiceManager : NSObject

- (BOOL)registerService:(Class)serviceImpClass forProtocol:(Protocol *)serviceProtocol;

- (id)createServiceByProtocol:(Protocol *)serviceProtocol;

@end

NS_ASSUME_NONNULL_END
