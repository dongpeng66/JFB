//
//  MyInfoViewController.m
//  JFB
//
//  Created by LYD on 15/8/20.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoTableViewCell.h"
#import "AuthenticationViewController.h"
#import "ReceiveAddressViewController.h"
#import "ChangePWDViewController.h"
#import "MemberCardViewController.h"
#import "BindViewController.h"
#import "QRcodeViewController.h"

@interface MyInfoViewController () <UIAlertViewDelegate>
{
 
}
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人信息";
    self.automaticallyAdjustsScrollViewInsets = YES;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 40)];
    [logoutBtn setBackgroundColor:RGBCOLOR(229, 24, 35)];
    logoutBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [logoutBtn setTitle:@"安全退出" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:logoutBtn];
    
 
    
    self.myTableView.tableFooterView = view;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyInfoCell"];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.myTableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.myTableView reloadData];
}

//设置Separator顶头
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoTableViewCell *cell = (MyInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyInfoCell"];
    switch (indexPath.row) {
        case 0:
        {
            cell.imgView.image = [UIImage imageNamed:@"user_point"];
            NSString *mNameStr = [[GlobalSetting shareGlobalSettingInstance] mName];
            if ([mNameStr isEqualToString:@""]) {
                NSString *tel = [[[GlobalSetting shareGlobalSettingInstance] mMobile] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                cell.textL.text = [NSString stringWithFormat:@"%@",tel];
            }
            else {
                cell.textL.text = mNameStr;
            }
            
            NSString *mIdentityId = [[GlobalSetting shareGlobalSettingInstance] mIdentityId];
            mIdentityId = [mIdentityId substringToIndex:2];
            if (![mIdentityId isEqualToString:@"99"] ) {
                cell.noticeL.textColor = Red_BtnColor;
                cell.noticeL.text = @"已实名认证";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryIM.hidden = YES;
            }
            else {
                cell.noticeL.textColor = RGBCOLOR(150, 150, 150);
                cell.noticeL.text = @"未实名认证";
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryIM.hidden = NO;
            }
            
        }
            break;
            
        case 1:
        {
            cell.imgView.image = [UIImage imageNamed:@"user_admin_member_card"];
            cell.textL.text = @"会员卡";
            cell.noticeL.textColor = RGBCOLOR(150, 150, 150);
            
            NSString *cid = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] cId]];
         cid = [cid substringToIndex:8];
            NSLog(@"%@",cid);
    
            if ([cid isEqualToString:@"00000000"]) {
               
                
                cell.noticeL.text = @"绑定实体卡";
                cell.accessoryIM.hidden = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                

            }  else {
                
                cell.noticeL.text = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] cId]];
                cell.accessoryIM.hidden = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            
            
        }
            break;
            
            
        case 2:
        {
            cell.imgView.image = [UIImage imageNamed:@"user_address"];
            cell.textL.text = @"收货地址";
            cell.noticeL.textColor = RGBCOLOR(53, 53, 53);
            cell.noticeL.text = @"添加/修改";
            cell.accessoryIM.hidden = NO;
        }
            break;
            
        case 3:
        {
            cell.imgView.image = [UIImage imageNamed:@"user_bind_phone"];
            if ([[[GlobalSetting shareGlobalSettingInstance] mMobile] length]==11) { //已绑定
                if ([[[GlobalSetting shareGlobalSettingInstance] mMobile] length] == 11) {
                    NSString *tel = [[[GlobalSetting shareGlobalSettingInstance] mMobile] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                    cell.textL.text = [NSString stringWithFormat:@"绑定手机 %@",tel];
                }
                cell.noticeL.text = @"更改";
            }
            else { //未绑定
                cell.textL.text = @"";
                cell.noticeL.text = @"绑定";
            }
            
            cell.noticeL.textColor = RGBCOLOR(53, 53, 53);
            
            cell.accessoryIM.hidden = NO;
        }
            break;
            
        case 4:
        {
            cell.imgView.image = [UIImage imageNamed:@"user_password"];
            cell.textL.text = @"登录密码";
            cell.noticeL.textColor = RGBCOLOR(53, 53, 53);
            cell.noticeL.text = @"修改";
            cell.accessoryIM.hidden = NO;
        }
            break;
            
        default:
            break;
    }

    return cell;
    
}

//设置Separator顶头
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (indexPath.row == 0) {
        
        
        NSString *mIdentityId = [[GlobalSetting shareGlobalSettingInstance] mIdentityId];
        mIdentityId = [mIdentityId substringToIndex:2];
        if (![mIdentityId isEqualToString:@"99"] ) {
            
            AuthenticationViewController *authenticationVC = [[AuthenticationViewController alloc] init];
            authenticationVC.isAuthenticated = YES;
            authenticationVC.titleStr = @"修改邮箱";
            [self.navigationController pushViewController:authenticationVC animated:YES];
      

        }else {
            AuthenticationViewController *authenticationVC = [[AuthenticationViewController alloc] init];
            authenticationVC.isAuthenticated = NO;
            authenticationVC.titleStr = @"实名认证";
            [self.navigationController pushViewController:authenticationVC animated:YES];

            
        }
        
        
    }
    else if (indexPath.row == 1) {
        
        NSString *cid = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] cId]];
       cid = [cid substringToIndex:8];
        NSLog(@"%@",cid);
        
        if ([cid isEqualToString:@"00000000"]) {
            MemberCardViewController *cardVC = [[MemberCardViewController alloc] init];
            cardVC.isChangeCard = NO;
            cardVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cardVC animated:YES];
        }
       
    }
    else if (indexPath.row == 2) {
        ReceiveAddressViewController *receiveVC = [[ReceiveAddressViewController alloc] init];
        receiveVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:receiveVC animated:YES];
    }
    else if (indexPath.row == 3) {
        BindViewController *bindVC = [[BindViewController alloc] init];
        bindVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bindVC animated:YES];
    }
    else if (indexPath.row == 4) {
        ChangePWDViewController *changeVC = [[ChangePWDViewController alloc] init];
        changeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:changeVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)logoutAction {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出登录积分宝吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 4040;
    [alert show];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 4040) {
        if (buttonIndex == 1) {
            [[GlobalSetting shareGlobalSettingInstance] logoutRemoveAllUserInfo];   //清空用户信息
            MBProgressHUD *mbpro = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbpro.mode = MBProgressHUDModeCustomView;
            UIImageView *imgV = [[UIImageView alloc] initWithImage:nil];
            mbpro.customView = imgV;
            mbpro.labelText = @"已退出登录";
            mbpro.animationType = MBProgressHUDAnimationFade;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //        if ([responseObject[@"result"] isEqualToString:@"success"]) {
                [self.navigationController popViewControllerAnimated:YES];
                //        }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
