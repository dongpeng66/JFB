//
//  HeadTSFViewCell.h
//  HeadViewCell
//
//  Created by 积分宝 on 16/2/23.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadTSFViewCell : UITableViewCell
@property (nullable,nonatomic,strong)UIImageView *bigIM;//背景
//@property (nullable,nonatomic,strong)UIImageView *imageMB;//蒙板
@property (nullable,nonatomic,strong)UIButton *imgsBtn;//几张图片
@property (nullable,nonatomic,strong)UILabel *nameL;//店名
@property (nullable,nonatomic,strong)UILabel *jifenL;//积分率
@property (nullable,nonatomic,strong)UILabel *zhekouL;//折扣
@end