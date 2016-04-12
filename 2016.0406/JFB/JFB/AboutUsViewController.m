//
//  AboutUsViewController.m
//  JFB
//
//  Created by 积分宝 on 16/3/4.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
    UITextView *textView;
}
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    textView = [[UITextView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:textView];
    [self requesPersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 关于请求
-(void)requesPersion{
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:@"AboutUs" object:nil];
      NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"AboutUs", @"op", nil];
 
    NSString *url = [NSString stringWithFormat:@"apphelp/listone.htm?type=%@",_type];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
}
#pragma mark - 网络请求结果数据
-(void) didFinishedRequestData:(NSNotification *)notification{
    [_hud hide:YES];
    if ([[notification.userInfo valueForKey:@"RespResult"] isEqualToString:ERROR]) {
        if (!_networkConditionHUD) {
            _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:_networkConditionHUD];
        }
        _networkConditionHUD.labelText = [notification.userInfo valueForKey:@"ContentResult"];
        _networkConditionHUD.mode = MBProgressHUDModeText;
        _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
        _networkConditionHUD.margin = HUDMargin;
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    NSDictionary *responseObject = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    NSLog(@"GetMerchantList_responseObject: %@",responseObject);
    
    if ([notification.name isEqualToString:@"AboutUs"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AboutUs" object:nil];
        if ([responseObject[@"code"] intValue] == 0) {
            _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            
            NSDictionary *dic = responseObject[@"data"];
            self.title = dic[@"title"];
            textView.text = [NSString stringWithFormat:@"    %@",dic[@"descn"]];

        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}



@end
