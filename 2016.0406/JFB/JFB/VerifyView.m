//
//  VerifyView.m
//  图片剪切
//
//  Created by 积分宝 on 16/2/18.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "VerifyView.h"
#import "remarkView.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
@interface VerifyView ()
{
    UIImageView *imageView;
    UIView *view;
    UIImageView *imgview;
}
@end
@implementation VerifyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
        
        //整体背景
        UIImage *image = [UIImage imageNamed:@"scroll_check.jpg"];
        //小图块
        UIImage *srcimg = [UIImage imageNamed:@"scroll_check.jpg"];//／／test.png宽172 高192
        
        if (WITH<375) {
            image = [UIImage imageNamed:@"scroll_check2.jpg"];
            srcimg = [UIImage imageNamed:@"scroll_check2.jpg"];
        }
        
        imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.image=image;
        imageView.center = self.center;
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        
        
        
        float with = imageView.frame.size.width;
        float height = imageView.frame.size.height;
        
        float myX =arc4random()%100;
        float myY =arc4random()%200;
        //扣去部分背景色
        view = [[UIView alloc]initWithFrame:CGRectMake(myX, myY, 60, 100)];
        view.backgroundColor = [UIColor grayColor];
        [imageView addSubview:view];
        NSLog(@"%f---%f",imageView.frame.origin.x,imageView.frame.origin.y);
        
        
        
        NSLog(@"image width = %f,height = %f",with,height);
        
        
        imgview = [[UIImageView alloc] init];
        imgview.backgroundColor = [UIColor redColor];
        imgview.frame = CGRectMake(with*.1, height*.5, 60, 100);
        CGRect rect =  CGRectMake(myX, myY, 60, 100);//要裁剪的图片区域，按照原图的像素大小来，超过原图大小的边自动适配
        CGImageRef cgimg = CGImageCreateWithImageInRect([srcimg CGImage], rect);
        imgview.image = [UIImage imageWithCGImage:cgimg];
        CGImageRelease(cgimg);//用完一定要释放，否则内存泄露
        
        imgview.layer.borderColor  = [[UIColor redColor] CGColor]; //要设置的颜色
        imgview.layer.borderWidth = 1; //要设置的描边宽
        [imageView addSubview:imgview];
        imgview.userInteractionEnabled = YES;
        
        //拖拽
        UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
        
        [imgview addGestureRecognizer:panGestureRecognizer];
        

    }
    return self;
}
- (void) handlePanGestures:(UIPanGestureRecognizer*)paramSender{
    
    if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed){
        //通过使用 locationInView 这个方法,来获取到手势的坐标
        CGPoint location = [paramSender locationInView:imageView];
        paramSender.view.center = location;
        
        
        int a = location.x - view.center.x;
        int b = location.y - view.center.y;
        
        // NSLog(@"%d---%d",abs(a),abs(b));
        
        if ((abs(a)-1<=5)&&(abs(b)-1<=5)) {
            paramSender.view.center = view.center;
            imgview.layer.borderWidth = 0; //要设置的描边宽
            NSLog(@"wancehen");
        }else {
            
        }
        if (location.x<30) {
            location.x=30;
            paramSender.view.center = location;
            
            
        }
        
        if (location.x>imageView.frame.size.width-30) {
            location.x=imageView.frame.size.width-30;
            paramSender.view.center = location;
        }
        
        if (location.y<50) {
            location.y=50;
            paramSender.view.center = location;
        }
        if (location.y>imageView.frame.size.height-50) {
            location.y=imageView.frame.size.height-50;
            paramSender.view.center = location;
        }
    }
}

@end
