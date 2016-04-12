//
//  PhontViewController.m
//  JFB
//
//  Created by 积分宝 on 16/3/15.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "PhontViewController.h"
#import "PhotoBrowserView.h"
@interface PhontViewController ()

@end

@implementation PhontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"商品相册";
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    
    
    self.extendedLayoutIncludesOpaqueBars=YES;  //解决隐藏导航栏问题
    self.view.backgroundColor = [UIColor blackColor];
    PhotoBrowserView *_photoBrowserView=[[PhotoBrowserView alloc]initWithFrame:self.view.bounds WithArray:_photoArr andCurrentIndex:0];
    
    NSLog(@"%@",_photoArr);
    [self.view addSubview:_photoBrowserView];

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

@end
