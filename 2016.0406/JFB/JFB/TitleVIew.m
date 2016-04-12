//
//  TitleVIew.m
//  头部选择
//
//  Created by 积分宝 on 16/3/18.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "TitleVIew.h"

@implementation TitleVIew
-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        int w = self.bounds.size.width;
        int h = self.bounds.size.height;
        NSLog(@"%d---%d",w,h);
       
        
        UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake( 0, 0, 200, 30)];
        field.placeholder = @"输入商家搜索";
        
        //文本框左侧图标
        UIImageView *image1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"caca.png"]];
        image1.frame=CGRectMake(10, 0, 27, 27);
        field.leftView=image1;
        field.leftViewMode=UITextFieldViewModeAlways;
        [self addSubview:field];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, w, h)];
        imageView.userInteractionEnabled=YES;
        imageView.image = [UIImage imageNamed:@"TSFShouBeiJing"];
        [self addSubview:imageView];
        
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(0, 0, w -30, h);
       // _searchBtn.backgroundColor = [UIColor redColor];
        [self addSubview:_searchBtn];
        
        
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake( w-26, (h-18)/2, 18,18)];
        imageView1.userInteractionEnabled=YES;
        imageView1.image = [UIImage imageNamed:@"saoErWeiMa"] ;
        [self addSubview:imageView1];
        
        _saoMaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saoMaBtn.frame = CGRectMake( w -30, 0,30, h);
       // _saoMaBtn.backgroundColor = [UIColor orangeColor];
       
        [self addSubview:_saoMaBtn];

    }
    return self;
}

@end
