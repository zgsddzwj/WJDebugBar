//
//  ViewController.m
//  WJDebugBarDemo
//
//  Created by AdwardGreen on 2017/10/31.
//  Copyright © 2017年 WangJian. All rights reserved.
//

#import "ViewController.h"
#import "WJDebugStatusBar.h"
#import "WJServerConfig.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [__DEBUGBAR__ startMonitorDevice];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDbgServerChanged:) name:kNotif_ServerChanged object:nil];
}

- (void)onDbgServerChanged:(NSNotification *)notification;
{
    NSString *httpServer = [WJServerConfig sharedInstance].serverUrl;
    NSLog(@"httpServer = %@",httpServer);
}


@end
