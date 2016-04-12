//
//  SumOneCell.m
//  原来如此
//
//  Created by 积分宝 on 16/1/21.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "SumOneCell.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHt 117
@implementation SumOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,34, WITH, 1)];
        lab.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
        [self addSubview:lab];
        
        
        UIImage *image = [UIImage imageNamed:@"hengtiao"];
        UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WITH, image.size.height)];
        imageview1.image=image;
        [self addSubview:imageview1];
        
        UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(12, HEIGHt*.14,WITH*.3, HEIGHt*.12)];
       // leftL.backgroundColor = [UIColor grayColor];
        leftL.textColor=[UIColor colorWithRed:55/255. green:55/255. blue:55/255. alpha:1];
        leftL.text = @"收货信息";
        leftL.font = [UIFont systemFontOfSize:11];
       
        [self addSubview:leftL];
        
        
        
        
        
        
        
        //名字
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(14, HEIGHt*.4, WITH*.2, HEIGHt*.2)];
        
       // _nameL.backgroundColor = [UIColor redColor];
        _nameL.textAlignment = NSTextAlignmentLeft;
        _nameL.font = [UIFont systemFontOfSize:13];
        _nameL.textColor = [UIColor colorWithRed:77/255. green:77/255. blue:77/255. alpha:1];
        [self.contentView addSubview:_nameL];
        
        //电话号码
        self.numberL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.3, HEIGHt*.4, WITH*.3, HEIGHt*.2)];
        
       // _numberL.backgroundColor = [UIColor yellowColor];
        _numberL.textAlignment = NSTextAlignmentLeft;
        _numberL.font = [UIFont systemFontOfSize:13];
        _numberL.textColor = [UIColor colorWithRed:77/255. green:77/255. blue:77/255. alpha:1];
        [self.contentView addSubview:_numberL];
        
        //收获地址
        self.dizhi = [[UILabel alloc]initWithFrame:CGRectMake(14,HEIGHt*.55, WITH*.8, HEIGHt*.4)];
        //_dizhi.backgroundColor = [UIColor greenColor];
        
        _dizhi.textAlignment = NSTextAlignmentLeft;
        _dizhi.font = [UIFont systemFontOfSize:15];
        _dizhi.textColor = [UIColor colorWithRed:44/255. green:44/255. blue:44/255. alpha:1];
        [self.contentView addSubview:_dizhi];
        
        
        self.addDiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addDiBtn.backgroundColor = [UIColor whiteColor];
        _addDiBtn.frame = CGRectMake(0, 34, WITH, 83);
        [_addDiBtn setImage:[UIImage imageNamed:@"TSFdiZhiJia"] forState:UIControlStateNormal];
        _addDiBtn.hidden = YES;
      //  _addDiBtn.backgroundColor = [UIColor redColor];
//        [_addDiBtn addTarget:self action:@selector(goToReceiveAddressViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addDiBtn];
    }
    return self;
}


@end
