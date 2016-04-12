//
//  SpecialtyHeadView.m
//  头部选择
//
//  Created by 积分宝 on 16/3/16.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "SpecialtyHeadView.h"
#import "checkIphoneNum.h"
@implementation SpecialtyHeadView

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:239/255. green:239/255. blue:239/255. alpha:1];

        float w = self.frame.size.width;
        float h = self.frame.size.height;
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(w-w*.15-1, (h-h*.6-1)/2, 1, h*.6)];
        lab.backgroundColor = RGBCOLOR(195, 195, 195);
        [self addSubview:lab];
        
        
         _imageViewx = [[UIImageView alloc]initWithFrame:CGRectMake(w- w*.066-((w*.15- w*.066)/2), (h- h*.555)/2+2, w*.066, h*.555)];
    
        _imageViewx.image = [UIImage imageNamed:@"SF_icon"];
        [self addSubview:_imageViewx];

        _btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
       // _btn4.backgroundColor = [UIColor orangeColor];
        _btn4.frame = CGRectMake(w-w*.15, 0, w*.15, h-1);
        _btn4.tag = 4;
//        [_btn4 setImage:[UIImage imageNamed:@"SF_icon"] forState:UIControlStateNormal];
//        [_btn4 setImage:[UIImage imageNamed:@"SF_icon2"] forState:UIControlStateSelected];
        _btn4.imageView.contentMode = UIViewContentModeScaleToFill;
        [_btn4 addTarget:self action:@selector(delegate:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_btn4];
        
        
    }
    return self;
}

#pragma mark - 选择分类是否隐藏按钮事件
-(void)delegate:(UIButton *)btn{
     BOOL hiden = YES;

      if(btn.tag ==4 ){
        btn.selected = !btn.selected;
      }
    if (btn.selected == YES) {
        _imageViewx.image = [UIImage imageNamed:@"SF_icon2"];
        hiden = NO;
    }else {
        hiden = YES;
        _imageViewx.image = [UIImage imageNamed:@"SF_icon"];
    }
    if ([self respondsToSelector:@selector(specDelegate)]) {
        
        [self.specDelegate specdelegatebutton:hiden];
    }
}

#pragma mark - 分类横排滑动scorllView
-(void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    
    float itemWith = (w-w*.15-1)/3;
    _scorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w-w*.15-1, h)];
   // _scorllView.backgroundColor = [UIColor redColor];
    _scorllView.contentSize = CGSizeMake(itemWith*dataArr.count, 0);
    _scorllView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scorllView];
    
    for (int i=0; i<dataArr.count; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(itemWith*i, 0, itemWith, h-1)];
        btn.tag = i+1000;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setTitle:[NSString stringWithFormat:@"%@",dataArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(scoreViewitme:) forControlEvents:UIControlEventTouchUpInside];
        if(SCREEN_WIDTH==320){
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
        } else if(SCREEN_WIDTH==375){
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
        }else if(SCREEN_WIDTH>375){
            btn.titleLabel.font = [UIFont systemFontOfSize:18];
        }
        
        [_scorllView addSubview:btn];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(itemWith*i, h-1, itemWith, 1)];
        lab.backgroundColor = [UIColor redColor];
        lab.hidden = YES;
        lab.tag = i+2000;
        [_scorllView addSubview:lab];
      
            if(btn.tag == 1000){
                btn.selected = YES;
            }
        
        
        if (lab.tag == 2000) {
            lab.hidden =NO;
        }
    }
    
    _hintL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, w-w*.15-2, h)];
    _hintL.backgroundColor =[UIColor colorWithRed:239/255. green:239/255. blue:239/255. alpha:1];
    _hintL.text = @"请选择一种排序方式";
    _hintL.textAlignment = NSTextAlignmentCenter;
    _hintL.textColor = [UIColor redColor];
    _hintL.hidden = YES;
    [self addSubview:_hintL];

}
-(void)scoreViewitme:(UIButton *)btn{
  
  long  int indext  = btn.tag - 1000;
    if ([self respondsToSelector:@selector(specDelegate)]) {
        
        [self.specDelegate specdelegateIndext:(int)btn.tag-1000];
    }
    
    UIButton *mybtn ;
    for (int i = 0; i<_dataArr.count; i++) {
        mybtn = (UIButton *)[self viewWithTag:i+1000];
        mybtn.selected = NO;
        if (indext == i) {
            btn.selected = YES;
        }
    }
    
   UILabel *myLab;
   long int indext2 = btn.tag+1000;
   long int nima = indext2 -2000;
    for (int i = 0; i<_dataArr.count; i++) {
        myLab = (UILabel *)[self viewWithTag:i+2000];
        myLab.hidden = YES;
        if (nima == i) {
            myLab.hidden = NO;
        }
    }
}

#pragma mark - 根据itme 修改偏移量
-(void)alteroScorllViewOffset:(int)indext{
    NSLog(@"hahah--%d---",indext);
    
    UIButton *mybtn ;
    for (int i = 0; i<_dataArr.count; i++) {
        mybtn = (UIButton *)[self viewWithTag:i+1000];
        mybtn.selected = NO;
        if (indext == i) {
            mybtn.selected = YES;
        }
    }
    
    UILabel *myLab;
    for (int i = 0; i<_dataArr.count; i++) {
        myLab = (UILabel *)[self viewWithTag:i+2000];
        myLab.hidden = YES;
        if (indext == i) {
            myLab.hidden = NO;
        }
    }

    _hintL.hidden = YES;
}
@end
