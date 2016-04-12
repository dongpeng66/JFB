//
//  VoucherViewCell.m
//  代金卷
//
//  Created by 积分宝 on 15/12/24.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import "VoucherViewCell.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define height  ([[UIScreen mainScreen] bounds].size.height*.19+6)
@implementation VoucherViewCell

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
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        [self addSubview:_nameL];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, height*.31, WITH, 1)];
        lab.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
        [self addSubview:lab];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, height*.05, WITH*.4, height*.25)];
        //_nameL.backgroundColor = [UIColor redColor];
        _nameL.textColor = [UIColor grayColor];
        _nameL.text = @"积分宝体验店";
        [self addSubview:_nameL];
        
        self.tradingParL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.67, height*.05, WITH*.3, height*.25)];
        //_tradingParL.backgroundColor = [UIColor grayColor];
        _tradingParL.text = @"交易成功";
        _tradingParL.textColor = [UIColor redColor];
        _tradingParL.font = [UIFont systemFontOfSize:13];
        _tradingParL.textAlignment = NSTextAlignmentRight;
        [self addSubview:_tradingParL];
        
        self.bigIM = [[UIImageView alloc]initWithFrame:CGRectMake(WITH*.03, height*.38, WITH *.23, height*.54)];
        //_bigIM.backgroundColor = [UIColor redColor];
        _bigIM.layer.masksToBounds = YES;
        _bigIM.layer.cornerRadius = 6.0;
        _bigIM.clipsToBounds = YES;
        _bigIM.image = [UIImage imageNamed:@"huaSheng"];
        _bigIM.contentMode =UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_bigIM];
        
        
        self.goodsNameL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.28, height*.38, WITH*.5, height*.18)];
        //  _goodsNameL.backgroundColor = [UIColor redColor];
        _goodsNameL.text = @"测试商品";
        _goodsNameL.textColor = [UIColor grayColor];
        _goodsNameL.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_goodsNameL];
        
        self.numberL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.28, height*.59, WITH*.5, height*.16)];
        //_amountL.backgroundColor = [UIColor redColor];
        _numberL.text = @"数量:2";
        _numberL.textColor = [UIColor grayColor];
        _numberL.font = [UIFont systemFontOfSize:12];
        [self addSubview:_numberL];
        
        self.priceL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.28, height*.77, WITH*.26, height*.17)];
        // _priceL.backgroundColor = [UIColor grayColor];
        _priceL.text = @"总价:¥20.0";
        _priceL.textColor = [UIColor grayColor];
        _priceL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_priceL];
        
        self.yanglaoL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.5, height*.77, WITH*.29, height*.17)];
        // _yanglaoL.backgroundColor = [UIColor redColor];
        _yanglaoL.text = @"赠送养老金:¥120.00";
        _yanglaoL.textColor = [UIColor grayColor];
        _yanglaoL.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_yanglaoL];
        
        
        self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _payBtn.frame = CGRectMake(WITH*.8, height*.7, WITH*.17, height*.22) ;
        
        // _buyBtn.backgroundColor = [UIColor grayColor];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _payBtn.layer.masksToBounds = YES;
        _payBtn.layer.cornerRadius = 5.0;
        _payBtn.clipsToBounds = YES;
        [_payBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        _payBtn.layer.borderColor  =[[UIColor redColor] CGColor]; //要设置的颜色
        
        
        _payBtn.layer.borderWidth = 1; //要设置的描边宽
        [self.contentView addSubview:_payBtn];
        
        self.beiJingL = [[UILabel alloc]initWithFrame:CGRectMake(0, height-6, WITH, 6)];
        _beiJingL.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
        
  
        [self addSubview:_beiJingL];
    }
    return self;
}

@end
