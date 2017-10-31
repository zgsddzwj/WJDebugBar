//
//  WJServerConfig.m
//  WJDebugBar
//
//  Created by AdwardGreen on 2017/10/31.
//  Copyright © 2017年 WangJian. All rights reserved.
//

#import "WJServerConfig.h"

@implementation WJServerConfig

static WJServerConfig* instance = nil;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _serverUrl = [[NSUserDefaults standardUserDefaults] objectForKey:DEBUGSERVERURL];
        if (_serverUrl == nil) {
            _serverUrl = DEFAULTSERVERURL;
        }
    }
    return self;
}

@end
