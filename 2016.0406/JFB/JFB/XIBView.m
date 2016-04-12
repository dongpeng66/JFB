//
//  XIBView.m
//  xib
//
//  Created by 积分宝 on 15/12/2.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import "XIBView.h"
#define w self.frame.size.width
#define h self.frame.size.height
@implementation XIBView
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self){
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    
    _personalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w, h*.68)];
    _personalImageView.backgroundColor = [UIColor redColor];
    _personalImageView.image=[UIImage imageNamed:@"personal"];

    [self addSubview:_personalImageView];
    
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(w*.07, h*.2, h*.33, h*.33)];
    _headImageView.contentMode=UIViewContentModeScaleAspectFit;
    _headImageView.image=[UIImage imageNamed:@"headImage"];
    [self addSubview:_headImageView];
    
    _nameL = [[UILabel alloc]initWithFrame:CGRectMake(w*.07*2+h*.33-5, h*.28, w-w*.07, 21)];
    _nameL.textColor = [UIColor whiteColor];
    _nameL.textAlignment=NSTextAlignmentLeft;
    _nameL.text=@"梁茜龄";
    _nameL.font = [UIFont systemFontOfSize:20];
    [self addSubview:_nameL];
    
    
    _numberL = [[UILabel alloc]initWithFrame:CGRectMake(w*.07*2+h*.33-5, h*.39, w-w*.07, 21)];
    _numberL.textColor = [UIColor whiteColor];
    _numberL.textAlignment=NSTextAlignmentLeft;
    _numberL.text=@"卡号:9566885654354611";
    _numberL.font = [UIFont systemFontOfSize:13];
    [self addSubview:_numberL];
    
    _twoDimensionBtn=[[UIButton alloc]initWithFrame:CGRectMake(w*.85, h*.07, 44, 44)];
    [_twoDimensionBtn setImage:[UIImage imageNamed:@"two_dimension"] forState:UIControlStateNormal];
    [self addSubview:_twoDimensionBtn];
    
    _indicateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(w*.87, h*.3, h*.15, h*.15)];
    _indicateImageView.contentMode=UIViewContentModeScaleAspectFit;
    _indicateImageView.image=[UIImage imageNamed:@"jiantou"];
    [self addSubview:_indicateImageView];
    
    _privilegeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(w*.04, h*.74, w*.17, h*.2)];
    _privilegeImageView.contentMode=UIViewContentModeScaleAspectFit;
    _privilegeImageView.image=[UIImage imageNamed:@"privilege"];
    [self addSubview:_privilegeImageView];
    
    
    _privilegeL = [[UILabel alloc]initWithFrame:CGRectMake(w*.27, h*.81, w*.25, 30)];
    _privilegeL.textColor = [UIColor redColor];
    _privilegeL.textAlignment=NSTextAlignmentLeft;
    _privilegeL.text=@"红包";
    _privilegeL.font = [UIFont systemFontOfSize:16];
    [self addSubview:_privilegeL];
    
     _annuityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(w*.52, h*.74, w*.17, h*.2)];
     _annuityImageView.contentMode=UIViewContentModeScaleAspectFit;
     _annuityImageView.image=[UIImage imageNamed:@"annuity"];
    [self addSubview: _annuityImageView];
    
    _annuityL = [[UILabel alloc]initWithFrame:CGRectMake(w*.74, h*.81, w*.25, 30)];
    _annuityL.textColor = [UIColor redColor];
    _annuityL.textAlignment=NSTextAlignmentLeft;
    _annuityL.text=@"养老金";
    _annuityL.font = [UIFont systemFontOfSize:16];
    [self addSubview:_annuityL];
    
   // _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, h*.68, w*.5, h-h*.68)];
    _leftBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    _leftBtn.frame =CGRectMake(0, h*.68, w*.5, h-h*.68);
    [self addSubview:_leftBtn];
    
   // _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(w*.5, h*.68, w*.5, h-h*.68)];
    _rightBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    _rightBtn.frame =CGRectMake(w*.5, h*.68, w*.5, h-h*.68);
    [self addSubview:_rightBtn];
    
    _verticalL=[[UILabel alloc]initWithFrame:CGRectMake(w*.5,h*.68, 1, h-h*.68)];
    _verticalL.backgroundColor=[UIColor grayColor];
    _verticalL.alpha=.3;
    [self addSubview:_verticalL];
    _numberL2 = [[UILabel alloc]initWithFrame:CGRectMake(w*.74, h*.73, w*.28, 30)];
    _numberL2.textColor = [UIColor redColor];
    [self addSubview:_numberL2];
}
-(void)setYuan:(float)yuan{
    
    _yuan=yuan;
   
    _numberL2.textAlignment=NSTextAlignmentLeft;
    _numberL2.numberOfLines = 3;
    
    _attributedText2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f(元)",_yuan]];
    NSString *s=[NSString stringWithFormat:@"%.2f",_yuan];
    NSLog(@"%lu",(unsigned long)s.length);
    NSRange contentRange2 = {0,s.length};
    

    if(s.length>4){
        
        _numberL2.font = [UIFont systemFontOfSize:14];
    }else {
    
        [_attributedText2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23] range:contentRange2];

    }
       _numberL2.attributedText = _attributedText2;
    
    

}
-(void)setZhang:(int)zhang{
    
    
    _numberL1 = [[UILabel alloc]initWithFrame:CGRectMake(w*.27, h*.71, w*.25, 30)];
    _numberL1.textColor = [UIColor redColor];
    _numberL1.textAlignment=NSTextAlignmentLeft;
    _numberL1.numberOfLines = 3;
    NSString *s=[NSString stringWithFormat:@"%d",zhang];
    _attributedText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d(个)",zhang]];
    NSRange contentRange = {0,s.length};
    [_attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23] range:contentRange];
    _numberL1.attributedText = _attributedText;
    [self addSubview:_numberL1];

}
@end











