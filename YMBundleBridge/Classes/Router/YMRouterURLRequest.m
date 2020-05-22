//
//  YMRouterURLRequest.m
//  JRClientKit
//
//  Created by yimi on 2020/2/25.
//

#import "YMRouterURLRequest.h"

static NSString * const kFIELDKEY_COMPLETE_CALLBACK = @"YMRouterURLRequest_CompleteCallback";

static NSString * const kFIELDKEY_RESULT_OBJECT = @"YMRouterURLRequest_RESULT_OBJECT";

static NSString * const kFIELDKEY_RESULT_CODE = @"YMRouterURLRequest_RESULT_CODE";

static NSString * const kFIELDKEY_RESULT_MSG = @"YMRouterURLRequest_RESULT_MSG";


@interface YMRouterURLRequest()

@property (nonatomic, strong)NSString *requestUrl;

@property (nonatomic, strong)NSMutableDictionary *fields;

@end

@implementation YMRouterURLRequest

- (instancetype)init {
    if(self = [super init]) {
        self.fields = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)requestURL andUserInfo:(NSDictionary *)userInfo {
    if(self = [super init]) {
        self.fields = [NSMutableDictionary dictionary];
        self.requestUrl = requestURL;
        if(userInfo) {
            [self.fields addEntriesFromDictionary:userInfo];
        }
    }
    return self;
}

-(void)setRequestUrl:(NSString *)url {
    _requestUrl = url;
}

- (NSString *)getRequestUrl {
    return _requestUrl;
}

- (void)setUserInfo:(NSDictionary *)userInfo {
    [self.fields addEntriesFromDictionary:userInfo];
}

- (void)setParams:(NSDictionary *)params {
    [self.fields addEntriesFromDictionary:params];
}

- (NSDictionary *)getParams {
    return self.fields;
}

- (void)setCompleteCallback:(void (^)(id _Nonnull, int, NSString * _Nonnull))result {
    [self.fields setObject:result forKey:kFIELDKEY_COMPLETE_CALLBACK];
}

- (void)setResult:(id)obj withCode:(int)resultCode withMsg:(NSString *)errorMsg {
    [self.fields setValue:obj forKey:kFIELDKEY_RESULT_OBJECT];
    [self.fields setValue:@(resultCode) forKey:kFIELDKEY_RESULT_CODE];
    [self.fields setValue:errorMsg forKey:kFIELDKEY_RESULT_MSG];
}

@end
