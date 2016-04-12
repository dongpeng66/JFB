//
//  GoodsDetailHeadCell.m
//  JFB
//
//  Created by JY on 15/9/4.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "GoodsDetailHeadCell.h"

@implementation GoodsDetailHeadCell

- (void)awakeFromNib {
    // Initialization code
     self.costPriceStrikeL.strikeThroughEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
