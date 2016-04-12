//
//  JFBSeckillView.h
//  JFB
//
//  Created by IOS on 16/3/11.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JFBSeckillView;
@protocol JFBSeckillViewDelegate <NSObject>
@optional
/**
 点击了秒杀图片
 */
-(void)seckillViewDidTapImagView:(JFBSeckillView *)seckillView andButton:(UIButton *)btn;
@end
@interface JFBSeckillView : UIView
//
@property (nonatomic,strong) UIButton *btn;
/**
 *  秒杀商品图片
 */
@property (nonatomic,strong) UIImageView *imageView;
/**
 *  秒杀商品的秒杀价格
 */
@property (nonatomic,strong) UILabel *seckillPriceLabel;
/**
 *  秒杀商品的真实价格
 */
@property (nonatomic,strong) UILabel *realPriceLabel;
/**
 *  秒杀图片点击的代理
 */

@property (nonatomic,weak) id <JFBSeckillViewDelegate>delegate;

@end
