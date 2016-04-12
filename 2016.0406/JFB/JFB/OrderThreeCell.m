//
//  OrderThreeCell.m
//  订单详情
//
//  Created by 积分宝 on 16/1/7.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "OrderThreeCell.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  ([[UIScreen mainScreen] bounds].size.height*.103)
@implementation OrderThreeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor =[UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.75, 10, 1, HEIGHT-20)];
        lab.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
        [self addSubview:lab];
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    
    UIColor *textColor = RGBCOLOR(90, 90, 90);

    self.shopNameL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.16, WITH*.6, HEIGHT*.3)];
  //  _shopNameL.backgroundColor = [UIColor redColor];
   // _shopNameL.text = @"积分宝体验店";
    _shopNameL.textColor = textColor;
    [self.contentView addSubview:_shopNameL];
    
    self.bigSiteL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.45, WITH*.7, HEIGHT*.4)];
    _bigSiteL.textColor = textColor;
  // _bigSiteL.backgroundColor = [UIColor redColor];
    _bigSiteL.textAlignment = NSTextAlignmentLeft;
    _bigSiteL.numberOfLines = 0;
    _bigSiteL.font = [UIFont systemFontOfSize:12];
    _bigSiteL.text = @"浙江省杭州市临安区临安路临安小区99号,浙江省杭州市临安区";
    [self.contentView addSubview:_bigSiteL];
    

    
    self.phoneBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_phoneBtn setImage:[UIImage imageNamed:@"ic_phone_deal_detail"] forState:UIControlStateNormal];
    //_phoneBtn.backgroundColor = [UIColor redColor];
    _phoneBtn.frame = CGRectMake(WITH*.8, (HEIGHT-HEIGHT*.56)/2, WITH*.15, HEIGHT*.56) ;
    [self.contentView addSubview:_phoneBtn];
    if (WITH<375) {
        _bigSiteL.font = [UIFont systemFontOfSize:10];
        _shopNameL.font = [UIFont systemFontOfSize:12];
    }
}
@end
