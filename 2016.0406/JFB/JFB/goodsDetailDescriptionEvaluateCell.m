//
//  goodsDetailDescriptionEvaluateCell.m
//  JFB
//
//  Created by IOS on 16/3/16.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "goodsDetailDescriptionEvaluateCell.h"
#import "DJQRateView.h"
@implementation goodsDetailDescriptionEvaluateCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.ealuateLabel=[[UILabel alloc]init];
        self.ealuateNumLabel=[[UILabel alloc]init];
        self.scoreLabel=[[UILabel alloc]init];
        self.rateView=[[DJQRateView alloc]init];
        self.myImageView=[[UIImageView alloc]init];
    }
    return self;
}


-(void)layoutSubviews{
    
    
    self.ealuateLabel.x=10;
    self.ealuateLabel.y=0;
    self.ealuateLabel.height=self.height/2;
    self.ealuateLabel.font=[UIFont systemFontOfSize:20];
    [self addSubview:self.ealuateLabel];
    
    self.ealuateNumLabel.x=CGRectGetMaxX(self.ealuateLabel.frame);
    self.ealuateNumLabel.y=0;
    self.ealuateNumLabel.width=SCREEN_WIDTH/2;
    self.ealuateNumLabel.height=self.height/2;
    self.ealuateNumLabel.font=[UIFont fontWithName:@"Gothic-Bold" size:28];
    [self addSubview:self.ealuateNumLabel];
    
    self.rateView.x=10;
    self.rateView.y=self.height/2;
    self.rateView.width=self.ealuateLabel.width;
    self.rateView.height=self.height/2;
    [self addSubview:self.rateView];
    
    self.scoreLabel.x=CGRectGetMaxX(self.rateView.frame);
    self.scoreLabel.y=self.height/2;
    self.scoreLabel.width=150;
    self.scoreLabel.height=self.height/2;
    [self addSubview:self.scoreLabel];
    
    self.myImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.myImageView];
    self.myImageView.x=SCREEN_WIDTH-10-15;
    self.myImageView.y=(self.height-15)/2;
    self.myImageView.width=15;
    self.myImageView.height=15;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
