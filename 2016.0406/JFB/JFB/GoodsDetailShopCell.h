//
//  GoodsDetailShopCell.h
//  JFB
//
//  Created by IOS on 16/3/16.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class GoodsDetailShopCell;
//
//@protocol GoodsDetailShopCellDelegate <NSObject>
//@optional
//- (void)GoodsDetailShopCellTelToShopBtnDidClick:(GoodsDetailShopCell *)cell;
//- (void)GoodsDetailShopCellGoInShopBtnDidClick:(GoodsDetailShopCell *)cell;
//
//@end
@interface GoodsDetailShopCell : UITableViewCell
//iocn
@property (nonatomic,strong) UIImageView *iconImageView;
//商家名称
@property (nonatomic,strong) UILabel *shopNameLabel;
//商家地址
@property (nonatomic,strong) UILabel *shopAddressLabel;
////联系卖家按钮
//@property (nonatomic,strong) UIButton *telToShopBtn;
////进去商家按钮
//@property (nonatomic,strong) UIButton *goInShopBtn;
//箭头
@property (nonatomic,strong) UIImageView *myImageView;
//@property (nonatomic,weak) id<GoodsDetailShopCellDelegate> delegate;
@end
