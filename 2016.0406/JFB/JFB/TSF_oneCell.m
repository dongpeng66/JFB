//
//  TSF_oneCell.m
//  nimabi
//
//  Created by 积分宝 on 15/12/22.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import "TSF_oneCell.h"
#define WITH [UIScreen mainScreen].bounds.size.width
#define HEIGHT 375
@interface TSF_oneCell ()
{
    UIImage*image;
}

@end
@implementation TSF_oneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self addSubviews];
        //self.backgroundColor =[UIColor orangeColor];
        
    }
    return self;
}
-(void)addSubviews{
    
    
    //    UIImage *bigImage= [UIImage imageNamed:@"6"];
    self.bigIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WITH, WITH)];
    //    _bigIM.image = bigImage;
    [self addSubview:_bigIM];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.bigIM.image.size.height, WITH, HEIGHT*.15)];
    // view.backgroundColor = [UIColor greenColor];
    [self addSubview:view];
}
@end
