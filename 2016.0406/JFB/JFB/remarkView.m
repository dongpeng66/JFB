//
//  remarkView.m
//  自定义提示
//
//  Created by 积分宝 on 16/2/22.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "remarkView.h"
@interface remarkView ()<UITextViewDelegate>
{
    UILabel *tiShiL;
}

@end
@implementation remarkView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        int w = self.bounds.size.width;
        int h = self.bounds.size.height;
        self.backgroundColor = [UIColor grayColor];
        self.filed = [[UITextView alloc]initWithFrame:CGRectMake(2, 2, w-4, h-42)];
        _filed.delegate = self;
        [self addSubview:_filed];
        
        tiShiL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _filed.bounds.size.width, 30)];
        tiShiL.textColor = [UIColor grayColor];
        tiShiL.font = _filed.font;
        tiShiL.text = @"请点击输入买家留言(选填)";
        [self addSubview:tiShiL];
        
        
        
        self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(2, h-40, w/2-2, 40)];
        _leftBtn.backgroundColor = [UIColor grayColor];
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self addSubview:_leftBtn];
        
        self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(w/2, h-40, w/2-2, 40)];
        [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        _rightBtn.backgroundColor = [UIColor redColor];
        [self addSubview:_rightBtn];
        
    }
    return self;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (text.length>0) {
        tiShiL.hidden = YES;
    }
    
  if ([text isEqualToString:@""] && range.location == 0 && range.length == 1){
        tiShiL.hidden = NO;
    }
    
    return YES;
}

@end
