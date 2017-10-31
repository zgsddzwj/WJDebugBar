//
//  WJDebugStatusBar.h
//  WJDebugBar
//
//  Created by AdwardGreen on 2017/10/31.
//  Copyright © 2017年 WangJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJDebugStatusBar : UIWindow

+ (instancetype)sharedInstance;
- (void)startMonitorDevice;

@end

#define __DEBUGBAR__ [WJDebugStatusBar sharedInstance]
