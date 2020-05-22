//
//  BServiceImp.m
//  YMBundleBridge_Example
//
//  Created by yimi on 2020/2/27.
//  Copyright © 2020 yimifudaoTech. All rights reserved.
//

#import "BServiceImp.h"

@implementation BServiceImp

+ (BOOL)isSingleton {
    return NO;
}

- (NSString *)getModuleName {
    return @"BServiceImp";
}

@end
