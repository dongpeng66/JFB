//
//  SubmitOrderViewController.h
//  JFB
//
//  Created by JY on 15/9/4.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitOrderViewController : UIViewController

@property (strong, nonatomic) UILabel *goodsNameL;
@property (strong, nonatomic) UILabel *singlePriceL;
@property (strong, nonatomic) UITextField *numberTF;
@property (strong, nonatomic)  UIButton *decBtn;
@property (strong, nonatomic)  UIButton *incBtn;
@property (strong, nonatomic) UILabel *allPriceL;
@property (strong, nonatomic)  UILabel *phoneL;


@property (strong, nonatomic) NSString *merchant_id;
@property (strong, nonatomic) NSDictionary *goodsdataDic;
@property (strong, nonatomic) NSString *order_no;
@property (strong, nonatomic) NSString *fraction;

@property (strong,nonatomic) NSString *number;
@property (strong,nonatomic)NSString *shibie;

@property (strong,nonatomic)NSString *nameText;
@property (strong,nonatomic)NSString *numberText;
@property (strong,nonatomic)NSString *diZhiText;
@property (strong,nonatomic)NSString *their_type;
@property (strong,nonatomic)NSString *accept_name;
@property (strong,nonatomic)NSString *address;
@property (strong,nonatomic)NSString *myMobile;
@property (strong,nonatomic) NSDictionary *myDiZhi;
@property (strong,nonatomic)NSString *cao;
@property (strong,nonatomic)NSString *ma;
@property (strong,nonatomic)NSString *caocao;

@property (strong,nonatomic)NSString* shangPan;//判断购买商品
//@property (strong,nonatomic) NSString *addresID;
@end
