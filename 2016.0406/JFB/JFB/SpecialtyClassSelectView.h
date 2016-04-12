//
//  SpecialtyClassSelectView.h
//  头部选择
//
//  Created by 积分宝 on 16/3/17.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SpecialtyClassDelegate <NSObject>
-(void)SpecialtyClassDelegate:(int) itmeIndext :(BOOL)selfHidden;
@end
@interface SpecialtyClassSelectView : UIView
@property (nullable,nonatomic,strong)UICollectionView *cityCollectionView;
@property (nonatomic,nonnull,strong)NSArray *dataArray;
@property (nonatomic,weak)id<SpecialtyClassDelegate>specialtyClassDelegate;
@end
