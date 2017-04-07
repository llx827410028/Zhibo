//
//  ZhiBoRankingView.m
//  Demo
//
//  Created by ugamehome on 2016/10/21.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "ZhiBoRankingView.h"
#import "RankingCell.h"
#import "UIView+ZUtils.h"
#define RANK_WIDTH 230

@interface ZhiBoRankingView() <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *o_num;
@property (weak, nonatomic) IBOutlet UILabel *o_name;
@property (weak, nonatomic) IBOutlet UILabel *o_pm;
@property (weak, nonatomic) IBOutlet UILabel *o_bottomTitle;
@property (weak, nonatomic) IBOutlet UITableView *o_tableView;
@property (strong,nonatomic)ZhiboModel_getArchorRank *o_archorRank;
@end



@implementation ZhiBoRankingView

- (void)awakeFromNib{
    [super awakeFromNib];
    _o_tableView.delegate = self;
    _o_tableView.dataSource = self;
    _o_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _o_name.text = [ZhiboCommon getStringBykey:@"昵称"];
     _o_num.text = [ZhiboCommon getStringBykey:@"点赞数"];
    _o_pm.text = [ZhiboCommon getStringBykey:@"排名"];

    NSString *pmStr = [ZhiboCommon getStringBykey:@"排行榜"];
    NSString *midleStr = [ZhiboCommon getStringBykey:@"每周-00:00"];
    NSString *updateStr = [ZhiboCommon getStringBykey:@"更新"];
    
     NSString *str = [NSString stringWithFormat:@"%@%@%@",pmStr,midleStr,updateStr];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(255, 231, 23) range:NSMakeRange(pmStr.length, midleStr.length)];
    _o_bottomTitle.attributedText = AttributedStr;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_o_archorRank.o_data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.18*_o_tableView.width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"RankingCell";
    RankingCell *cell = (RankingCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [RankingCell liveEndView];
        cell.width = _o_tableView.width;
    }
    cell.userInteractionEnabled = NO;
    ZhiboModel_getArchorRank_data *rank = [_o_archorRank.o_data objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    [cell fillCellWithRank:[NSString stringWithFormat:@"%d",rank.rank]  andName:rank.archorNickname andZan:rank.upnum];
    return cell;
}

/**
 *   获取主播排名
 */
- (void)getRankinfo{
    NSString *timestamp = [VTTool getTimeSp];
    NSDictionary *dic =  @{
                           @"playerid":[ZhiboCommon getPlayId],
                           @"serverid":[ZhiboCommon getServerId],
                           @"timestamp":timestamp,
                           @"sign":[VTTool md5:[NSString stringWithFormat:@"%@%@%@",[ZhiboCommon getPlayId],timestamp,[ZhiboCommon getSecret_key]]],
                           };
    if (_o_archorRank) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    @WeakObj(hud)
    @WeakObj(_o_tableView)
    
    
    
    [[ZhiboRequests shareInstance]postZhiboData:dic andUrl:@"/getAnchorRank.php" andBackObjName:@"getAnchorRank" withSuccessBlock:^(id backId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudWeak hide:YES];
        });
        if([ZhiboCommon requestStatusbyReult:[backId[@"result"]intValue]]){
        }else{
            return;
        }
         _o_archorRank = [[ZhiboModel_getArchorRank alloc]init];
        [_o_archorRank getModelFormJson:backId];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in backId[@"data"]) {
            ZhiboModel_getArchorRank_data *archorRank = [[ZhiboModel_getArchorRank_data alloc]init];
            [archorRank getModelFormJson:dic];
            [arr addObject:archorRank];
        }
        _o_archorRank.o_data = arr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_o_tableViewWeak reloadData];
        });
    } withFaildBlock:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudWeak hide:YES];
        });
    }];
}
@end
