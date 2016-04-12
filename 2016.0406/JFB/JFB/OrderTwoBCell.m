//
//  OrderTwoBCell.m
//  订单详情
//
//  Created by 积分宝 on 16/1/8.
//  Copyright © 2016年 积分宝. All rights reserved.
//

#import "OrderTwoBCell.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  ([[UIScreen mainScreen] bounds].size.height*.251)
@implementation OrderTwoBCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor =[UIColor whiteColor];
        [self addFenGeXian];
        [self addZhuanTai];
    
        
        //第一个圆
        UILabel *lab5= [[UILabel alloc]initWithFrame:CGRectMake(WITH*.099,HEIGHT*.41, HEIGHT*.156, HEIGHT*.156)];
        //lab5.backgroundColor = [UIColor redColor];
        lab5.backgroundColor = [UIColor orangeColor];
        lab5.clipsToBounds = YES;
        lab5.layer.cornerRadius = HEIGHT*.156/2;
        [self addSubview:lab5];
        
        //横条上方线
        UILabel *lab3= [[UILabel alloc]initWithFrame:CGRectMake(WITH*.1,HEIGHT*.47, WITH-WITH*.2, 1)];
        lab3.backgroundColor = [UIColor orangeColor];
        [self addSubview:lab3];
        //横条下方线
        UILabel *lab4= [[UILabel alloc]initWithFrame:CGRectMake(WITH*.1,HEIGHT*.5, WITH-WITH*.2, 1)];
        lab4.backgroundColor = [UIColor orangeColor];
        [self addSubview:lab4];
        
      
        [self addSubviews];
        
        
          NSArray *arr =[NSArray arrayWithObjects:@"申请退款",@"商家处理",@"客服审核",@"完成处理", nil];
        for (int i=0; i<4; i++) {
            //四个提示lab
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.05+WITH*.25*i, HEIGHT*.57, WITH*.15, HEIGHT*.16)];
            lab.textColor = [UIColor grayColor];
           lab.contentMode = UIViewContentModeScaleAspectFit;
           // lab.backgroundColor = [UIColor redColor];
            lab.text = arr[i];
        
            lab.font = [UIFont systemFontOfSize:13];
            if(WITH<375){
             lab.font = [UIFont systemFontOfSize:10];
            }
        [self addSubview:lab];
        }
        
      
    }
    return self;
}
-(void)addSubviews{
  

    //第二个圆
    self.auditL= [[UILabel alloc]initWithFrame:CGRectMake(WITH*.34,HEIGHT*.41, HEIGHT*.156, HEIGHT*.156)];
    //_auditL.backgroundColor = [UIColor redColor];
    _auditL.backgroundColor = [UIColor orangeColor];
    _auditL.clipsToBounds = YES;
    _auditL.layer.cornerRadius = HEIGHT*.156/2;
    [self addSubview:_auditL];
    //第三个圆
    self.accomplishL= [[UILabel alloc]initWithFrame:CGRectMake(WITH*.59,HEIGHT*.41, HEIGHT*.156, HEIGHT*.156)];
   // _accomplishL.backgroundColor = [UIColor redColor];
    _accomplishL.backgroundColor = [UIColor whiteColor];
    _accomplishL.clipsToBounds = YES;
    _accomplishL.layer.cornerRadius = HEIGHT*.156/2;
    _accomplishL.layer.borderColor  =[[UIColor orangeColor] CGColor]; //要设置的颜色
    _accomplishL.layer.borderWidth = 1; //要设置的描边宽
    [self addSubview:_accomplishL];

   //第四个圆
    self.handleL= [[UILabel alloc]initWithFrame:CGRectMake(WITH*.842,HEIGHT*.41, HEIGHT*.156, HEIGHT*.156)];
    // _handleL.backgroundColor = [UIColor redColor];
    _handleL.backgroundColor = [UIColor whiteColor];
    _handleL.clipsToBounds = YES;
    _handleL.layer.cornerRadius = HEIGHT*.156/2;
    _handleL.layer.borderColor  =[[UIColor orangeColor] CGColor]; //要设置的颜色
    _handleL.layer.borderWidth = 1; //要设置的描边宽
    
    [self addSubview:_handleL];
}

//横条
-(void)accompLishLong:(NSString *)text{
    self.scheduleL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.1,HEIGHT*.47, (WITH-WITH*.2)/3, HEIGHT*.04)];
    if([text isEqual:@"1"]){
        _scheduleL.frame = CGRectMake(WITH*.1,HEIGHT*.47, (WITH-WITH*.2)/1.5, HEIGHT*.04);
        _accomplishL.backgroundColor = [UIColor orangeColor];
    }else if([text isEqual:@"2"]){
        _scheduleL.frame = CGRectMake(WITH*.1,HEIGHT*.47, WITH-WITH*.2, HEIGHT*.04);
        _accomplishL.backgroundColor = [UIColor orangeColor];
        _handleL.backgroundColor = [UIColor orangeColor];
    }
    _scheduleL.backgroundColor = [UIColor orangeColor];
    [self addSubview:_scheduleL];
}
//分割线
-(void)addFenGeXian{
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,HEIGHT*.262, WITH, 1)];
    lab.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
    [self addSubview:lab];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0,HEIGHT*.92, WITH, 1)];
    lab2.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
    [self addSubview:lab2];
}
//状态
-(void)addZhuanTai{
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.03, HEIGHT*.05, WITH*.3, HEIGHT*.18)];
    lab1.text = @"订单状态";
    lab1.textColor = [UIColor grayColor];
    // lab1.backgroundColor = [UIColor redColor];
    [self addSubview:lab1];

    
    self.stateL = [[UILabel alloc]initWithFrame:CGRectMake(WITH*.6, HEIGHT*.05, WITH*.37, HEIGHT*.18)];
    //_stateL.backgroundColor = [UIColor grayColor];
    _stateL.textColor = [UIColor redColor];
    _stateL.text = @"退款中";
    _stateL.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_stateL];
}

@end
