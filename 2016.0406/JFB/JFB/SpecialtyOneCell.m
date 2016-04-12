//
//  SpecialtyOneCell.m
//  特产首页
//
//  Created by 积分宝 on 15/12/22.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import "SpecialtyOneCell.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define redC [UIColor colorWithRed:244/255. green:17/255. blue:0/255. alpha:1]
#define yrrC [UIColor colorWithRed:244/255. green:17/255. blue:0/255. alpha:1]
@implementation SpecialtyOneCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"huaSheng"];
        
        
       // [self addSubviews];
        self.bigIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WITH, image.size.height)];
        _bigIM.image = image;
        [self addSubview:_bigIM];
        
        NSLog(@"----%f",image.size.height);
        self.backgroundColor =[UIColor whiteColor];
        
    }
    return self;
}
-(void)setHeight:(float)height{
     UIImage *image = [UIImage imageNamed:@"huaSheng"];
    self.countL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, image.size.height, WITH*.3, height*.08)];
    _countL.text =@"极致优惠 争分夺秒";
    _countL.font = [UIFont systemFontOfSize:11];
    _countL.textColor = [UIColor redColor];
   // _countL.backgroundColor = [UIColor orangeColor];
    [self addSubview:_countL];
    
    self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.67, image.size.height, WITH*.3, height*.08)];
      _timeL.textColor = [UIColor redColor];
    _timeText = [[NSMutableAttributedString alloc]initWithString:@"倒计时 10:52:00"];

    [_timeText addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
       _timeL.attributedText = _timeText;
 
    _timeL.font = [UIFont systemFontOfSize:11];
  
    // _timeL.backgroundColor = [UIColor orangeColor];
    _timeL.textAlignment =NSTextAlignmentRight;
    
    [self addSubview:_timeL];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, image.size.height+_timeL.frame.size.height, WITH, 1)];
    lab.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
    [self addSubview:lab];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, image.size.height+_timeL.frame.size.height+1, WITH, height*.49)];
    _scrollView.backgroundColor = [UIColor whiteColor];

    [self addSubview:_scrollView];
    
    SpecialtyGoodsView *specialtyView = [[SpecialtyGoodsView alloc]initWithFrame:CGRectMake(WITH*.03, 10, WITH*.44, height*.5)];
    specialtyView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:specialtyView];
    
    SpecialtyGoodsView *specialtyView1 = [[SpecialtyGoodsView alloc]initWithFrame:CGRectMake(WITH*.53, 10, WITH*.44, height*.5)];
    specialtyView1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:specialtyView1];
    
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.5, _scrollView.frame.size.height*.08, 1, _scrollView.frame.size.height*.6)];
    lab1.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
    [_scrollView addSubview:lab1];
    
       

}
@end
