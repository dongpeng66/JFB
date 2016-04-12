//
//  OrderForeCell.m
//  订单详情
//
//  Created by 积分宝 on 16/1/7.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "OrderForeCell.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT ([[UIScreen mainScreen] bounds].size.height*.45)
@implementation OrderForeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        self.backgroundColor =[UIColor whiteColor];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,HEIGHT*.147, WITH, 1)];
        lab.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
        [self addSubview:lab];
        
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.03, WITH*.3, HEIGHT*.1)];
        lab1.text = @"订单信息";
        lab1.textColor =   RGBCOLOR(90, 90, 90);
;
       // lab1.backgroundColor = [UIColor redColor];
        [self addSubview:lab1];
       
        
         self.copysL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.8, HEIGHT*.17, WITH*.17, HEIGHT*.07)];
        _copysL.layer.masksToBounds = YES;
        _copysL.layer.cornerRadius = 5.0;
        _copysL.textAlignment = NSTextAlignmentCenter;
        _copysL.text = @"复制";
        _copysL.textColor = [UIColor redColor];
        _copysL.font = [UIFont systemFontOfSize:12];
        _copysL.layer.borderColor  =[[UIColor redColor] CGColor]; //要设置的颜色
        _copysL.layer.borderWidth = 1; //要设置的描边宽
        [self addSubview:_copysL];
        
         [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    
    self.copysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _copysBtn.frame = CGRectMake(WITH*.75, HEIGHT*.12, WITH*.25, HEIGHT*.2);
       [self.contentView addSubview:_copysBtn];

    self.lab1 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.17, WITH*.7, HEIGHT*.07)];
   // _lab1.backgroundColor = [UIColor redColor];
    _lab1.textColor = [UIColor grayColor];
    _lab1.font = [UIFont systemFontOfSize:12];
    _lab1.text = @"订单号码：2015123021654676448847474774";
    [self.contentView addSubview:_lab1];
    
    self.lab2 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.23, WITH*.7, HEIGHT*.07)];
   // _lab2.backgroundColor = [UIColor redColor];
    _lab2.textColor = [UIColor grayColor];
    _lab2.font = [UIFont systemFontOfSize:12];
    _lab2.text = @"订单时间：2015-12-12 12:24";
    [self.contentView addSubview:_lab2];
    
    self.lab3 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.29, WITH*.7, HEIGHT*.07)];
   // _lab3.backgroundColor = [UIColor orangeColor];
    _lab3.textColor = [UIColor grayColor];
    _lab3.font = [UIFont systemFontOfSize:12];
    _lab3.text = @"订单时间：支付宝";
  [self.contentView addSubview:_lab3];
    
    self.lab4 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.35, WITH*.7, HEIGHT*.07)];
    _lab4.textColor = [UIColor grayColor];
   // _lab4.backgroundColor = [UIColor redColor];
    _lab4.font = [UIFont systemFontOfSize:12];
    _lab4.text = @"商品数量：2";
    [self.contentView addSubview:_lab4];
    
    self.lab5 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.41, WITH*.7, HEIGHT*.07)];
  //  _lab5.backgroundColor = [UIColor redColor];
    _lab5.textColor = [UIColor grayColor];
    _lab5.font = [UIFont systemFontOfSize:12];
    _lab5.text = @"订单总价：22";
    [self.contentView addSubview:_lab5];
    
    self.lab6 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.47, WITH*.7, HEIGHT*.07)];
  //  _lab6.backgroundColor = [UIColor redColor];
    _lab6.textColor = [UIColor grayColor];
    _lab6.font = [UIFont systemFontOfSize:12];
    _lab6.text = @"购买用户：张三";
    [self.contentView addSubview:_lab6];
    
    self.lab7 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.53, WITH*.7, HEIGHT*.07)];
  //  _lab7.backgroundColor = [UIColor redColor];
    _lab7.textColor = [UIColor grayColor];
    _lab7.font = [UIFont systemFontOfSize:12];
    _lab7.text = @"手机号码：17858858540";
    [self.contentView addSubview:_lab7];
    
    self.lab8 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.59, WITH*.9, HEIGHT*.07)];
   // _lab8.backgroundColor = [UIColor redColor];
    _lab8.textColor = [UIColor grayColor];
    _lab8.font = [UIFont systemFontOfSize:12];
    _lab8.text = @"收货地址：浙江省杭州市和呵呵呵呵呵呵呵呵呵呵";
    [self.contentView addSubview:_lab8];
    [self returnFont];
 }
-(void)returnFont{
    if (WITH<375) {
        _lab1.font = [UIFont systemFontOfSize:10];
        _lab2.font = [UIFont systemFontOfSize:10];
        _lab3.font = [UIFont systemFontOfSize:10];
        _lab4.font = [UIFont systemFontOfSize:10];
        _lab5.font = [UIFont systemFontOfSize:10];
        _lab6.font = [UIFont systemFontOfSize:10];
        _lab7.font = [UIFont systemFontOfSize:10];
        _lab8.font = [UIFont systemFontOfSize:10];
        _copysL.font = [UIFont systemFontOfSize:10];
    }
}
@end
