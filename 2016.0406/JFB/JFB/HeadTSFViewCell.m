//
//  HeadTSFViewCell.m
//  HeadViewCell
//
//  Created by 积分宝 on 16/2/23.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "HeadTSFViewCell.h"
#define w [UIScreen mainScreen ].bounds.size.width
#define h 210
@implementation HeadTSFViewCell

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
        
      [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    
    
    
    NSLog(@"------%f",self.frame.size.width);
    
    self.bigIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    
    // _bigIM.backgroundColor = [UIColor orangeColor];
    _bigIM.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
  //  _bigIM.image = [UIImage imageNamed:@"1"];
    
    NSLog(@"------%f",self.bigIM.frame.size.width);
    [self addSubview:_bigIM];
    
  UIImageView *_imageMB = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    // _imageMB.backgroundColor = [UIColor greenColor];
    _imageMB.image = [UIImage imageNamed:@"mengban"];
    _imageMB.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
    [self addSubview:_imageMB];
    
    
    self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(w*.05, h*.8, w*.44, h*.13)];
    _nameL.text = @"";
    _nameL.textColor = [UIColor whiteColor];
    _nameL.textAlignment = NSTextAlignmentLeft;
    _nameL.font = [UIFont systemFontOfSize:16];
 //  _nameL.backgroundColor = [UIColor redColor];
    [self addSubview:_nameL];
    
    self.zhekouL = [[UILabel alloc]initWithFrame:CGRectMake(w*.55, h*.8, w*.2, h*.13)];
    _zhekouL.text = @"";
    _zhekouL.textColor = [UIColor whiteColor];
    _zhekouL.textAlignment = NSTextAlignmentLeft;
    _zhekouL.font = [UIFont systemFontOfSize:16];
  // _zhekouL.backgroundColor = [UIColor redColor];
    [self addSubview:_zhekouL];
    
    self.jifenL = [[UILabel alloc]initWithFrame:CGRectMake(w*.05, h*.9, w*.4, h*.1)];
    _jifenL.text = @"";
    _jifenL.textColor = [UIColor whiteColor];
    _jifenL.textAlignment = NSTextAlignmentLeft;
    _jifenL.font = [UIFont systemFontOfSize:12];
   //  _jifenL.backgroundColor = [UIColor redColor];
    [self addSubview:_jifenL];
    
    
    
    self.imgsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _imgsBtn.frame = CGRectMake(w*.82, h*.83, w*.18, h*.15);
    _imgsBtn.backgroundColor =[UIColor colorWithRed:135/255. green:134/255. blue:135/255. alpha:.6];
    [_imgsBtn setTintColor:[UIColor whiteColor]];
    // _imgsBtn.hidden = YES;
     [_imgsBtn setTitle:@"0张" forState:UIControlStateNormal];
    [self addSubview:_imgsBtn];
    
}

@end
