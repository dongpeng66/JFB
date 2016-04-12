//
//  TSFShopDetailHeadView.m
//  caocaocao
//
//  Created by 积分宝 on 15/12/14.
//  Copyright © 2015年 积分宝. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TSFShopDetailHeadView.h"
#define w [UIScreen mainScreen ].bounds.size.width
#define h self.frame.size.height
@implementation TSFShopDetailHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self){
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    

    
    NSLog(@"------%f",self.frame.size.width);
    
    self.bigIM = [[UIImageView alloc]initWithFrame:self.frame];
    
   // _bigIM.backgroundColor = [UIColor orangeColor];
    _bigIM.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
    _bigIM.image = [UIImage imageNamed:@"1"];
    
    NSLog(@"------%f",self.bigIM.frame.size.width);
    [self addSubview:_bigIM];
    
    self.imageMB = [[UIImageView alloc]initWithFrame:self.frame];
   // _imageMB.backgroundColor = [UIColor greenColor];
    _imageMB.image = [UIImage imageNamed:@"mengban"];
    _imageMB.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
    [self addSubview:_imageMB];
    
    
    self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(w*.05, h*.8, w*.44, h*.13)];
    _nameL.text = @"";
    _nameL.textColor = [UIColor whiteColor];
    _nameL.textAlignment = NSTextAlignmentLeft;
    _nameL.font = [UIFont systemFontOfSize:16];
    //_nameL.backgroundColor = [UIColor redColor];
    [self addSubview:_nameL];
    
    self.zhekouL = [[UILabel alloc]initWithFrame:CGRectMake(w*.55, h*.8, w*.2, h*.13)];
    _zhekouL.text = @"";
    _zhekouL.textColor = [UIColor whiteColor];
    _zhekouL.textAlignment = NSTextAlignmentLeft;
    _zhekouL.font = [UIFont systemFontOfSize:16];
    //_zhekouL.backgroundColor = [UIColor redColor];
    [self addSubview:_zhekouL];
    
    self.jifenL = [[UILabel alloc]initWithFrame:CGRectMake(w*.05, h*.9, w*.4, h*.1)];
    _jifenL.text = @"";
    _jifenL.textColor = [UIColor whiteColor];
    _jifenL.textAlignment = NSTextAlignmentLeft;
    _jifenL.font = [UIFont systemFontOfSize:12];
   // _jifenL.backgroundColor = [UIColor redColor];
    [self addSubview:_jifenL];

    
   
    self.imgsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _imgsBtn.frame = CGRectMake(w*.82, h*.83, w*.18, h*.15);
    _imgsBtn.backgroundColor =[UIColor colorWithRed:135/255. green:134/255. blue:135/255. alpha:.6];
    [_imgsBtn setTintColor:[UIColor whiteColor]];
   // _imgsBtn.hidden = YES;
   
    [self addSubview:_imgsBtn];

}
@end
