//
//  ZhiBoListView.m
//  Demo
//
//  Created by ugamehome on 2016/10/21.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "ZhiBoListView.h"
#import "ZhiboListCellTableViewCell.h"
#import "UIView+ZUtils.h"
#define LIST_WIDTH  230

@interface ZhiBoListView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *o_tableView;
@property (weak, nonatomic) IBOutlet UIButton *o_btn_three;
@property (weak, nonatomic) IBOutlet UIButton *o_btn_two;
@property (weak, nonatomic) IBOutlet UIButton *o_btn_one;


@property (retain, nonatomic) ZhiboModel_getroom* o_rooms;
@property(nonatomic)int selectIndex;
@property (nonatomic)BOOL isLoad;
@property (nonatomic,strong)NSMutableArray *o_btn_array;
@end

@implementation ZhiBoListView


- (void)awakeFromNib{
    [super awakeFromNib];

    _o_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _o_tableView.delegate  = self;
    _o_tableView.dataSource = self;
    [_o_btn_one setBackgroundImage:[UIImage imageNamed:@"webview_btn_check"] forState:UIControlStateNormal];
    _o_btn_array  = [[NSMutableArray alloc]initWithObjects:_o_btn_one, _o_btn_two,_o_btn_three,nil];
}
/**
 *   获取主播排名
 */
- (void)getZhiboListinfo{
    NSString *timestamp = [VTTool getTimeSp];
    NSDictionary *dic =  @{
                           @"playerid":[ZhiboCommon getPlayId],
                           @"serverid":[ZhiboCommon getServerId],
                           @"timestamp":timestamp,
                           @"sign":[VTTool md5:[NSString stringWithFormat:@"%@%@%@",[ZhiboCommon getPlayId],timestamp,[ZhiboCommon getSecret_key]]],
                           };
    MBProgressHUD *hud  = nil;
    if (!_isLoad) {
          hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        
    }
   @WeakObj(hud);
    @WeakObj(_o_tableView);
    
    [[ZhiboRequests shareInstance]postZhiboData:dic andUrl:@"/getrooms.php" andBackObjName:@"getrooms" withSuccessBlock:^(id backId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudWeak hide:YES];
        });
        if([ZhiboCommon requestStatusbyReult:[backId[@"result"]intValue]]){
        }else{
            return;
        }
        _o_rooms = [[ZhiboModel_getroom alloc]init];
        [_o_rooms getModelFormJson:backId];
        
        NSMutableArray *data = [[NSMutableArray alloc]init];
        NSArray *arr = backId[@"data"];
        for (NSDictionary *dic in arr) {
            ZhiboModel_getrooms *roomObj = [[ZhiboModel_getrooms alloc]init];
            [roomObj  getModelFormJson:dic];
            
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            for (NSDictionary *dicObj in dic[@"rooms"]) {
                ZhiboModel_getrooms_data *getrooms_data = [[ZhiboModel_getrooms_data alloc]init];
                [getrooms_data getModelFormJson:dicObj];
                [arr addObject:getrooms_data];
            }
            roomObj.o_rooms = arr;
            [data addObject:roomObj];
        }
        _o_rooms.o_data = data;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!_isLoad) {
                _isLoad = YES;
            }
            
            for(int i =0;i<[data count];i++){
                ZhiboModel_getrooms *roomone = data[i];
                UIButton *bnt = _o_btn_array[i];
                bnt.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                 [bnt setTitle:roomone.title forState:UIControlStateNormal];
            }

            [_o_tableViewWeak reloadData];
        });
    } withFaildBlock:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!_isLoad) {
                [hudWeak hide:YES];
                _isLoad = YES;
            }
        });
    }];
}

- (IBAction)select:(id)sender {
    UIButton *bnt = (UIButton *)sender;
    if( _selectIndex != (bnt.tag - BTN_TAG)){
        UIButton *oldBnt = [_o_btn_array objectAtIndex:_selectIndex];
        oldBnt.selected = NO;
        bnt.selected = YES;
        [bnt setBackgroundImage:[UIImage imageNamed:@"webview_btn_check"] forState:UIControlStateNormal];
        [oldBnt setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _selectIndex = (int)(bnt.tag - BTN_TAG);
        [_o_tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ZhiboModel_getrooms *obj = [_o_rooms.o_data objectAtIndex:_selectIndex];
    return [obj.o_rooms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"ZhiboListCellTableViewCell";
    ZhiboModel_getrooms *obj = [_o_rooms.o_data objectAtIndex:_selectIndex];
    ZhiboListCellTableViewCell *cell = (ZhiboListCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    ZhiboModel_getrooms_data *data = obj.o_rooms [indexPath.row];
    if (cell == nil) {
        cell = [ZhiboListCellTableViewCell liveEndView];
        cell.width = _o_tableView.width;
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell fillcellWithName:data.title andImageUrl:data.thumbnail andNum:data.seenum];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZhiboModel_getrooms *obj = [_o_rooms.o_data objectAtIndex:_selectIndex];
     ZhiboModel_getrooms_data *data = obj.o_rooms [indexPath.row];
    [ZhiboCommon setAnchoruid: [NSString stringWithFormat:@"%d", data.anchorUid]];
    if (_o_block) {
        _o_block(data.thumbnail,data.title);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 89;
}
@end
