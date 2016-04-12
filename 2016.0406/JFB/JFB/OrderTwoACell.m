//
//  OrderTwoACell.m
//  订单详情
//
//  Created by 积分宝 on 16/1/11.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "OrderTwoACell.h"
#import "QRCodeGenerator.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  ([[UIScreen mainScreen] bounds].size.height*.251)
@implementation OrderTwoACell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self addFenGeXian];
        [self addZhuanTai];
        [self addDiBuView];

        if (WITH<375) {
           _timeL.font = [UIFont systemFontOfSize:10];
            _giveUpBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        }
    }
    return self;
}
//分割线
-(void)addFenGeXian{
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,HEIGHT*.262, WITH, 1)];
    lab.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
    [self addSubview:lab];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0,HEIGHT*1.82, WITH, 1)];
    lab2.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
    [self addSubview:lab2];
}
//状态
-(void)addZhuanTai{
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.05, WITH*.3, HEIGHT*.18)];
    lab1.text = @"订单状态";
    lab1.textColor = [UIColor grayColor];
    // lab1.backgroundColor = [UIColor redColor];
    [self addSubview:lab1];
    
    
    self.stateL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.6, HEIGHT*.05, WITH*.37, HEIGHT*.18)];
    //_stateL.backgroundColor = [UIColor grayColor];
    _stateL.textColor = [UIColor redColor];
    _stateL.text = @"未使用";
    _stateL.textAlignment = NSTextAlignmentRight;
    [self addSubview:_stateL];
}
//底部
-(void)addDiBuView{
    
    self.giveUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _giveUpBtn.frame = CGRectMake(WITH*.77, HEIGHT*1.86, WITH*.2, HEIGHT*.18) ;
    //_giveUpBtn.backgroundColor = [UIColor grayColor];
    _giveUpBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    _giveUpBtn.layer.masksToBounds = YES;
    _giveUpBtn.layer.cornerRadius = 5.0;
    _giveUpBtn.clipsToBounds = YES;
    _giveUpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_giveUpBtn setTitle:@"申请退款" forState:UIControlStateNormal];
    [_giveUpBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_giveUpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _giveUpBtn.layer.borderColor  =[[UIColor redColor] CGColor]; //要设置的颜色
    _giveUpBtn.layer.borderWidth = 1; //要设置的描边宽
    [self addSubview:_giveUpBtn];
    
    self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*1.86, WITH*.6, HEIGHT*.18)];
    //_timeL.backgroundColor = [UIColor grayColor];
    _timeL.textColor = [UIColor redColor];
    _timeL.font = [UIFont systemFontOfSize:15];
    _timeL.textColor = [UIColor grayColor];
   // _timeL.text = @"有效期：2015.12.12-2016.12.12";
    _timeL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_timeL];
}
-(void)addAuthCodeL:(NSString *)text{
    self.authCodeL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.2, HEIGHT*.42, WITH*.6, HEIGHT*.25)];
    
   // _authCodeL.backgroundColor = [UIColor redColor];
    _authCodeL.font = [UIFont systemFontOfSize:20];
     _attributedText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"验证码：%@",text]];
    [_attributedText addAttribute:NSForegroundColorAttributeName
     
                            value:[UIColor grayColor]
     
                            range:NSMakeRange(0,4)];
    [_attributedText addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:13]
                            range:NSMakeRange(0, 4)];
    _authCodeL.textAlignment = NSTextAlignmentCenter;
    _authCodeL.attributedText = _attributedText;
    [self.contentView addSubview:_authCodeL];
    
    [self addErWeiMa:text];
}

//二维码
-(void)addErWeiMa:(NSString*)text{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((WITH-WITH*.48)/2, HEIGHT*.66,WITH*.48, HEIGHT*1.075)];
    // NSLog(@"----------%f---,",120/HEIGHT);
    //    NSLog(@"----------%f---,",180/HEIGHT);
    //imageView.backgroundColor = [UIColor greenColor];
    imageView.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"jfb-voucher:%@",text] imageSize:imageView.frame.size.width];
    [self.contentView addSubview:imageView];
}
@end
