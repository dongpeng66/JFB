//
//  MoneyView.m
//  商品详情
//
//  Created by 积分宝 on 15/12/21.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import "MoneyView.h"
#define WITH [UIScreen mainScreen].bounds.size.width
#define HEIGHT self.bounds.size.height
@implementation MoneyView

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
      self.content = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WITH*.6,HEIGHT)];
         [self addSubview:_content];
    }
    return self;
}

-(void)pilck:(NSString*)pilcks :(NSString *)usedPilck{
    _pilck=pilcks;
    
   
    _content.textColor = [UIColor redColor];
    _content.font = [UIFont systemFontOfSize:30];
    //  _content.backgroundColor = [UIColor orangeColor];
    
   // float m=1666;
   // NSLog(@"cccc%.2d",_pilck.length);
    
    
   
    _attributedText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f  市场价:¥%.1f",[_pilck floatValue],[usedPilck floatValue]]];
    NSString *s = [NSString stringWithFormat:@"%.1f",[_pilck floatValue]];
    
    NSString *ss = [NSString stringWithFormat:@"%.1f",[usedPilck floatValue]];
    
    
                if(s.length>=6){
    
                 _content.font = [UIFont systemFontOfSize:13];
                    [_attributedText addAttribute:NSFontAttributeName
    
                                            value:[UIFont systemFontOfSize:25]
    
                                            range:NSMakeRange(1, s.length+1)];
                    
                    [_attributedText addAttribute:NSForegroundColorAttributeName
                     
                                            value:[UIColor grayColor]
                     
                                            range:NSMakeRange(s.length +3, 6+ss.length)];
           }else {
    
    [_attributedText addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:12]
                            range:NSMakeRange(0, 1)];
    [_attributedText addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:12]
                            range:NSMakeRange(s.length +1+2,6+ss.length)];
    
    [_attributedText addAttribute:NSForegroundColorAttributeName
     
                            value:[UIColor grayColor]
     
                            range:NSMakeRange(s.length +3, 6+ss.length)];
     }
    _content.attributedText = _attributedText;
    if (pilcks==nil) {
        _content.text = @"";
    }
   
}
@end
