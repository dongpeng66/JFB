//
//  PayFinishViewController.m
//  JFB
//
//  Created by LYD on 15/9/23.
//  Copyright © 2015年 JY. All rights reserved.
//

#import "PayFinishViewController.h"
#import "CouponTableViewCell.h"
#import "MyEntityOrderViewCountroller.h"
#import "HomeViewController.h"
#import "TabBarController.h"
#import "AppDelegate.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define CouponCell    @"couponTableViewCell"

@interface PayFinishViewController ()
{
     NSArray *couponAry;
}

@end

@implementation PayFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     self.title = @"支付结果";
    NSLog(@"------------------%@",self.finishDic);
    float height  = HEIGHT*.3-1-64;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,64, WITH, HEIGHT*.3-1-64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    //订单号
    NSString *order_on = [NSString stringWithFormat:@"订单编号：%@",self.finishDic [@"orderNum"]];
    
    //商品名
    NSString *goods_name = [NSString stringWithFormat:@"商品名称：%@",self.goodsShopName];
    
    //实付金额
    
    NSString *real_amount = [NSString stringWithFormat:@"实付金额：%@",self.finishDic [@"goodsAmount"]];
    
    NSArray *arr = [NSArray arrayWithObjects:order_on,goods_name,real_amount, nil];
    self.view.backgroundColor = [UIColor colorWithRed:239/255. green:239/255. blue:239/255. alpha:1];
   
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(WITH*.195,(height-height*.444)/2+10, WITH *(45/667), HEIGHT*(45/667))];
    //image.backgroundColor = [UIColor orangeColor];
    image.image = [UIImage imageNamed:@"extra_checked"];
    [view addSubview:image];
    NSLog(@"%f",60/height);
    UILabel *tishiL = [[UILabel alloc]initWithFrame:CGRectMake((WITH-WITH*.5)/2, (height-height*.444)/2, WITH*.5, height*.444)];
    // tishiL.backgroundColor = [UIColor orangeColor];
    tishiL.text = @"购买成功";
    tishiL.textAlignment = NSTextAlignmentCenter;
    tishiL.font = [UIFont systemFontOfSize:33];
    [view addSubview:tishiL];
    
    NSLog(@"%f---%f",50/height,50/WITH);
    for (int i = 0; i<3; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT*.3+(HEIGHT*.08+1)*i, WITH, HEIGHT*.08)];
        lab.backgroundColor = [UIColor whiteColor];
       lab.text = [NSString stringWithFormat:@"    %@",arr[i]];
        [self.view addSubview:lab];
    }
    
    
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.6, WITH*.45, HEIGHT*.089)];
    leftBtn.backgroundColor = [UIColor colorWithRed:26/255. green:194/255. blue:115/255. alpha:1];
    [leftBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    leftBtn.clipsToBounds = YES;
    leftBtn.layer.cornerRadius =6;
    [leftBtn addTarget:self action:@selector(lookMyEntityOrderViewCountroller:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(WITH*.52, HEIGHT*.6, WITH*.45, HEIGHT*.089)];
    rightBtn.backgroundColor = [UIColor colorWithRed:250/255. green:37/255. blue:53/255. alpha:1];
    [rightBtn setTitle:@"继续购物" forState:UIControlStateNormal];
    rightBtn.clipsToBounds = YES;
    rightBtn.layer.cornerRadius =6;
    [rightBtn addTarget:self action:@selector(toHomeViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];

 
}


////设置Separator顶头
//-(void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    
//    if ([self.couponTableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.couponTableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([self.couponTableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.couponTableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//
//
//#pragma mark - UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [couponAry count];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CouponTableViewCell *cell = (CouponTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CouponCell];
//    NSDictionary *dic = couponAry [indexPath.row];
//    cell.couponNoL.text = [NSString stringWithFormat:@"代金券%ld",(long)indexPath.row + 1];
//    cell.couponCodeL.text = [NSString stringWithFormat:@"%@",dic [@"consume_code"]];
//    return cell;
//}
//
////设置Separator顶头
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//

//- (IBAction)continueGoBuy:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];        
    NSMutableArray *controllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (id controller in self.navigationController.viewControllers) {
        if ([NSStringFromClass([controller class]) isEqualToString:@"PayOrderViewController"]) {
            [controllers removeObject:controller];
        }
    }
    [self.navigationController setViewControllers:controllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
}

#pragma mark - 查看订单
-(void)lookMyEntityOrderViewCountroller:(UIButton *)btn{
    MyEntityOrderViewCountroller *view = [[MyEntityOrderViewCountroller alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}
#pragma mark - 继续购物
-(void)toHomeViewController:(UIButton *)btn{
    
 [self.navigationController popToRootViewControllerAnimated:NO];
   
}
@end
