//
//  RedPacket.h
//  红包
//
//  Created by 积分宝 on 15/12/11.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol myRedpacket <NSObject>

-(void)returnRedpacket:(float) redPacket;

@end
@interface RedPacket : UIViewController
@property(nonatomic,strong)id<myRedpacket> xieyi;
@property(nonatomic,strong) NSString *className;
@end
