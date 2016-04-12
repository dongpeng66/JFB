//
//  OrderOneCell.m
//  订单详情
//
//  Created by 积分宝 on 16/1/7.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "OrderOneCell.h"

#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  ([[UIScreen mainScreen] bounds].size.height*.15)
@implementation OrderOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor =[UIColor whiteColor];
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    
    UIColor *textColor = RGBCOLOR(90, 90, 90);

    
    self.leftIM = [[UIImageView alloc]initWithFrame:CGRectMake(WITH *.03, HEIGHT*.13, WITH*.197, HEIGHT*.739)];
   // _leftIM.backgroundColor = [UIColor redColor];
    _leftIM.layer.masksToBounds = YES;
    _leftIM.layer.cornerRadius = 5.0;
    _leftIM.clipsToBounds = YES;
    _leftIM.contentMode = UIViewContentModeScaleAspectFill;
    NSLog(@"%f",WITH);
    // NSLog(@"%f",74/HEIGHT);
    _leftIM.image = [UIImage imageNamed:@"28"];
    [self.contentView addSubview:_leftIM];
    
    self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.25, HEIGHT*.1, WITH*.5, HEIGHT*.4)];
    _nameL.text = @"夏日特饮";
    _nameL.textColor = textColor;
    //_nameL.backgroundColor = [UIColor redColor];
    if (WITH==320) {
         _nameL.font = [UIFont systemFontOfSize:20];
        
    }else if(WITH<375&&WITH>320){
        _nameL.font = [UIFont systemFontOfSize:22];
    }else{
        _nameL.font = [UIFont systemFontOfSize:26];
    }
    [self.contentView addSubview:_nameL];
    
    self.moneyView = [[MoneyView alloc]initWithFrame:CGRectMake(WITH*.25, HEIGHT*.54, WITH*.7, HEIGHT*.3)];
    [self.contentView addSubview:_moneyView];
}

@end
