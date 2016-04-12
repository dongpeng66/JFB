//
//  GoodsDetailWebVC.h
//  JFB
//
//  Created by JY on 15/9/4.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrikeThroughLabel.h"

@interface GoodsDetailWebVC : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet StrikeThroughLabel *costPriceStrikeL;
@property (nonatomic,strong) NSString *their_type;
@property (retain, nonatomic) NSString *webUrlStr; //Web加载的地址
@property (strong, nonatomic) NSDictionary *goodsDic; //商品详情数据字典
@property (strong, nonatomic) NSString *merchant_id; //商户id
@property (strong, nonatomic) NSString *fraction; //商户id
@property (strong,nonatomic) NSString *caonima;

@property (strong,nonatomic)NSString *shangPan;//判断商品
@end
