
//
//  GoodsDetailShopCell.m
//  JFB
//
//  Created by IOS on 16/3/16.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "GoodsDetailShopCell.h"

@implementation GoodsDetailShopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        //self.backgroundColor =[UIColor orangeColor];
        self.iconImageView=[[UIImageView alloc]init];
        self.shopAddressLabel=[[UILabel alloc]init];
        self.shopNameLabel=[[UILabel alloc]init];
        self.myImageView=[[UIImageView alloc]init];
        //        self.telToShopBtn=[[UIButton alloc]init];
        //        [self.telToShopBtn addSubview:self];
    }
    return self;
}
-(void)layoutSubviews{
    self.iconImageView.frame=CGRectMake(10, 10, 90, 50);
    [self addSubview:self.iconImageView];
    
    self.shopNameLabel.x=CGRectGetMaxX(self.iconImageView.frame)+5;
    self.shopNameLabel.y=10;
    self.shopNameLabel.width=SCREEN_WIDTH-self.iconImageView.width-15;
    self.shopNameLabel.height=20;
    [self addSubview:self.shopNameLabel];
    self.shopNameLabel.font=[UIFont systemFontOfSize:14];
    self.shopNameLabel.textColor=[UIColor blackColor];
    
    self.shopAddressLabel.x=self.shopNameLabel.x;
    self.shopAddressLabel.y=CGRectGetMaxY(self.shopNameLabel.frame)+8;
    self.shopAddressLabel.width=self.shopNameLabel.width;
    self.shopAddressLabel.height=20;
    self.shopAddressLabel.font=[UIFont systemFontOfSize:11];
    [self addSubview:self.shopAddressLabel];
    
    //    CGFloat btnMarginX=(SCREEN_WIDTH-25-100*2)/2;
    //    self.telToShopBtn.x=btnMarginX;
    //    self.telToShopBtn.y=CGRectGetMaxY(self.shopAddressLabel.frame)+20;
    //    self.telToShopBtn.width=100;
    //    self.telToShopBtn.height=30;
    ////    self.telToShopBtn=[[UIButton alloc]initWithFrame:CGRectMake(btnMarginX, CGRectGetMaxY(self.shopAddressLabel.frame)+20, 100, 30)];
    //    [self addSubview:self.telToShopBtn];
    //    self.telToShopBtn.layer.borderWidth=1;
    //    self.telToShopBtn.layer.borderColor=[UIColor redColor].CGColor;
    //    self.telToShopBtn.backgroundColor=[UIColor whiteColor];
    //    [self.telToShopBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
    //    [self.telToShopBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //    self.telToShopBtn.layer.masksToBounds=YES;
    //    self.telToShopBtn.layer.cornerRadius=5;
    //    [self.telToShopBtn addTarget:self action:@selector(telToShopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    self.goInShopBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.telToShopBtn.frame)+25, self.telToShopBtn.y, self.telToShopBtn.width, self.telToShopBtn.height)];
    //    [self addSubview:self.goInShopBtn];
    //    self.goInShopBtn.layer.borderWidth=1;
    //    self.goInShopBtn.layer.borderColor=[UIColor redColor].CGColor;
    //    self.goInShopBtn.backgroundColor=[UIColor whiteColor];
    //    [self.goInShopBtn setTitle:@"进入商家" forState:UIControlStateNormal];
    //    [self.goInShopBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //    self.goInShopBtn.layer.masksToBounds=YES;
    //    self.goInShopBtn.layer.cornerRadius=5;
    //    [self.telToShopBtn addTarget:self action:@selector(goInShopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.goInShopBtn.userInteractionEnabled=YES;
    
    self.myImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.myImageView];
    self.myImageView.x=SCREEN_WIDTH-10-15;
    self.myImageView.y=(self.height/2-15)/2-4;
    self.myImageView.width=15;
    self.myImageView.height=15;
}
//-(void)telToShopBtnClick:(UIButton *)sender{
//    if ([self respondsToSelector:@selector(GoodsDetailShopCellTelToShopBtnDidClick:)]) {
//        [self.delegate GoodsDetailShopCellTelToShopBtnDidClick:self];
//    }
//}
//-(void)goInShopBtnClick:(UIButton *)sender{
//    if ([self respondsToSelector:@selector(GoodsDetailShopCellGoInShopBtnDidClick:)]) {
//        [self.delegate GoodsDetailShopCellTelToShopBtnDidClick:self];
//    }
//}
@end
