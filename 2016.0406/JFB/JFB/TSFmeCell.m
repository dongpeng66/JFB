//
//  TSFmeCell.m
//  JFB
//
//  Created by 积分宝 on 15/12/3.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import "TSFmeCell.h"

@implementation TSFmeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        int w=self.frame.size.width;
        int h=self.frame.size.height;
        _leftimageView =[[UIImageView alloc]initWithFrame:CGRectMake(w*.07, h*.1, w*.12, w*.12)];
       // _leftimageView.backgroundColor=[UIColor redColor];
        _leftimageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_leftimageView];
        
        _lab = [[UILabel alloc]initWithFrame:CGRectMake(w*.23, h*.1, w*.6, w*.12)];
        //_lab.backgroundColor=[UIColor redColor];
        _lab.font = [UIFont systemFontOfSize:17];
        _lab.alpha=.7;
        
        _lab.textAlignment =NSTextAlignmentLeft;
        [self addSubview:_lab];

    }
    return self;
}

@end
