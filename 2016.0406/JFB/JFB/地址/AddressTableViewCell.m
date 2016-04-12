//
//  AddressTableViewCell.m
//  地址
//
//  Created by 积分宝 on 16/1/15.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "AddressTableViewCell.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  ([[UIScreen mainScreen] bounds].size.height*.15)
@implementation AddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
       
        [self addSubviews];

    }
    return self;
}

-(void)addSubviews{
    
    
    self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.2, WITH*.4, HEIGHT*.25)];
   // _nameL.backgroundColor = [UIColor redColor];
   
    _nameL.font = [UIFont systemFontOfSize:15];
    _nameL.textColor = [UIColor colorWithRed:77/255. green:77/255. blue:77/255. alpha:1];
    [self addSubview:_nameL];
    
    self.telL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.46, HEIGHT*.2, WITH*.4, HEIGHT*.25)];
   // _telL.backgroundColor = [UIColor orangeColor];
    _telL.textColor = [UIColor colorWithRed:77/255. green:77/255. blue:77/255. alpha:1];
    _telL.font = [UIFont systemFontOfSize:15];
    [self addSubview:_telL];
    self.defaultIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WITH*.08, HEIGHT*.299)];
//    _defaultIM.image = [UIImage imageNamed:@"default_IM"];
//       _defaultIM.hidden = YES;
    [self.contentView addSubview:_defaultIM];

   
}
-(void)returnText:(NSString *)text{
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:17];
    
    
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    
    
    
    self.addressL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.45, WITH*.94, HEIGHT*.4)];
    _addressL.numberOfLines = 0;
    _addressL.font = font;
    _addressL.text = text;
    // _addressL.backgroundColor = [UIColor redColor];
    _addressL.frame = CGRectMake(WITH*.03, HEIGHT*.5, WITH*.94, labelsize.height );
    _addressL.textColor = [UIColor colorWithRed:44/255. green:44/255. blue:44/255. alpha:1];
    
    [self addSubview:_addressL];
    
  
}
@end
