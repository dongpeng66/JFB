//
//  ShopDetailViewController.h
//  JFB
//
//  Created by JY on 15/8/29.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailViewController : UIViewController
@property (nullable,strong, nonatomic)  UIView *nearbyHeadView;
@property (nullable,strong, nonatomic)  UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn2;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn3;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn4;
@property (nullable,strong, nonatomic)  UIView *myHview;
@property (nullable,strong, nonatomic)  UIView *jianBian;

@property(assign,nonatomic)int frameBool;



@property (nullable,nonatomic,strong) NSString *cityName;
@property (nullable,nonatomic,strong) NSString *cityName1;

@property (nullable,strong, nonatomic) NSDictionary *merchantdataDic;  //商户信息数据字典
@property (nullable,nonatomic,strong)UIButton *rightBtn;//收藏


@property (nullable,nonatomic,strong)UIButton *leftBtn;//返回
@property(nullable,nonatomic,strong)NSDictionary *pram;
@property (nonatomic,strong,nullable) NSString *panduan;

@property (nullable,nonatomic,strong) NSString *merChantID;
@end
