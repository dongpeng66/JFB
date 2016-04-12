//
//  OrderTwoCell.m
//  订单详情
//
//  Created by 积分宝 on 16/1/7.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "OrderTwoCell.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  ([[UIScreen mainScreen] bounds].size.height*.27)
@implementation OrderTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor =[UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,HEIGHT*.245, WITH, 1)];
        lab.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
        [self addSubview:lab];

        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.05, WITH*.3, HEIGHT*.16)];
        lab1.text = @"订单状态";
        lab1.textColor = [UIColor grayColor];
      //  lab1.backgroundColor = [UIColor redColor];
        [self addSubview:lab1];
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    self.stateL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.6, HEIGHT*.05, WITH*.37, HEIGHT*.16)];
    //_stateL.backgroundColor = [UIColor grayColor];
    _stateL.textColor = [UIColor redColor];
    _stateL.text = @"待付款";
    _stateL.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_stateL];
    [self addLeftBtn];
    [self addRightBtn];
}
-(void)addLeftBtn{
    self.giveUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _giveUpBtn.frame = CGRectMake(WITH*.1, HEIGHT*.41, WITH*.3, HEIGHT*.25) ;
    //_payBtn.backgroundColor = [UIColor grayColor];
    _giveUpBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    _giveUpBtn.layer.masksToBounds = YES;
    _giveUpBtn.layer.cornerRadius = 5.0;
    _giveUpBtn.clipsToBounds = YES;
    [_giveUpBtn setTitle:@"放弃订单" forState:UIControlStateNormal];
    [_giveUpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_giveUpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    _giveUpBtn.layer.borderColor  =[[UIColor grayColor] CGColor]; //要设置的颜色
    _giveUpBtn.layer.borderWidth = 1; //要设置的描边宽
    [self.contentView addSubview:_giveUpBtn];
}
-(void)addRightBtn{
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.frame = CGRectMake(WITH*.6, HEIGHT*.41, WITH*.3, HEIGHT*.25) ;
    //_payBtn.backgroundColor = [UIColor grayColor];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    _payBtn.layer.masksToBounds = YES;
    _payBtn.layer.cornerRadius = 5.0;
    _payBtn.clipsToBounds = YES;
    [_payBtn setTitle:@"去付款" forState:UIControlStateNormal];
    [_payBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_payBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _payBtn.layer.borderColor  =[[UIColor redColor] CGColor]; //要设置的颜色
    _payBtn.layer.borderWidth = 1; //要设置的描边宽
    [self.contentView addSubview:_payBtn];
}
@end
