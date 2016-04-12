//
//  GoodsDetailWebVC.m
//  JFB
//
//  Created by JY on 15/9/4.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "GoodsDetailWebVC.h"
#import "SubmitOrderViewController.h"
#import "LoginViewController.h"
@interface GoodsDetailWebVC ()
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
}

@end

@implementation GoodsDetailWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"图文详情";
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    
    self.priceL.text = [NSString stringWithFormat:@"%@元",self.goodsDic [@"buyPrice"]];
    self.costPriceStrikeL.text = [NSString stringWithFormat:@"%@元",self.goodsDic [@"marketPrice"]];
    self.costPriceStrikeL.strikeThroughEnabled = YES;
    
    [_detailWebView setScalesPageToFit:YES];
    
    NSURL *url = [NSURL URLWithString:self.webUrlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3600];
    [_detailWebView loadRequest:request];
    
}

- (IBAction)buyAction:(id)sender {
    
    BOOL isLogined = [[GlobalSetting shareGlobalSettingInstance] isLogined];
    if (! isLogined) {
        NSLog(@"未登录");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，现在登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 4040;
        [alert show];
        return;
    }else {

    SubmitOrderViewController *submitVC = [[SubmitOrderViewController alloc] init];
    submitVC.merchant_id = self.merchant_id;
    submitVC.goodsdataDic = self.goodsDic;
    submitVC.fraction =self.fraction;
    submitVC.ma =self.merchant_id;
    submitVC.cao = @"ni";
    submitVC.their_type = _their_type;
    submitVC.shangPan = _shangPan;
        [self.navigationController pushViewController:submitVC animated:YES];
    }
}

#pragma mark - UIWeb Delegate
-(void)webViewDidStartLoad:(UIWebView *)webView {
    
    [_hud show:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_hud hide:YES];
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSLog(@"currentURL  is  %@",currentURL);
//    NSString *title = [_detailWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    self.title = title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 4040 || alertView.tag == 5050) {
        if (buttonIndex == 1) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }
}
@end
