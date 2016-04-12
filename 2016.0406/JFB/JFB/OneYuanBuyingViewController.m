//
//  OneYuanBuyingViewController.m
//  JFB
//
//  Created by 积分宝 on 16/4/6.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "OneYuanBuyingViewController.h"
#import "WebViewJavascriptBridge.h"
#import "LoginViewController.h"
@interface OneYuanBuyingViewController ()
@property WebViewJavascriptBridge* bridge;
@end

@implementation OneYuanBuyingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (_bridge) { return; }
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
         BOOL isLogined = [[GlobalSetting shareGlobalSettingInstance] isLogined];
        
        if (!isLogined) {
            LoginViewController *view = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:view animated:YES];
        }else {
             NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
            id data = @{ @"token": token };
            [_bridge callHandler:@"getToken" data:data responseCallback:^(id response) {
                NSLog(@"testJavascriptHandler responded: %@", response);
            }];
 
        }
    }];
    
    
    [self renderButtons:webView];
    [self loadExamplePage:webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

- (void)renderButtons:(UIWebView*)webView {
//    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
//    
//    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
//    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:callbackButton aboveSubview:webView];
//    callbackButton.frame = CGRectMake(10, 400, 100, 35);
//    callbackButton.titleLabel.font = font;
//    
//    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
//    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:reloadButton aboveSubview:webView];
//    reloadButton.frame = CGRectMake(110, 400, 100, 35);
//    reloadButton.titleLabel.font = font;
}

//- (void)callHandler:(id)sender {
//    id data = @{ @"greetingFromObjC": @"哈哈哈哈哈哈哈哈!" };
//    [_bridge callHandler:@"getToken" data:data responseCallback:^(id response) {
//        NSLog(@"testJavascriptHandler responded: %@", response);
//    }];
//}

- (void)loadExamplePage:(UIWebView*)webView {

    NSString *url = [NSString stringWithFormat:@"http://192.168.1.180/app/oneyuanmes/appindex.htm"];
    NSURL *baseURL = [NSURL URLWithString:url];
    [webView loadRequest:[NSURLRequest requestWithURL:baseURL]];
}

@end
