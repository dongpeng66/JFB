//
//  SpecialtyOneCell.h
//  特产首页
//
//  Created by 积分宝 on 15/12/22.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialtyGoodsView.h"
@interface SpecialtyOneCell : UITableViewCell
@property (nonatomic,strong) UIImageView *bigIM;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UILabel *countL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *priceL;
@property (nonatomic,strong) NSMutableAttributedString *timeText;
@property (nonatomic,strong) NSMutableAttributedString *pricelText;
//@property (nonatomic,strong) SpecialtyGoodsView *specialtyView;
-(void)setHeight:(float)height;
@end
