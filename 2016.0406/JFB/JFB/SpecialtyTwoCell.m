//
//  SpecialtyTwoCell.m
//  特产首页
//
//  Created by 积分宝 on 15/12/22.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import "SpecialtyTwoCell.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define redC [UIColor colorWithRed:244/255. green:17/255. blue:0/255. alpha:1]
#define yrrC [UIColor colorWithRed:244/255. green:17/255. blue:0/255. alpha:1]

@implementation SpecialtyTwoCell

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
        
        
        self.backgroundColor =[UIColor whiteColor];
        
        
        self.goodsNameL = [[UILabel alloc]init];
        [self addSubview:_goodsNameL];
        
        self.countL = [[UILabel alloc] init];
        [self addSubview:_countL];
        
        self.leftIM = [[UIImageView alloc]init];
        [self addSubview:_leftIM];
        
        self.rightL = [[UILabel alloc]init];
        [self addSubview:_rightL];
        
        self.priceL = [[UILabel alloc] init];
        [self addSubview:_priceL];
        
        self.salesL = [[UILabel alloc] init];
        [self addSubview:_salesL];
        
        self.lab= [[UILabel alloc]init ];
        // lab.backgroundColor =[UIColor colorWithRed:239/255. green:239/255. blue:244/255. alpha:1];
        _lab .backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
        [self addSubview:_lab];
    }
    return self;
}
-(void)setHeight:(float)height{
    _lab.frame =  CGRectMake(0, height-1, WITH, 1);
    
    //图片
    _leftIM.frame = CGRectMake(WITH*.03, height*.05, WITH*.34, height*.9);
    //_leftIM.backgroundColor = [UIColor redColor];
    _leftIM.layer.cornerRadius=6;
    _leftIM.clipsToBounds = YES;
    _leftIM.contentMode = UIViewContentModeScaleAspectFit;
    
    
    
    //商家名字
    _goodsNameL.frame =  CGRectMake(WITH*.41, height*.06, WITH*.5, height*.3);
    // _goodsNameL.backgroundColor = [UIColor orangeColor];
    _goodsNameL.text =@"甜甜圈";
    _goodsNameL.font = [UIFont systemFontOfSize:17];
   
    
    //内容
    _countL.frame = CGRectMake(WITH*.41, height*.29, WITH*.5, height*.2);
    //  _countL.backgroundColor = [UIColor redColor];
    _countL.textColor = [UIColor grayColor];
    _countL.text = @"杭州 包邮";
    _countL.font = [UIFont systemFontOfSize:13];
    
    
    
    
    //养老金
    
    _rightL.frame =  CGRectMake(WITH*.41, height*.51, WITH*.3, height*.17);
    _rightL.layer.cornerRadius = 6;
    _rightL.clipsToBounds = YES;
    _rightL.backgroundColor = [UIColor redColor];
    _rightL.textColor = [UIColor whiteColor];
    _rightL.font = [UIFont systemFontOfSize:12];
    
    
    //价格
    _priceL.frame = CGRectMake(WITH*.41, height*.7, WITH*.3, height*.2);
    _priceL.textColor = [UIColor redColor];
    _priceL.font = [UIFont systemFontOfSize:15];
    // _priceL.backgroundColor = [UIColor orangeColor];
    _priceL.text = @"¥38";
    
    
    
    //销售量
   _salesL.frame = CGRectMake(WITH*.77, height*.7, WITH*.2, height*.2);
    //  _salesL.backgroundColor = [UIColor redColor];
    _salesL.font = [UIFont systemFontOfSize:12];
    _salesL.text = @"已售：300";
    _salesL.textColor = [UIColor grayColor];
    _salesL.textAlignment = NSTextAlignmentRight;
    
    
    
    
    
    
    
   
    //NSLog(@"%f",height);
}
-(void)setrightText:(NSString *)text :(float)height{
    
    float yanglaojing = [text floatValue];
    text = [NSString stringWithFormat:@"赠送养老金%.2f",yanglaojing];
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    _rightL.font = fnt;
    // 根据字体得到NSString的尺寸
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    _rightL.text =text;
    _rightL.frame =  CGRectMake(WITH*.41, height*.51, size.width, height*.17);
}
@end
