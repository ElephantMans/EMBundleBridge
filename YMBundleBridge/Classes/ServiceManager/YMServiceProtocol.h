//
//  YMServiceProtocol.h
//  YMBundleBridge
//
//  Created by yimi on 2020/2/27.
//

#ifndef YMServiceProtocol_h
#define YMServiceProtocol_h

#import "YMServiceManager.h"

@protocol YMServiceProtocol <NSObject>

+ (BOOL)isSingleton;

+ (id)shareInstance;

@end


#endif /* YMServiceProtocol_h */
