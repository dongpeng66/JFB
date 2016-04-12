//
//  UITabBarItem+Universal.m
//  JFB
//
//  Created by JY on 15/8/16.
//  Copyright (c) 2015年 JY. All rights reserved.
//
#import "UITabBarItem+Universal.h"

@implementation UITabBarItem (Universal)

- (void)itemWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    [self setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self setSelectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}
@end
