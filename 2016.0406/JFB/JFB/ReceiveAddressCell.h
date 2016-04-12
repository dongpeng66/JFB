//
//  ReceiveAddressCell.h
//  JFB
//
//  Created by LYD on 15/8/21.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiveAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *provL;
@property (weak, nonatomic) IBOutlet UILabel *detailAddrL;
@property (weak, nonatomic) IBOutlet UILabel *postcodeL;
@property (weak, nonatomic) IBOutlet UILabel *defaultL;

@property (weak, nonatomic) IBOutlet UILabel *lqAddressMSG;//地址详情




@end
