//
//  JFBSeckillView.m
//  JFB
//
//  Created by IOS on 16/3/11.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "JFBSeckillView.h"

@implementation JFBSeckillView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //添加图片
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.x=0;
        imageView.y=0;
        imageView.width=self.width;
        imageView.height=self.width;
        //        imageView.backgroundColor=[UIColor greenColor];
        JFBLog(@"%F",self.width);
        [self addSubview:imageView];
        self.imageView=imageView;
        imageView.userInteractionEnabled=YES;
        UIButton *btn=[[UIButton alloc]init];
        btn.frame=imageView.bounds;
        [imageView addSubview:btn];
        self.btn=btn;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat labelH=(self.height-imageView.height-7)/2;
        //添加秒杀价格
        UILabel *seckillLabel=[[UILabel alloc]init];
        seckillLabel.x=0;
        seckillLabel.y=CGRectGetMaxY(imageView.frame);
        seckillLabel.width=self.width;
        seckillLabel.height=labelH;
        seckillLabel.textColor=[UIColor redColor];
        seckillLabel.textAlignment=NSTextAlignmentCenter;
        self.seckillPriceLabel=seckillLabel;
        
        [self addSubview:seckillLabel];
        seckillLabel.font=[UIFont boldSystemFontOfSize:16.f];
        //真实价格
        UILabel *realLabel=[[UILabel alloc]init];
        realLabel.x=0;
        realLabel.y=CGRectGetMaxY(seckillLabel.frame)+2;
        realLabel.width=self.width;
        realLabel.height=labelH;
        realLabel.textAlignment=NSTextAlignmentCenter;
        
        self.realPriceLabel=realLabel;
        [self addSubview:realLabel];
        
    }
    return self;
    
}
-(void)btnClick:(UIButton *)sender{
    JFBLog(@"点击了秒杀产品的图片");
    if ([self.delegate respondsToSelector:@selector(seckillViewDidTapImagView:andButton:)]) {
        [self.delegate seckillViewDidTapImagView:self andButton:sender];
    }
}
@end
