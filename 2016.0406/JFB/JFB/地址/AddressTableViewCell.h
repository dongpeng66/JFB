//
//  AddressTableViewCell.h
//  地址
//
//  Created by 积分宝 on 16/1/15.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *defaultIM;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *telL;
@property (nonatomic,strong) UILabel *addressL;
-(void)returnText:(NSString *)text;
@end
