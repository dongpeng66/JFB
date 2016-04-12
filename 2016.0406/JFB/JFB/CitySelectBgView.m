//
//  CitySelectBgView.m
//  UISCorrllVIew
//
//  Created by 积分宝 on 16/1/4.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "CitySelectBgView.h"
#import "CitySelectViewController.h"
#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define BJCOLOR  [UIColor colorWithRed:219/255. green:219/255. blue:219/255. alpha:1];
@interface CitySelectBgView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    NSString * identifier;
    
}

@end
@implementation CitySelectBgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = BJCOLOR;
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    
    
    self.selectView = [[UIView alloc]initWithFrame:CGRectMake(20, HEIGHT*.224, WITH-40, HEIGHT*.06)];
    _selectView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_selectView];

    
    UIImageView *leftIM = [[UIImageView alloc]initWithFrame:CGRectMake(6, HEIGHT*.06*.27, WITH*.053, WITH*.053)];
  //  leftIM.backgroundColor = [UIColor redColor];
      leftIM.contentMode = UIViewContentModeScaleAspectFill;
    leftIM.image = [UIImage imageNamed:@"icon_othermap_merchant_detail"];
    [_selectView addSubview:leftIM];
    identifier = @"cell";
    
    self.cityLab = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.08, HEIGHT*.06*.15, WITH*.6, HEIGHT*.06*.7)];
    //_cityLab.backgroundColor = [UIColor redColor];
    [_selectView addSubview:_cityLab];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.74, HEIGHT*.06*.15, WITH*.1, HEIGHT*.06*.7)];
    lab.text = @"切换";
    //lab.backgroundColor = [UIColor redColor];
    [_selectView addSubview:lab];
    
    UIImageView *rightIM = [[UIImageView alloc]initWithFrame:CGRectMake(WITH*.84, HEIGHT*.06*.3,WITH*.024, HEIGHT*.024)];
   // rightIM.backgroundColor = [UIColor redColor];
    rightIM.contentMode = UIViewContentModeScaleAspectFill;
    rightIM.image = [UIImage imageNamed:@"to_info_mini_gray"];
    [_selectView addSubview:rightIM];
    
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // _selectBtn.backgroundColor = [UIColor whiteColor];
        _selectBtn.frame = CGRectMake(20, HEIGHT*.224, WITH-40, HEIGHT*.06);
        [self addSubview:_selectBtn];
    
    // 初始化layout
    
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    
    self.cityCollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0,0, WITH, HEIGHT*.194 )collectionViewLayout:flowLayout];
    _cityCollectionView.backgroundColor  = BJCOLOR;
    //注册单元格
    
    [self.cityCollectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:identifier];
    
    //设置代理
    
    _cityCollectionView.delegate = self;
    
    _cityCollectionView.dataSource = self;
    
    [self addSubview:_cityCollectionView];
    
    
    // NSLog(@"%.2f",80/self.view.frame.size.width);
  NSLog(@"%.4f",150/HEIGHT);
}
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    
    return 1;
    
}

//设置元素的的大小框

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    
    UIEdgeInsets top = {20,20,20,20};
    
    return top;
    
}

//每个分区上得元素个数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    
    return  [_cityArray count] + 1; //增加“全部”区县;
    
}

//设置元素内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    [cell sizeToFit];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    cell.backgroundColor =[UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WITH*.21, HEIGHT*.045)];
    //lab.backgroundColor = [UIColor redColor];
    lab.textAlignment = NSTextAlignmentCenter;
    
    if (indexPath.item==0) {
        lab.text = @"全部";
    }else {
    CityDistrictsCoreObject *county = (CityDistrictsCoreObject *)self.cityArray[indexPath.item-1];

    lab.text = [NSString stringWithFormat:@"%@", county.areaName];
    }
    [cell.contentView addSubview:lab];
    self.cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  //  _cityBtn.backgroundColor = [UIColor redColor];
    _cityBtn.frame =CGRectMake(0, 0, WITH*.21, HEIGHT*.045);
   // [_cityBtn addTarget:self action:@selector(xxx) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:_cityBtn];
    
    return cell;
    
}
//-(void)xxx{
//    NSLog(@"xxxxx");
//}
//设置单元格宽度

//设置元素大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(WITH*.21,HEIGHT*.045);
    
}
//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"第%ld个",(long)indexPath.row);
}

@end
