//
//  goodsDetailDescriptionSatateCell.m
//  JFB
//
//  Created by IOS on 16/3/16.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "goodsDetailDescriptionSatateCell.h"

@implementation goodsDetailDescriptionSatateCell

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
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 1, SCREEN_WIDTH-20, 1)];
        line.backgroundColor=RGBCOLOR(183, 183, 183);
        [self addSubview:line];
        self.oldAgePensionLabel=[[UILabel alloc]init];
        
    }
    return self;
}
-(void)layoutSubviews{
    //当前价格
    self.currentPriceLabel=[[UILabel alloc]init];
    
    self.realPriceLabel=[[UILabel alloc]init];
    self.expressLabel=[[UILabel alloc]init];
    self.soldNumLabel=[[UILabel alloc]init];
    //    self.areaNameLabel=[[UILabel alloc]init];
    self.currentPriceLabel.x=10;
    self.currentPriceLabel.y=0;
    self.currentPriceLabel.width=60;
    self.currentPriceLabel.height=self.height/2;
    self.currentPriceLabel.textColor=[UIColor redColor];
    self.currentPriceLabel.font=[UIFont systemFontOfSize:25];
    [self addSubview:self.currentPriceLabel];
    ///真实价格
    self.realPriceLabel.x=CGRectGetMaxX(self.currentPriceLabel.frame)+10;
    self.realPriceLabel.y=4;
    self.realPriceLabel.width=60;
    self.realPriceLabel.height=self.height/2-4;
    self.realPriceLabel.textColor=RGBCOLOR(161, 161, 161);
    self.realPriceLabel.font=[UIFont systemFontOfSize:18];
    [self addSubview:self.realPriceLabel];
    
    //养老金
    self.oldAgePensionLabel.x=SCREEN_WIDTH-self.oldAgePensionLabel.width-10;
    self.oldAgePensionLabel.height=20;
    self.oldAgePensionLabel.y=CGRectGetMaxY(self.realPriceLabel.frame)-self.oldAgePensionLabel.height-12;
    self.oldAgePensionLabel.textColor=[UIColor whiteColor];
    self.oldAgePensionLabel.backgroundColor=[UIColor redColor];
    self.oldAgePensionLabel.font=[UIFont systemFontOfSize:12];
    [self addSubview:self.oldAgePensionLabel];
    self.oldAgePensionLabel.layer.masksToBounds=YES;
    self.oldAgePensionLabel.layer.cornerRadius=4;
    self.oldAgePensionLabel.textAlignment=NSTextAlignmentRight;
    
    //快递
    self.expressLabel.width=SCREEN_WIDTH/2-10;
    self.expressLabel.x=10;
    self.expressLabel.y=self.height/2;
    self.expressLabel.height=self.height/2;
    self.expressLabel.textColor=[UIColor grayColor];
    self.expressLabel.font=[UIFont systemFontOfSize:12];
    [self addSubview:self.expressLabel];
    self.expressLabel.textAlignment=NSTextAlignmentLeft;
    //已售
    self.soldNumLabel.width=SCREEN_WIDTH/2-10;
    self.soldNumLabel.x=SCREEN_WIDTH-10-self.soldNumLabel.width;
    self.soldNumLabel.y=self.height/2;
    self.soldNumLabel.height=self.height/2;
    self.soldNumLabel.textColor=[UIColor grayColor];
    self.soldNumLabel.font=[UIFont systemFontOfSize:12];
    [self addSubview:self.soldNumLabel];
    self.soldNumLabel.textAlignment=NSTextAlignmentRight;
    //地区
    //    self.areaNameLabel.width=SCREEN_WIDTH/3-10;
    //    self.areaNameLabel.x=SCREEN_WIDTH/3*2;
    //    self.areaNameLabel.y=self.height/2;
    //    self.areaNameLabel.height=self.height/2;
    //    self.areaNameLabel.textColor=[UIColor grayColor];
    //    self.areaNameLabel.font=[UIFont systemFontOfSize:10];
    //    [self addSubview:self.areaNameLabel];
    //    self.areaNameLabel.textAlignment=NSTextAlignmentRight;
}
@end
