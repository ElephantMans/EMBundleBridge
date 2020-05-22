//
//  BServiceProtocol.h
//  YMBundleBridge
//
//  Created by yimi on 2020/2/27.
//  Copyright © 2020 yimifudaoTech. All rights reserved.
//

#ifndef BServiceProtocol_h
#define BServiceProtocol_h

#import "YMServiceProtocol.h"

@protocol BServiceProtocol <YMServiceProtocol>

- (NSString *)getModuleName;

@end


#endif /* BServiceProtocol_h */
