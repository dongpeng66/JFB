//
//  HomeShopListCell.h
//  JFB
//
//  Created by LYD on 15/8/18.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJQRateView.h"

@interface HomeShopListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopIM;
@property (weak, nonatomic) IBOutlet UILabel *shopNameL;
@property (weak, nonatomic) IBOutlet UILabel *shopAddressL;
@property (weak, nonatomic) IBOutlet DJQRateView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *scoreL;
@property (weak, nonatomic) IBOutlet UILabel *integralRateL;
@property (weak, nonatomic) IBOutlet UILabel *distanceL;
@property (weak, nonatomic) IBOutlet UILabel *discountL;

@end
