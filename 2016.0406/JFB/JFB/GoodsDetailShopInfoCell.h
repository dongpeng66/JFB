//
//  GoodsDetailShopInfoCell.h
//  JFB
//
//  Created by JY on 15/9/4.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailShopInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopsNameL;
@property (weak, nonatomic) IBOutlet UILabel *shopAddressL;
@property (weak, nonatomic) IBOutlet UILabel *distanceL;
@property (weak, nonatomic) IBOutlet UIButton *mapAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@end
