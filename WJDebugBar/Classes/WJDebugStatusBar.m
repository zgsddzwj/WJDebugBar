//
//  WJDebugStatusBar.m
//  WJDebugBar
//
//  Created by AdwardGreen on 2017/10/31.
//  Copyright © 2017年 WangJian. All rights reserved.
//

#import "WJDebugStatusBar.h"
#import "WJServerListVC.h"
#import "UIDevice-Hardware.h"

@interface WJDebugStatusBar()

@property (strong, nonatomic) UILabel* tipLabel;
@property (strong, nonatomic) NSTimer* monitorTimer;//实时更新信息
@property (assign, nonatomic) BOOL isDisplayedDebugBar;//是否显示

@end

@implementation WJDebugStatusBar

+(instancetype)sharedInstance
{
    static WJDebugStatusBar *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        float ScreenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        instance = [[[self class] alloc] initWithFrame:CGRectMake(ScreenWidth-220, 0, 220, 20)];
        [instance setRootViewController:[WJServerBaseVC new]]; // Xcode7 之后的版本 必须 设置rootViewController，不然crash:*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Application windows are expected to have a root view controller at the end of application launch'
    });
    return instance;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.isDisplayedDebugBar = YES;
        self.backgroundColor = [UIColor blackColor];
        self.windowLevel = UIWindowLevelStatusBar + 1.0;

        //文字提示
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.textColor = [UIColor redColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_tipLabel];

        [self refreshDeviceInfo]; //获取设备信息

        // 添加长按手势出配置界面
        UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(presentConfigPage)];
        [self addGestureRecognizer:longPressGesture];
        //添加点击手势
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHiddenDebugStatusBar)];
        [self addGestureRecognizer:tapGesture];

        //内存警告通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarningTip:) name:@"UIApplicationDidReceiveMemoryWarningNotification" object:nil];
    }
    return self;
}


// 实时更新资源使用情况
- (void)refreshDeviceInfo
{
    //    if (!self.window) {
    //        [[UIApplication sharedApplication].keyWindow addSubview:self];
    //    }
    //    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    UIDevice* device = [UIDevice currentDevice];
    NSArray* cpuUsage = [device cpuUsage];

    //CPU
    NSMutableString* cpuInfo = [NSMutableString stringWithFormat:@"cpu:"];
    for (NSNumber* cpu in cpuUsage) {
        [cpuInfo appendString:[NSString stringWithFormat:@"%.1f%% ", [cpu floatValue]]];
    }

    //Memory
    NSString* memoryInfo = [NSString stringWithFormat:@"内存:%.1f / %luM", [device freeMemoryBytes] / 1024.0 / 1024.0, [device totalMemoryBytes] / 1024.0 / 1024.0];

    _tipLabel.text = [NSString stringWithFormat:@"%@  %@", cpuInfo, memoryInfo];
}

//弹出配置页面
- (void)presentConfigPage
{
    //展示debugBar
    self.backgroundColor = [UIColor blackColor];
    for (UIView* subView in self.subviews) {
        subView.hidden = NO;
    }

    UIViewController *vc = [[UIApplication sharedApplication].delegate window].rootViewController;
    if ([vc presentedViewController]) {
        return;
    }

    //推出配置页面
    WJServerListVC* serverListController = [[WJServerListVC alloc] init];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:serverListController];
    [vc presentViewController:navigationController animated:YES completion:nil];
}

//收到内存警告，弹出提示
- (void)didReceiveMemoryWarningTip:(NSNotification*)noti
{
    //    NSString *userInfo = [[noti userInfo] description];
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"程序出现内存警告" message:userInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alertView show];

    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAutoreverse
                     animations:^{
                         self.backgroundColor = [UIColor yellowColor];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.backgroundColor = [UIColor blackColor];
                         }
                     }];
}

//开始监听设备
- (void)startMonitorDevice
{
    self.hidden = NO;

    if (_monitorTimer) {
        [_monitorTimer invalidate];
        _monitorTimer = nil;
    }
    _monitorTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshDeviceInfo) userInfo:nil repeats:YES];
    [_monitorTimer fire];
}

//显示或隐藏Bar
- (void)showOrHiddenDebugStatusBar
{
    if (self.isDisplayedDebugBar) {
        self.backgroundColor = [UIColor clearColor];
        for (UIView* subView in self.subviews) {
            subView.hidden = YES;
        }
        self.isDisplayedDebugBar = NO;

        if (_monitorTimer) {
            [_monitorTimer invalidate];
            _monitorTimer = nil;
        }
    }
    else {
        self.backgroundColor = [UIColor blackColor];
        for (UIView* subView in self.subviews) {
            subView.hidden = NO;
        }

        self.isDisplayedDebugBar = YES;
        [self startMonitorDevice];
    }
}


@end
