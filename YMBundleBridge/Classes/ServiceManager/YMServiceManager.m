//
//  YMServiceManager.m
//  YMBundleBridge
//
//  Created by yimi on 2020/2/27.
//

#import "YMServiceManager.h"
#import "YMServiceProtocol.h"

@interface YMServiceManager()

@property (nonatomic, strong) NSMutableDictionary *serviceDict;
@property (nonatomic, strong)NSRecursiveLock *lock;

@end

@implementation YMServiceManager

- (BOOL)registerService:(Class)serviceImpClass forProtocol:(id)serviceProtocol {
    if(![serviceImpClass conformsToProtocol:serviceProtocol]) {
        return NO;
    }
    NSString *key =NSStringFromProtocol(serviceProtocol);
    NSString *value = NSStringFromClass(serviceImpClass);
    if(key.length > 0 && value.length >0) {
        [self.lock lock];
        [self.serviceDict setValue:value forKey:key];
        [self.lock unlock];
    }
    return YES;
}

- (id)createServiceByProtocol:(Protocol *)serviceProtocol {
    if(![self checkValidService:serviceProtocol]) {
        return nil;
    }
    id implInstance = nil;
    Class implClass = [self serviceImplClass:serviceProtocol];
    if([[implClass class] respondsToSelector:@selector(isSingleton)]) {
        if([[implClass class] respondsToSelector:@selector(shareInstance)]) {
            implInstance = [[implClass class] shareInstance];
        }else {
            implInstance = [[implClass alloc]init];
        }
    } else {
        implInstance = [[implClass alloc]init];
    }
    return implInstance;
}


- (Class)serviceImplClass:(Protocol *)serviceProtocol
{
    NSString *serviceImpl = [[self obtainServiceDict] objectForKey:NSStringFromProtocol(serviceProtocol)];
    if (serviceImpl.length > 0) {
        return NSClassFromString(serviceImpl);
    }
    return nil;
}

- (BOOL)checkValidService:(Protocol *)serviceProtocol {
    NSString *serviceImpl = [[self obtainServiceDict] objectForKey:NSStringFromProtocol(serviceProtocol)];
    if(serviceImpl.length > 0) {
        return YES;
    }
    return NO;
}

- (NSMutableDictionary *)serviceDict {
    if(!_serviceDict) {
        _serviceDict = [NSMutableDictionary dictionary];
    }
    return _serviceDict;
}

- (NSDictionary *)obtainServiceDict {
    [self.lock lock];
    NSDictionary *dict = [self.serviceDict copy];
    [self.lock unlock];
    return dict;
}


@end
