//
//  VoucherEitiyCell.m
//  JFB
//
//  Created by 积分宝 on 16/1/6.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "VoucherEitiyCell.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define height  ([[UIScreen mainScreen] bounds].size.height*.3+6)
@implementation VoucherEitiyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

 
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        [self addSubview:_nameL];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, height*.2, WITH, 1)];
        lab.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
        [self addSubview:lab];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, height*.03, WITH*.4, height*.13)];
        // _nameL.backgroundColor = [UIColor redColor];
        _nameL.textColor = [UIColor grayColor];
        _nameL.text = @"积分宝体验店";
        [self addSubview:_nameL];
        
        self.tradingParL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.67, height*.03, WITH*.3, height*.13)];
        // _tradingParL.backgroundColor = [UIColor grayColor];
        _tradingParL.text = @"交易成功";
        _tradingParL.textColor = [UIColor redColor];
        _tradingParL.font = [UIFont systemFontOfSize:13];
        _tradingParL.textAlignment = NSTextAlignmentRight;
        [self addSubview:_tradingParL];
        
        self.bigIM = [[UIImageView alloc]initWithFrame:CGRectMake(WITH*.03, height*.25, WITH *.23, height*.43)];
        //_bigIM.backgroundColor = [UIColor redColor];
        _bigIM.layer.masksToBounds = YES;
        _bigIM.layer.cornerRadius = 6.0;
        _bigIM.clipsToBounds = YES;
        _bigIM.image = [UIImage imageNamed:@"huaSheng"];
        _bigIM.contentMode =UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_bigIM];
        
        
        self.goodsNameL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.28, height*.25, WITH*.5, height*.15)];
        // _goodsNameL.backgroundColor = [UIColor redColor];
        _goodsNameL.text = @"测试商品";
        _goodsNameL.textColor = [UIColor grayColor];
        _goodsNameL.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_goodsNameL];
        
        self.numberL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.28, height*.41, WITH*.5, height*.13)];
        // _numberL.backgroundColor = [UIColor redColor];
        _numberL.text = @"数量:2";
        _numberL.textColor = [UIColor grayColor];
        _numberL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_numberL];
        
        self.priceL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.28, height*.54, WITH*.26, height*.14)];
        //_priceL.backgroundColor = [UIColor grayColor];
        _priceL.text = @"总价:¥20.0";
        _priceL.textColor = [UIColor grayColor];
        _priceL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_priceL];
        
        self.yanglaoL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.5, height*.54, WITH*.29, height*.14)];
        // _yanglaoL.backgroundColor = [UIColor redColor];
        _yanglaoL.text = @"赠送养老金:¥120.00";
        _yanglaoL.textColor = [UIColor grayColor];
        _yanglaoL.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_yanglaoL];
        
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, height*.73, WITH, 1)];
        lab1.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
        [self addSubview:lab1];
        
        self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _payBtn.frame = CGRectMake(WITH*.8, height*.77, WITH*.17, height*.17) ;
        
        //_payBtn.backgroundColor = [UIColor grayColor];
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
        
        
        self.logisticsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _logisticsBtn.frame = CGRectMake(WITH*.55, height*.77, WITH*.2, height*.17) ;
        
        //_payBtn.backgroundColor = [UIColor grayColor];
        _logisticsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _logisticsBtn.layer.masksToBounds = YES;
        _logisticsBtn.layer.cornerRadius = 5.0;
        _logisticsBtn.clipsToBounds = YES;
        [_logisticsBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
        [_logisticsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_logisticsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _logisticsBtn.layer.borderColor  =[[UIColor redColor] CGColor]; //要设置的颜色
        _logisticsBtn.layer.borderWidth = 1; //要设置的描边宽
        [self.contentView addSubview:_logisticsBtn];
        
    
        self.beiJingL = [[UILabel alloc]initWithFrame:CGRectMake(0, height-6, WITH, 6)];
        _beiJingL.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
        
        [self addSubview:_beiJingL];
        
    }
    return self;
}

@end
