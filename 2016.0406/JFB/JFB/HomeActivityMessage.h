//
//  HomeActivityMessage.h
//  JFB
//
//  Created by IOS on 16/3/9.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeActivityMessage : NSObject
/**
 *广告信息数据id
 */
@property (nonatomic,copy)NSString *activity_id;
/**
 *  图片地址
 */
@property (nonatomic,copy)NSString *activity_img_url;
/**
 *  标题
 */
@property (nonatomic,copy)NSString *activity_title;
/**
 *  图片链接地址
 */
@property (nonatomic,copy)NSString *activity_content;
/**
 *  商户ID
 */
@property (nonatomic,copy)NSString *activity_merchant_id;
/**
 *  商品ID
 */
@property (nonatomic,copy)NSString *activity_good_id;
/**
 *  图片类型
 */
@property (assign,nonatomic) NSInteger activity_img_type;
/**
 *  链接类型
 */
@property (copy,nonatomic) NSString * activity_link_type;
/**
 *  活动开始时间
 */
@property (nonatomic,copy)NSString *activity_start_Time;
/**
 *  活动结束时间
 */
@property (nonatomic,copy)NSString *activity_end_Time;
/**
 *  活动当前时间
 */
@property (nonatomic,copy)NSString *activity_current_Time;
/**
 *  商品活动价格
 */
@property (nonatomic,copy)NSString *activityPrice;
/**
 *  商品市场价格
 */
@property (nonatomic,copy)NSString *marketPrice;

@property (nonatomic,copy)NSString *linkUrl;
@property (nonatomic,copy)NSString *title;
@end
