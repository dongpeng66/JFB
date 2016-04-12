//
//  MyOrderTableViewCell.m
//  JFB
//
//  Created by JY on 15/8/24.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.payBtn.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
