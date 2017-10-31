//
//  WJServerListVC.m
//  WJDebugBar
//
//  Created by AdwardGreen on 2017/10/31.
//  Copyright © 2017年 WangJian. All rights reserved.
//

#import "WJServerListVC.h"
#import "WJServerConfig.h"
#define DEBUGSERVERLIST @"DebugServerList"


@interface WJServerListVC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *_serverList;
}

@property (strong, nonatomic) UITextField* serverUrlTextField;
@property (strong, nonatomic) UITableView* serverListTable;

@end

@implementation WJServerListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat h = 40;
#if CLIENT_DBM
    h = 44;
#endif
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    _serverUrlTextField = [[UITextField alloc] init];
    _serverUrlTextField.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), h);
    _serverUrlTextField.delegate = self;
    _serverUrlTextField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_serverUrlTextField];

    _serverUrlTextField.borderStyle = UITextBorderStyleLine;


    _serverListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_serverUrlTextField.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_serverUrlTextField.frame)) style:UITableViewStylePlain];

    _serverListTable.backgroundColor = [UIColor whiteColor];

    _serverListTable.delegate = self;
    _serverListTable.dataSource = self;
    self.serverListTable.separatorInset = UIEdgeInsetsZero;
    self.serverListTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_serverListTable];


    self.title = @"Server List";
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)] animated:YES];

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)] animated:YES];

    NSArray* defaultServerList = [NSArray arrayWithObjects:
                                  @"https://api.xin.com",
                                  @"http://api.xin.com",
                                  @"http://api.ceshi.xin.com",
                                  @"http://apiwz.ceshi.xin.com",
                                  @"http://api.ceshi.youxinjinrong.com",
                                  nil];

    NSArray* tmpServerList = [[NSUserDefaults standardUserDefaults] objectForKey:DEBUGSERVERLIST];
    if (tmpServerList == nil) {
        _serverList = [NSMutableArray arrayWithObjects:defaultServerList,nil];
        [[NSUserDefaults standardUserDefaults] setObject:_serverList forKey:DEBUGSERVERLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {

        BOOL isSafe = YES;
        for (int i = 0; i < tmpServerList.count; i++) {

            if (![[tmpServerList objectAtIndex:i] isKindOfClass:[NSArray class]]) {
                isSafe = NO;
                break;
            }
        }

        if (isSafe) {
            _serverList = [NSMutableArray arrayWithArray:tmpServerList];
        }else {
            _serverList = [NSMutableArray arrayWithObjects:defaultServerList,nil];
            [[NSUserDefaults standardUserDefaults] setObject:_serverList forKey:DEBUGSERVERLIST];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }

    self.serverUrlTextField.placeholder = @"xin.com服务";

    self.serverUrlTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:DEBUGSERVERURL];
    if (self.serverUrlTextField.text.length == 0) {
        self.serverUrlTextField.text = DEFAULTSERVERURL;
    }

#if !CLIENT_DBM
    [self.serverListTable reloadData];
#endif
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirm
{
    if (_serverUrlTextField.text.length > 0 ) {
        WJServerConfig* serverConfig = [WJServerConfig sharedInstance];
        serverConfig.serverUrl = _serverUrlTextField.text;
        [[NSUserDefaults standardUserDefaults] setObject:_serverUrlTextField.text forKey:DEBUGSERVERURL];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // post notification
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotif_ServerChanged object:nil];

        //写入文件
        for (int i = 0; i < _serverList.count; i ++) {
            if (i == 0) {
                NSMutableArray *ary1 = [NSMutableArray arrayWithArray:[_serverList objectAtIndex:i]];
                if (![ary1 containsObject:_serverUrlTextField.text]) {
                    [ary1 addObject:_serverUrlTextField.text];
                    [_serverList replaceObjectAtIndex:i withObject:ary1];
                    [[NSUserDefaults standardUserDefaults] setObject:_serverList forKey:DEBUGSERVERLIST];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }

        //        if (![_serverList containsObject:_serverUrlTextField.text]) {
        //            [_serverList addObject:_serverUrlTextField.text];
        //            [[NSUserDefaults standardUserDefaults] setObject:_serverList forKey:DEBUGSERVERLIST];
        //            [[NSUserDefaults standardUserDefaults] synchronize];
        //        }
        [self dismiss];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请至少选择一个服务器地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - UITableView Delgate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_serverList objectAtIndex:section] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* identify = @"ServerListCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = [[_serverList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        _serverUrlTextField.text = [[_serverList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *ary = [NSMutableArray arrayWithArray:[_serverList objectAtIndex:indexPath.section]];
        [ary removeObjectAtIndex:indexPath.row];
        [_serverList replaceObjectAtIndex:indexPath.section withObject:ary];

        [[NSUserDefaults standardUserDefaults] setObject:_serverList forKey:DEBUGSERVERLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.serverListTable reloadData];

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect rect = [textField convertRect:textField.frame toView:self.view];
    CGFloat height = (CGRectGetWidth(self.view.frame) > 375) ? CGRectGetHeight(self.view.frame) - 300: CGRectGetHeight(self.view.frame) - 270;
    if (height <= rect.origin.y) {
        height = ABS(height - rect.origin.y);
        [self.serverListTable setContentOffset:CGPointMake(0, self.serverListTable.contentOffset.y + height - 40) animated:YES];
    }
}

@end
