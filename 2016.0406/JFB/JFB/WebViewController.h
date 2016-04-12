//
//  WebViewController.h
//  JFB
//
//  Created by JY on 15/8/23.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (retain, nonatomic) NSString *webUrlStr; //Web加载的地址
@property (retain, nonatomic) NSString *titleStr;
@property (assign, nonatomic) BOOL canShare; //是否可以分享
@property (copy,nonatomic) NSString *isFrame;
@property (nonatomic,strong) UIWebView *webView;
@end
