//
//  RedPacket.m
//  红包
//
//  Created by 积分宝 on 15/12/11.
//  Copyright © 2015年 积分宝. All rights reserved.
//

#import "RedPacket.h"
#import "RedPacketCell.h"
@interface RedPacket ()<UITableViewDataSource,UITableViewDelegate,myRedpacket>

@end

@implementation RedPacket

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *taleview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.title = @"红包";
    
    taleview.dataSource = self;
    taleview.delegate = self;
    taleview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:taleview];
    
  

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
#pragma mark - 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
#pragma mark - 返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 104;
    
    
}
#pragma mark - 设置tableViewCell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *ss=@"hello word";
    
    RedPacketCell *cell=[tableView dequeueReusableCellWithIdentifier:ss];
    
    if(!cell){
        
        cell=[[RedPacketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
        //显示右边箭头
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}
#pragma mark - 监听tableViewCell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell背景恢复正常状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.className  isEqual:@"MineViewController"]) {
        NSLog(@"hahahahaha");
    }
    else{
    [self returnRedpacket:5.00];
    [self.navigationController popViewControllerAnimated:YES];
}
}
#pragma mark - 设置表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 31;
    }
    return 2;
}
#pragma mark - 设置表尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return 2;
}
-(void)returnRedpacket:(float) redPacket{
    
    [_xieyi returnRedpacket:redPacket];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
