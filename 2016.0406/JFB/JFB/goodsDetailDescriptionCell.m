//
//  goodsDetailDescriptionCell.m
//  JFB
//
//  Created by IOS on 16/3/16.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "goodsDetailDescriptionCell.h"

@implementation goodsDetailDescriptionCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //self.backgroundColor =[UIColor orangeColor];
        self.myImageView=[[UIImageView alloc]init];
        
    }
    return self;
}
-(void)addSubviews{
    
}
-(void)layoutSubviews{
    self.goodsNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.width-10, self.height/2)];
    [self addSubview:self.goodsNameLabel];
    self.goodsDescriptionLabel.adjustsFontSizeToFitWidth=YES;
    //    self.goodsNameLabel.font=[UIFont fontWithName:@"Gothic-Bold" size:36];
    self.goodsNameLabel.textColor=[UIColor blackColor];
    
    self.goodsDescriptionLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, self.height/2-6, self.width-40, self.height/2)];
    [self addSubview:self.goodsDescriptionLabel];
    self.goodsDescriptionLabel.numberOfLines=0;
    self.goodsDescriptionLabel.adjustsFontSizeToFitWidth=YES;
    self.goodsDescriptionLabel.font=[UIFont systemFontOfSize:15];
    //    self.goodsDescriptionLabel.font=[UIFont fontWithName:@"Gothic-Bold" size:28];
    self.goodsDescriptionLabel.textColor=[UIColor blackColor];
    
    self.myImageView.x=self.width-10-15;
    self.myImageView.y=(self.height-15)/2;
    self.myImageView.width=15;
    self.myImageView.height=15;
    [self addSubview:self.myImageView];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
