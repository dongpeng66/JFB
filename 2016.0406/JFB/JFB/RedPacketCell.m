//
//  RedPacketCell.m
//  红包
//
//  Created by 积分宝 on 15/12/11.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import "RedPacketCell.h"
//#define w self.frame.size.width
//#define h self.frame.size.height
@implementation RedPacketCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self addSubview];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      //  [self addSubview];
    }
    return self;
  }
-(void)addSubview{
    
    int w=self.frame.size.width;
    int h=self.frame.size.height;
   // NSLog(@"w==%d,h==%d",w,h);
    UIImage *image =[UIImage imageNamed:@"hBJ"];
    _beiJingView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w, h )];
   // _beiJingView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
       _beiJingView.image =image;
    [self.contentView addSubview:_beiJingView];
    
    UIImage *hongbao = [UIImage imageNamed:@"wuK"];
    _hongBaoView  = [[UIImageView alloc]initWithFrame: CGRectMake(w*.05, h*.13, w*.33, h*.7)];
    _hongBaoView.image = hongbao;
    _hongBaoView.contentMode = UIViewContentModeScaleAspectFit;
    //_hongBaoView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_hongBaoView];
    
    _shuXianL = [[UILabel alloc]initWithFrame:CGRectMake(w*.44, h*.13, .5, h*.7)];
    _shuXianL.backgroundColor = [UIColor grayColor];
    _shuXianL.alpha = .4;
    [self.contentView addSubview:_shuXianL];
    
    _hongBaoL = [[UILabel alloc]initWithFrame:CGRectMake(w*.51, h*.1, w*.5, h*.33)];
   // _hongBaoL.backgroundColor = [UIColor greenColor];
    _hongBaoL.text = @"砸金蛋获奖红包";
    _hongBaoL.textColor = [UIColor colorWithRed:44/255. green:44/255. blue:44/255. alpha:1];
    _hongBaoL.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:_hongBaoL];
    
    
    
    _keYongL = [[UILabel alloc]initWithFrame:CGRectMake(w*.51, h*.38, w*.5, h*.15)];
   // _keYongL.backgroundColor = [UIColor redColor];
    _keYongL.text = @"满5元可用";
    _keYongL.textColor = [UIColor colorWithRed:55/255. green:55/255. blue:55/255. alpha:1];
    _keYongL.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_keYongL];
    
    _xianHaoL = [[UILabel alloc]initWithFrame:CGRectMake(w*.51, h*.52, w*.5, h*.15)];
     // _xianHaoL.backgroundColor = [UIColor greenColor];
    _xianHaoL.text = @"限尾号5580的手机使用";
    _xianHaoL.textColor = [UIColor colorWithRed:55/255. green:55/255. blue:55/255. alpha:1];
    _xianHaoL.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_xianHaoL];
    
    
    _riQiL = [[UILabel alloc]initWithFrame:CGRectMake(w*.51, h*.67, w*.5, h*.15)];
    // _riQiL.backgroundColor = [UIColor redColor];
    _riQiL.text = @"截至日期:2015.12.12";
    _riQiL.textColor = [UIColor colorWithRed:55/255. green:55/255. blue:55/255. alpha:1];
    _riQiL.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_riQiL];
}
@end
