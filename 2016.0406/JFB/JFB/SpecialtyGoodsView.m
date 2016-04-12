//
//  SpecialtyGoodsView.m
//  特产首页
//
//  Created by 想牵着你的手 on 15-12-22.
//  Copyright (c) 2015年 积分宝. All rights reserved.
//

#import "SpecialtyGoodsView.h"
#define redC [UIColor colorWithRed:244/255. green:17/255. blue:0/255. alpha:1]
@implementation SpecialtyGoodsView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image1 = [UIImage imageNamed:@"daBing"];
        self.goodsIM = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, self.frame.size.width,self.frame.size.height*.62)];
        // _goodsIM.backgroundColor = [UIColor greenColor];
        _goodsIM.contentMode = UIViewContentModeScaleAspectFit;
        _goodsIM.image = image1;
        [self addSubview:_goodsIM];
        
        self.goodsNameL = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height*.64, self.frame.size.width*.6, self.frame.size.height*.15)];
        // _goodsNameL.backgroundColor = [UIColor orangeColor];
        _goodsNameL.text =@"新疆薄饼";
        _goodsNameL.font = [UIFont systemFontOfSize:14];
        [self addSubview:_goodsNameL];

        self.priceL =  [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height*.77, self.frame.size.width*.6, self.frame.size.height*.12)];
        _priceL.textColor = [UIColor redColor];
        _priceL.font = [UIFont systemFontOfSize:15];
       // _priceL.backgroundColor = [UIColor greenColor];
        _pricelText = [[NSMutableAttributedString alloc]initWithString:@"¥9.9 ¥20"];
        [_pricelText addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(5, 3)];
        
        [_pricelText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 1)];
        [_pricelText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(5, 3)];
        _priceL.attributedText=_pricelText;
        [self addSubview:_priceL];

        self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.frame = CGRectMake(self.frame.size.width *.61, self.frame.size.height *.72, self.frame.size.width *.4, self.frame.size.height *.15);
        [_buyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _buyBtn.backgroundColor =redC;
        _buyBtn.layer.cornerRadius=6;
        [self addSubview:_buyBtn];
        
    }
    return self;
}
@end
