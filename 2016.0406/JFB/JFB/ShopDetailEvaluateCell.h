//
//  ShopDetailEvaluateCell.h
//  JFB
//
//  Created by JY on 15/9/3.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJQRateView.h"

@interface ShopDetailEvaluateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *memberNameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet DJQRateView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *scoreL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@end
