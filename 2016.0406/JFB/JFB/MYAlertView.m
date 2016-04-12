//
//  MYAlertView.m
//  自定义弹窗
//
//  Created by 积分宝 on 16/3/23.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "MYAlertView.h"
@interface MYAlertView ()
{
     UILabel *textL;
}
@end
@implementation MYAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       
        self.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.backgroundColor = [UIColor blackColor];
        imageView.alpha = .8;
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        imageView.tag = 9999;
        [self addSubview:imageView];
        textL = [[UILabel alloc]initWithFrame:self.bounds];
        textL.center =self.center;
        textL.textAlignment = NSTextAlignmentCenter;
        textL.textColor = [UIColor whiteColor];
        
       
        [self addSubview:textL];
    }
    return self;
}
-(void)show:(NSString *)string{
    self.hidden = NO;
    
    textL.text = string;
  CGSize sizeToFit = [string boundingRectWithSize:CGSizeMake(self.bounds.size.width*.5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    textL.numberOfLines = 0;
    textL.frame = CGRectMake(0, 0,sizeToFit.width+30, sizeToFit.height+30);

    UIImageView *view = [self viewWithTag:9999];
    textL.center =self.center;
     view.frame = textL.frame;
    
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    
    void (^task)() = ^ {
        // 延迟操作执行的代码
       [self hide];
    };
    // 经过多少纳秒，由主队列调度任务异步执行
    dispatch_after(when, dispatch_get_main_queue(), task);
    
    
   
    
}
-(void)hide{
    self.hidden = YES;

}
-(void)yesAndNo:(NSString *)string{
    
    self.hidden = NO;
    textL.text = string;
    CGSize sizeToFit = [string boundingRectWithSize:CGSizeMake(self.bounds.size.width*.5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    textL.numberOfLines = 0;
    textL.frame = CGRectMake(0, 0,sizeToFit.width+30, sizeToFit.height+30);
    
    UIImageView *view = [self viewWithTag:9999];
    textL.center =self.center;
    view.frame = textL.frame;
    
}
@end
