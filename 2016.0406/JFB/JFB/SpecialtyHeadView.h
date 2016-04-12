//
//  SpecialtyHeadView.h
//  头部选择
//
//  Created by 积分宝 on 16/3/16.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SpecDelegate <NSObject>
-(void)specdelegateIndext :(int)value;
-(void)specdelegatebutton:(BOOL)button;
@end
@interface SpecialtyHeadView : UIView
@property(nonatomic,strong) UIImageView *imageViewx;
@property(nonatomic,strong) UIButton *btn4;
@property(nonatomic,strong) NSArray *dataArr;
@property(nonatomic,strong) UIScrollView *scorllView;
@property(nonatomic,weak) id<SpecDelegate> specDelegate;
@property(nonatomic,strong) UILabel *hintL;
-(void)alteroScorllViewOffset:(int) indext;
@end
