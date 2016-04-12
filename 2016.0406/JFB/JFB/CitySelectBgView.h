//
//  CitySelectBgView.h
//  UISCorrllVIew
//
//  Created by 积分宝 on 16/1/4.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitySelectBgView : UIView
@property (nullable,nonatomic,strong)UICollectionView *cityCollectionView;
@property (nullable,nonatomic,strong)UIView  *selectView;
@property (nullable,nonatomic,strong)UILabel *cityLab;
@property (nullable,nonatomic,strong)UIButton *selectBtn;
@property (nonatomic,nonnull,strong)NSArray *cityArray;
@property (nonnull,nonatomic,strong)UIButton *cityBtn;
@end
