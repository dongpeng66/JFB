//
//  WuLiuViewController.m
//  JFB
//
//  Created by 积分宝 on 16/1/26.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "WuLiuViewController.h"
#import <WebKit/WebKit.h>
@interface WuLiuViewController ()<UIWebViewDelegate>
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
}
@property(nonatomic,strong) UIWebView *webView;

@end

@implementation WuLiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"物流信息";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 200)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    NSString *url = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@yundakuaiti&postid=%@#result",_express_pycode,self.express_no];
    NSLog(@"%@ --- %@",_express_pycode,_express_no);

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    if (! _hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
    }
    
    if (!_networkConditionHUD) {
        _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_networkConditionHUD];
    }
    _networkConditionHUD.mode = MBProgressHUDModeText;
    _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
    _networkConditionHUD.margin = HUDMargin;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH,SCREEN_HEIGHT+64)];
        _webView.delegate = self;
    }
   
    return _webView;
}


//1.1.1 页面开始加载时调用
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    [_hud show:YES];
    NSLog(@"页面开始加载...");
}


//1.1.3 页面加载完成之后调用
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
     [_hud hide:YES];
    _networkConditionHUD.labelText = @"页面加载完成...";
    [_networkConditionHUD show:YES];
    [_networkConditionHUD hide:YES afterDelay:HUDDelay];
    NSLog(@"页面加载完成...");
}

//1.1.4 页面加载失败时调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
     [_hud hide:YES];
    _networkConditionHUD.labelText =@"页面加载失败...";
    [_networkConditionHUD show:YES];
    [_networkConditionHUD hide:YES afterDelay:HUDDelay];
    NSLog(@"页面加载失败...");
}



@end
