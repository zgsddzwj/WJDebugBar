//
//  WJServerBaseVC.m
//  WJDebugBar
//
//  Created by AdwardGreen on 2017/10/31.
//  Copyright © 2017年 WangJian. All rights reserved.
//

#import "WJServerBaseVC.h"

@interface WJServerBaseVC ()

@end

@implementation WJServerBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 竖屏
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
{
    return UIInterfaceOrientationPortrait;
}
@end
