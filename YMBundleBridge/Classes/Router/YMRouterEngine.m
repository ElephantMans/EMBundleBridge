//
//  YMRouterEngine.m
//  JRClientKit
//
//  Created by yimi on 2020/2/25.
//

#import "YMRouterEngine.h"

static NSString * const YMROUTER_WILDCARD_CHARACTER = @"~";
static NSString *specialCharacters = @"/?&.";

@interface YMRouterEngine()

@property (nonatomic, strong) NSMutableDictionary *routeDic;

@end

@implementation YMRouterEngine

+ (instancetype)shareInstance {
    static YMRouterEngine *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YMRouterEngine alloc]init];
    });
    return instance;
}

- (instancetype)init {
    if(self = [super init]) {
        self.routeDic = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (void)registerURLPattern:(NSString *)urlPattern withHandler:(YMRouterHandler)handler {
    [[self shareInstance] addURLPattern:urlPattern andHandler:handler];
}

+ (void)unregisterURLPattern:(NSString *)urlPattern {
    [[self shareInstance] removeURLPattern:urlPattern];
}

+ (void)openURL:(YMRouterURLRequest *)request {
    NSString *URL = [[request getRequestUrl] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
       NSMutableDictionary *parameters = [[self shareInstance] extractParametersFromURL:URL matchExactly:NO];
       
       [parameters enumerateKeysAndObjectsUsingBlock:^(id key, NSString *obj, BOOL *stop) {
           if ([obj isKindOfClass:[NSString class]]) {
               parameters[key] = [obj stringByRemovingPercentEncoding];
           }
       }];
       
       if (parameters) {
           YMRouterHandler handler = parameters[@"block"];
           if (handler) {
               [parameters removeObjectForKey:@"block"];
               [request setParams:parameters];
               handler(request);
           }
       }
}

- (void)removeURLPattern:(NSString *)URLPattern
{
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[self pathComponentsFromURL:URLPattern]];
    
    // 只删除该 pattern 的最后一级
    if (pathComponents.count >= 1) {
        // 假如 URLPattern 为 a/b/c, components 就是 @"a.b.c" 正好可以作为 KVC 的 key
        NSString *components = [pathComponents componentsJoinedByString:@"."];
        NSMutableDictionary *route = [self.routeDic valueForKeyPath:components];
        
        if (route.count >= 1) {
            NSString *lastComponent = [pathComponents lastObject];
            [pathComponents removeLastObject];
            
            // 有可能是根 key，这样就是 self.routes 了
            route = self.routeDic;
            if (pathComponents.count) {
                NSString *componentsWithoutLast = [pathComponents componentsJoinedByString:@"."];
                route = [self.routeDic valueForKeyPath:componentsWithoutLast];
            }
            [route removeObjectForKey:lastComponent];
        }
    }
}

- (void)addURLPattern:(NSString *)URLPattern andHandler:(YMRouterHandler)handler
{
    NSMutableDictionary *subRoutes = [self addURLPattern:URLPattern];
    if (handler && subRoutes) {
        subRoutes[@"_"] = [handler copy];
    }
}

- (NSMutableDictionary *)addURLPattern:(NSString *)URLPattern
{
    NSArray *pathComponents = [self pathComponentsFromURL:URLPattern];

    NSMutableDictionary* subRoutes = self.routeDic;
    
    for (NSString* pathComponent in pathComponents) {
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[pathComponent];
    }
    return subRoutes;
}

- (NSArray*)pathComponentsFromURL:(NSString*)URL
{

    NSMutableArray *pathComponents = [NSMutableArray array];
    if ([URL rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URL componentsSeparatedByString:@"://"];
        // 如果 URL 包含协议，那么把协议作为第一个元素放进去
        [pathComponents addObject:pathSegments[0]];
        
        // 如果只有协议，那么放一个占位符
        URL = pathSegments.lastObject;
        if (!URL.length) {
            [pathComponents addObject:YMROUTER_WILDCARD_CHARACTER];
        }
    }
    for (NSString *pathComponent in [[NSURL URLWithString:URL] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    return [pathComponents copy];
}

- (NSMutableDictionary *)extractParametersFromURL:(NSString *)url matchExactly:(BOOL)exactly
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        
    NSMutableDictionary* subRoutes = self.routeDic;
    NSArray* pathComponents = [self pathComponentsFromURL:url];
    
    BOOL found = NO;
    for (NSString* pathComponent in pathComponents) {
        
        // 对 key 进行排序，这样可以把 ~ 放到最后
        NSArray *subRoutesKeys =[subRoutes.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        
        for (NSString* key in subRoutesKeys) {
            if ([key isEqualToString:pathComponent] || [key isEqualToString:YMROUTER_WILDCARD_CHARACTER]) {
                found = YES;
                subRoutes = subRoutes[key];
                break;
            } else if ([key hasPrefix:@":"]) {
                found = YES;
                subRoutes = subRoutes[key];
                NSString *newKey = [key substringFromIndex:1];
                NSString *newPathComponent = pathComponent;
                // 再做一下特殊处理，比如 :id.html -> :id
                if ([self.class checkIfContainsSpecialCharacter:key]) {
                    NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
                    NSRange range = [key rangeOfCharacterFromSet:specialCharacterSet];
                    if (range.location != NSNotFound) {
                        // 把 pathComponent 后面的部分也去掉
                        newKey = [newKey substringToIndex:range.location - 1];
                        NSString *suffixToStrip = [key substringFromIndex:range.location];
                        newPathComponent = [newPathComponent stringByReplacingOccurrencesOfString:suffixToStrip withString:@""];
                    }
                }
                parameters[newKey] = newPathComponent;
                break;
            } else if (exactly) {
                found = NO;
            }
        }
        
        // 如果没有找到该 pathComponent 对应的 handler，则以上一层的 handler 作为 fallback
        if (!found && !subRoutes[@"_"]) {
            return nil;
        }
    }
    
    // Extract Params From Query.
    NSArray<NSURLQueryItem *> *queryItems = [[NSURLComponents alloc] initWithURL:[[NSURL alloc] initWithString:url] resolvingAgainstBaseURL:false].queryItems;
    
    for (NSURLQueryItem *item in queryItems) {
        parameters[item.name] = item.value;
    }
    if (subRoutes[@"_"]) {
        parameters[@"block"] = [subRoutes[@"_"] copy];
    }
    return parameters;
}

+ (BOOL)checkIfContainsSpecialCharacter:(NSString *)checkedString {
    NSCharacterSet *specialCharactersSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
    return [checkedString rangeOfCharacterFromSet:specialCharactersSet].location != NSNotFound;
}

@end


