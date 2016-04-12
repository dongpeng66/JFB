//
//  OrderEntityTwoCell.m
//  订单详情
//
//  Created by 积分宝 on 16/1/7.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "OrderEntityTwoCell.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT ([[UIScreen mainScreen] bounds].size.height*.31)
@implementation OrderEntityTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor =[UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,HEIGHT*.213, WITH, 1)];
        
      
        lab.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
        [self addSubview:lab];
        
        UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0,HEIGHT*.5, WITH, 1)];
        
       // NSLog(@"%f--c--",99/HEIGHT);
        lab2.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
        [self addSubview:lab2];
        
       
    
        
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    
    UIColor *textColor = RGBCOLOR(90, 90, 90);

    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.04, WITH*.3, HEIGHT*.14)];
    lab1.text = @"订单状态";
    lab1.textColor = textColor;
    //lab1.backgroundColor = [UIColor redColor];
    [self addSubview:lab1];
    self.stateL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.6, HEIGHT*.04, WITH*.37, HEIGHT*.14)];
    //_stateL.backgroundColor = [UIColor grayColor];
    _stateL.textColor = textColor;
    _stateL.text = @"待付款";
    _stateL.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_stateL];
    
    self.leftStateL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.26, WITH*.4, HEIGHT*.2)];
    //_leftStateL.backgroundColor = [UIColor redColor];
    _leftStateL.text = @"您还未付款";
    _leftStateL.textColor = textColor;
    _leftStateL.font = [UIFont systemFontOfSize:22];
    [self.contentView addSubview:_leftStateL];
    [self addRightBtn];
    
    self.consigneeL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.57, WITH*.5, HEIGHT*.15)];
    _consigneeL.textColor = textColor;
    _consigneeL.text = @"收获人:张先生";
  //  _consigneeL.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_consigneeL];
    
    self.phoneNumberL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.5, HEIGHT*.57, WITH*.47, HEIGHT*.15)];
    _phoneNumberL.textColor = textColor;
    _phoneNumberL.text = @"17858858540";
    _phoneNumberL.textAlignment = NSTextAlignmentRight;
  //  _phoneNumberL.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_phoneNumberL];
    
    self.addressL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.7, WITH*.94, HEIGHT*.27)];
    _addressL.textColor = textColor;
    _addressL.text = @"地址:浙江省杭州市滨江区江南大道旁,浙江省杭州市滨江区江南大道旁浙江省杭州市滨江区江南大道旁";
    _addressL.numberOfLines = 0;
    _addressL.textAlignment = NSTextAlignmentLeft;
   // _addressL.backgroundColor = [UIColor redColor];
    _addressL.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_addressL];

    if (WITH<375) {
        _addressL.font = [UIFont systemFontOfSize:10];
        _leftStateL.font = [UIFont systemFontOfSize:16];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _consigneeL.font = [UIFont systemFontOfSize:14];
        _phoneNumberL.font = [UIFont systemFontOfSize:14];
        lab1.font = [UIFont systemFontOfSize:14];
        _stateL.font = [UIFont systemFontOfSize:14];
    }
    _tishiL.font = _payBtn.titleLabel.font;
}
-(void)addRightBtn{
    
    UIColor *textColor = RGBCOLOR(90, 90, 90);

    
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.frame = CGRectMake(WITH*.74, HEIGHT*.285, WITH*.23, HEIGHT*.15) ;
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
    
    _tishiL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.3, HEIGHT*.285, WITH*.67, HEIGHT*.15)];
    _tishiL.hidden = YES;
    _tishiL.text = @"超过10天自动确认收货";
    _tishiL.textAlignment = NSTextAlignmentRight;
    _tishiL.textColor = textColor;
    [self.contentView addSubview:_tishiL];

    
}
@end
