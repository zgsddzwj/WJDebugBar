//
//  WJServerConfig.h
//  WJDebugBar
//
//  Created by AdwardGreen on 2017/10/31.
//  Copyright © 2017年 WangJian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEBUGSERVERURL @"DebugServerUrl"


#define DEFAULTSERVERURL @"http://api.ceshi.xin.com"

@interface WJServerConfig : NSObject

+ (instancetype)sharedInstance;

@property (copy, nonatomic) NSString* serverUrl;


@end

#define kNotif_ServerChanged        @"kNotif_ServerChanged"
