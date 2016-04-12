//
//  JFBCountDownDayView.m
//  JFB
//
//  Created by IOS on 16/3/10.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "JFBCountDownDayView.h"
#import "checkIphoneNum.h"
// label数量
#define labelCount 4
#define separateLabelCount 3
#define padding 5
@interface JFBCountDownDayView (){
    // 定时器
    //    NSTimer *timer;
}
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)NSMutableArray *timeLabelArrM;
@property (nonatomic,strong)NSMutableArray *separateLabelArrM;
// day
@property (nonatomic,strong)UILabel *dayLabel;
// hour
@property (nonatomic,strong)UILabel *hourLabel;
// minues
@property (nonatomic,strong)UILabel *minuesLabel;
// seconds
@property (nonatomic,strong)UILabel *secondsLabel;
@end
@implementation JFBCountDownDayView
// 创建单例
+ (instancetype)shareCountDown{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JFBCountDownDayView alloc] init];
    });
    return instance;
}

+ (instancetype)countDown{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.dayLabel];
        [self addSubview:self.hourLabel];
        [self addSubview:self.minuesLabel];
        [self addSubview:self.secondsLabel];
        
        for (NSInteger index = 0; index < separateLabelCount; index ++) {
            UILabel *separateLabel = [[UILabel alloc] init];
            if (index==0) {
                separateLabel.text=@"";
            }else{
                separateLabel.text = @":";
            }
            separateLabel.textColor=[UIColor redColor];
            separateLabel.textAlignment = NSTextAlignmentCenter;
            separateLabel.font=[UIFont boldSystemFontOfSize:12];
            [self addSubview:separateLabel];
            [self.separateLabelArrM addObject:separateLabel];
        }
    }
    return self;
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName{
    _backgroundImageName = backgroundImageName;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundImageName]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
    //    [self bringSubviewToFront:imageView];
}

// 拿到外界传来的时间戳
- (void)setTimestamp:(NSInteger)timestamp{
    _timestamp = timestamp;
    if (_timestamp != 0) {
        SEL selectorToCall = @selector(timer:);
        NSMethodSignature *methodSignature =[[self class] instanceMethodSignatureForSelector:selectorToCall];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        
        [invocation setTarget:self];
        [invocation setSelector:selectorToCall];
        NSTimer *newTimer = [NSTimer timerWithTimeInterval:1.0
                                                invocation:invocation
                                                   repeats:YES];
        self.timer=newTimer;
        [[NSRunLoop currentRunLoop] addTimer:self.timer
                                     forMode:NSDefaultRunLoopMode];
        //        timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    }
}

-(void)timer:(NSTimer*)timerr{
    _timestamp--;
    [self getDetailTimeWithTimestamp:_timestamp];
    if (_timestamp == 0) {
        [self.timer invalidate];
        self.timer = nil;
        // 执行block回调
        self.timerStopBlock();
    }
}

- (void)getDetailTimeWithTimestamp:(NSInteger)timestamp{
    NSInteger ms = timestamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    //    NSLog(@"%zd日:%zd时:%zd分:%zd秒",day,hour,minute,second);
    
    self.dayLabel.text = [NSString stringWithFormat:@"%zd天",day];
    if (minute<10) {
        self.minuesLabel.text = [NSString stringWithFormat:@"0%zd",minute];
    }else{
        self.minuesLabel.text = [NSString stringWithFormat:@"%zd",minute];
    }
    if (second<10) {
        self.secondsLabel.text = [NSString stringWithFormat:@"0%zd",second];
    }else{
        self.secondsLabel.text = [NSString stringWithFormat:@"%zd",second];
    }
    self.hourLabel.text = [NSString stringWithFormat:@"%zd",hour];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 获得view的宽、高
    CGFloat viewW = self.frame.size.width;
    // 单个label的宽高
    CGFloat labelW = (viewW-15) / labelCount;
    CGFloat labelH = labelW;
    self.dayLabel.frame = CGRectMake(0, 0, labelW, labelH);
    //    self.dayLabel.layer.cornerRadius=labelW/2;
    self.hourLabel.frame = CGRectMake(labelW+5, 0, labelW, labelH);
    //    self.hourLabel.layer.cornerRadius=labelW/2;
    self.minuesLabel.frame = CGRectMake(2 * labelW+10 , 0, labelW, labelH);
    //    self.minuesLabel.layer.cornerRadius=labelW/2;
    self.secondsLabel.frame = CGRectMake(3 * labelW+15, 0, labelW, labelH);
    //    self.secondsLabel.layer.cornerRadius=labelW/2;
    
    for (NSInteger index = 0; index < self.separateLabelArrM.count ; index ++) {
        UILabel *separateLabel = self.separateLabelArrM[index];
        separateLabel.frame = CGRectMake((labelW) * (index + 1)+5*index, 0, 5, labelH);
    }
}


#pragma mark - setter & getter

- (NSMutableArray *)timeLabelArrM{
    if (_timeLabelArrM == nil) {
        _timeLabelArrM = [[NSMutableArray alloc] init];
    }
    return _timeLabelArrM;
}

- (NSMutableArray *)separateLabelArrM{
    if (_separateLabelArrM == nil) {
        _separateLabelArrM = [[NSMutableArray alloc] init];
    }
    return _separateLabelArrM;
}

- (UILabel *)dayLabel{
    if (_dayLabel == nil) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        //        _dayLabel.backgroundColor = [UIColor grayColor];
        _dayLabel.textColor=[UIColor redColor];
        _dayLabel.font=[UIFont boldSystemFontOfSize:[checkIphoneNum shareCheckIphoneNum].dayTextFont];
        _dayLabel.layer.masksToBounds=YES;
    }
    return _dayLabel;
}

- (UILabel *)hourLabel{
    if (_hourLabel == nil) {
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        //        _hourLabel.backgroundColor = [UIColor grayColor];
        _hourLabel.textColor=[UIColor redColor];
        _hourLabel.font=[UIFont boldSystemFontOfSize:[checkIphoneNum shareCheckIphoneNum].textFont];
        _hourLabel.layer.masksToBounds=YES;
    }
    return _hourLabel;
}

- (UILabel *)minuesLabel{
    if (_minuesLabel == nil) {
        _minuesLabel = [[UILabel alloc] init];
        _minuesLabel.textAlignment = NSTextAlignmentCenter;
        //        _minuesLabel.backgroundColor = [UIColor grayColor];
        _minuesLabel.textColor=[UIColor redColor];
        _minuesLabel.font=[UIFont boldSystemFontOfSize:[checkIphoneNum shareCheckIphoneNum].textFont];
        _minuesLabel.layer.masksToBounds=YES;
    }
    return _minuesLabel;
}

- (UILabel *)secondsLabel{
    if (_secondsLabel == nil) {
        _secondsLabel = [[UILabel alloc] init];
        _secondsLabel.textAlignment = NSTextAlignmentCenter;
        //        _secondsLabel.backgroundColor = [UIColor grayColor];
        _secondsLabel.textColor=[UIColor redColor];
        _secondsLabel.font=[UIFont boldSystemFontOfSize:[checkIphoneNum shareCheckIphoneNum].textFont];
        _secondsLabel.layer.masksToBounds=YES;
    }
    return _secondsLabel;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
