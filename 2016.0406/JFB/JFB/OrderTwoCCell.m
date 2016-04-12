//
//  OrderTwoCCell.m
//  订单详情
//
//  Created by 积分宝 on 16/1/11.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "OrderTwoCCell.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  ([[UIScreen mainScreen] bounds].size.height*.197)
@implementation OrderTwoCCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self addFenGeXian];
        [self addZhuanTai];
      
        self.tishiL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.4, WITH*.8, HEIGHT*.2)];
        // _tishiL.backgroundColor = [UIColor grayColor];
        _tishiL.textColor = [UIColor grayColor];
        _tishiL.text = @"交易完成,你可以看看其他商品哦,别忘了给评价";
        _tishiL.font = [UIFont systemFontOfSize:14];
        _tishiL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_tishiL];
        
        self.leftIM = [[UIImageView alloc]initWithFrame:CGRectMake(WITH*.937, HEIGHT*.4, WITH*.033, HEIGHT*.2)];
        //_leftIM.backgroundColor = [UIColor redColor];
        _leftIM.image = [UIImage imageNamed:@"nima"];
        _leftIM.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_leftIM];
        
        
        self.shenQingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shenQingBtn.frame = CGRectMake(WITH*.77, HEIGHT*.75, WITH*.2, HEIGHT*.18) ;
        //_giveUpBtn.backgroundColor = [UIColor grayColor];
        _shenQingBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _shenQingBtn.layer.masksToBounds = YES;
        _shenQingBtn.layer.cornerRadius = 5.0;
        _shenQingBtn.clipsToBounds = YES;
        _shenQingBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_shenQingBtn setTitle:@"订单投诉" forState:UIControlStateNormal];
        [_shenQingBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_shenQingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _shenQingBtn.layer.borderColor  =[[UIColor redColor] CGColor]; //要设置的颜色
        _shenQingBtn.layer.borderWidth = 1; //要设置的描边宽
        [self.contentView addSubview:_shenQingBtn];
        if(WITH<375){
            _tishiL.font = [UIFont systemFontOfSize:12];
            _shenQingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        }
    }
    return self;
}

//分割线
-(void)addFenGeXian{
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,HEIGHT*.334, WITH, 1)];
    lab.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
    [self addSubview:lab];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0,HEIGHT*.669, WITH, 1)];
    lab2.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
    [self addSubview:lab2];
}
//状态
-(void)addZhuanTai{
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.05, WITH*.3, HEIGHT*.2)];
    lab1.text = @"订单状态";
    lab1.textColor = [UIColor grayColor];
    // lab1.backgroundColor = [UIColor redColor];
    [self addSubview:lab1];
    
    
    self.stateL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.6, HEIGHT*.05, WITH*.37, HEIGHT*.2)];
    //_stateL.backgroundColor = [UIColor grayColor];
    _stateL.textColor = [UIColor redColor];
    _stateL.text = @"未使用";
    _stateL.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_stateL];
}

@end
