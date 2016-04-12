//
//  SpecialtyClassSelectView.m
//  头部选择
//
//  Created by 积分宝 on 16/3/17.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "SpecialtyClassSelectView.h"
#define SELFWITH self.bounds.size.width
#define SELFHEIGHT self.bounds.size.height
@interface SpecialtyClassSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    NSString * identifier;
    
}

@end
@implementation SpecialtyClassSelectView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self){
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    
    identifier = @"cell";
    
    // 初始化layout
    
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    
    self.cityCollectionView =[[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _cityCollectionView.backgroundColor  = [UIColor colorWithRed:237/255. green:237/255. blue:237/255. alpha:1];
    //注册单元格
    
    [self.cityCollectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:identifier];
    
    //设置代理
    
    _cityCollectionView.delegate = self;
    
    _cityCollectionView.dataSource = self;
    
    [self addSubview:_cityCollectionView];
    
    NSLog(@"---%lu",(unsigned long)_dataArray.count);
    // NSLog(@"%.2f",80/self.view.frame.size.width);
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

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray =dataArray;
}
//每个分区上得元素个数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    NSArray *arr = [self dataArray];
    
    return arr.count;
    
}

//设置元素内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    [cell sizeToFit];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.backgroundColor =[UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(-2, -2, SELFWITH*.248,SELFHEIGHT*.259)];
    //lab.backgroundColor = [UIColor redColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row]];
    lab.layer.cornerRadius= 6;
    lab.clipsToBounds = YES;
    lab.layer.borderWidth = .8;
    lab.layer.borderColor = [UIColor colorWithRed:201/255. green:201/255. blue:201/255. alpha:1].CGColor;
    
    [cell.contentView addSubview:lab];
    
    return cell;
    
}

//设置元素大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SELFWITH*.237,SELFHEIGHT*.235);
    
}
//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  //  NSLog(@"第%ld个",(long)indexPath.row);
    self.hidden = YES;
    if ([self respondsToSelector:@selector(specialtyClassDelegate)]) {
        
        [self.specialtyClassDelegate SpecialtyClassDelegate:(int)indexPath.row :NO];
    }
}


@end
