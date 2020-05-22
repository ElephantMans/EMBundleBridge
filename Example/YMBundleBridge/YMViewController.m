//
//  YMViewController.m
//  YMBundleBridge
//
//  Created by yimifudaoTech on 02/27/2020.
//  Copyright (c) 2020 yimifudaoTech. All rights reserved.
//

#import "YMViewController.h"
#import <YMBundleBridge/YMBundleBridge.h>
#import "AServiceImp.h"
#import "BServiceImp.h"
@interface YMViewController ()

@end

@implementation YMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    id<AServiceProtocol> aService = [[YMBundleBridge sharedInstance].serviceManager createServiceByProtocol:@protocol(AServiceProtocol)];
   NSString *muduleName =  [aService getModuleName];
    NSLog(@"class module a result:%@", muduleName);
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
