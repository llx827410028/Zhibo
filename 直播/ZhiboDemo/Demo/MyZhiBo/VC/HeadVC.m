//
//  HeadVC.m
//  Demo
//
//  Created by ugamehome on 2016/10/13.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "HeadVC.h"
#import "ZhiBoVC.h"
#import "HeaderCell.h"
#import "UIView+ZUtils.h"
#import  <AVFoundation/AVFoundation.h>
#define colletionCell 3  //设置具体几列
#define Bnt_height 62


@interface HeadVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIWebView *o_web_room;
@property (weak, nonatomic) IBOutlet UIWebView *o_web_palyer;
@property (weak, nonatomic) IBOutlet UIWebView *o_web_weapon;
@property (weak, nonatomic) IBOutlet UIButton *o_btn_one;
@property (weak, nonatomic) IBOutlet UIButton *o_btn_two;
@property (weak, nonatomic) IBOutlet UIButton *o_btn_three;


@property (nonatomic,strong)NSMutableArray *o_zhiboPageData ;
@property (nonatomic,strong)NSMutableArray *o_webs;
@property (nonatomic,strong)NSMutableArray *o_btn_array;

@property (nonatomic,weak)IBOutlet UICollectionView *o_collectionView;


@property (nonatomic)long o_selectIndex;//bnt 按钮选择
@property (nonatomic)BOOL isZhibo;
@property (nonatomic,assign)int o_loadPageTime;
@property (nonatomic)BOOL isjiaz;
@end


@implementation HeadVC

- (instancetype)initWithPlayId:(NSString *)playid andPlayName:(NSString *)playName andServerid:(NSString *)serverid andSecretKey:(NSString *)secretKey andLevel:(NSString *)level{
    if ([super self]) {
        [ZhiboCommon setPlayId:playid];
        [ZhiboCommon setPlayName:playName];
        [ZhiboCommon setServerId:serverid];
        [ZhiboCommon setSecret_key:secretKey];
        [ZhiboCommon setLevel:level];
    }
    return self;
}
//固定 只能横屏
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self initData];
    [self setupwebView];
    [self setupbnt];
}

- (void)initData{
    _isjiaz = NO;
     _o_loadPageTime = 1;
    _o_zhiboPageData = [[NSMutableArray alloc]init];
    
    _o_webs = [[NSMutableArray alloc]initWithObjects:_o_web_room,_o_web_palyer ,_o_web_weapon,nil];
    _o_btn_array  = [[NSMutableArray alloc]initWithObjects:_o_btn_one, _o_btn_two,_o_btn_three,nil];
}

- (void)setupbnt{
    [_o_btn_one setBackgroundImage:[UIImage imageNamed:@"webview_btn_check"] forState:UIControlStateNormal];
    if (llx_screenHeight == 320) {
        [_o_btn_one.titleLabel setFont:[UIFont systemFontOfSize:9]];
        [_o_btn_two.titleLabel setFont:[UIFont systemFontOfSize:9]];
        [_o_btn_three.titleLabel setFont:[UIFont systemFontOfSize:9]];
    }else if(llx_screenHeight == 375){
        [_o_btn_one.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_o_btn_two.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_o_btn_three.titleLabel setFont:[UIFont systemFontOfSize:11]];
    }else if(llx_screenHeight == 414){
        [_o_btn_one.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_o_btn_two.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_o_btn_three.titleLabel setFont:[UIFont systemFontOfSize:13]];
    }
}

- (void)setupwebView{
    [self  createCollectionView];
    _o_web_room.scalesPageToFit = YES;
    _o_web_palyer.scalesPageToFit = YES;
    _o_web_weapon.scalesPageToFit = YES;
    
    
    _o_web_room.backgroundColor = [UIColor clearColor];
    _o_web_room.opaque = NO;

    [_o_web_room setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_zhibo_bg.jpg"]]];
    
    _o_web_palyer.backgroundColor = [UIColor clearColor];
    _o_web_palyer.opaque = NO;
    [_o_web_palyer setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_zhibo_bg.jpg"]]];
    _o_web_weapon.backgroundColor = [UIColor clearColor];
    _o_web_weapon.opaque = NO;
    [_o_web_weapon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_zhibo_bg.jpg"]]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: YES];
    [self getPage1];
}

//贴附在游戏
- (void)addZhiboView{
    [[ZhiboCommon getCurrentVC]presentViewController:self animated:YES completion:^{
        [ZhiboCommon setShowZhibo:@"1"];
    }];
    [self performSelector:@selector(closeunity) withObject:self afterDelay:0.5];
}
- (void)closeunity{
    if (_o_block) {
        _o_block(true);
    }
}


- (IBAction)hidezhiboView:(id)sender{
    if (_o_block) {
        _o_block(false);
    }
    [[ZhiboCommon getCurrentVC]dismissViewControllerAnimated:YES completion:^{
        [ZhiboCommon setShowZhibo:@"0"];
    }];
}

-  (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //设置横向还是竖向
    //按比例来 确定位置
    [_o_collectionView setCollectionViewLayout:flowLayout];
    
    _o_collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_zhibo_bg.jpg"]];
    NSString * cellIdentifier = NSStringFromClass([HeaderCell class]);
    UINib * cellNib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_o_collectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//0 为直播房间 1为比赛视频 2为武器展示
- (IBAction)zhiboSelect:(id)sender {
    if (![_o_zhiboPageData count]) {
        return;
    }
    UIButton *bnt = (UIButton *)sender;

    if (_o_selectIndex != (bnt.tag - BTN_TAG)) {
        UIButton *oldBnt = [_o_btn_array objectAtIndex:_o_selectIndex];
        oldBnt.selected = NO;
        bnt.selected = YES;
        [bnt setBackgroundImage:[UIImage imageNamed:@"webview_btn_check"] forState:UIControlStateNormal];
        [oldBnt setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        UIWebView *webView = [_o_webs objectAtIndex:_o_selectIndex];
        
        if (_o_selectIndex == 0 && _isZhibo) {
            _o_collectionView.hidden = YES;
        }else{
            webView.hidden = YES;
        }
        
        UIWebView * selectWebView = [_o_webs objectAtIndex:bnt.tag - BTN_TAG];
        if ((bnt.tag - BTN_TAG) == 0 && _isZhibo) {
            _o_collectionView.hidden = NO;
        }else{
            selectWebView.hidden = NO;
        }
        _o_selectIndex = bnt.tag - BTN_TAG;
    }
}

#pragma mark -- network
//获取页面1信息
- (void)getPage1{
    NSString *timestamp = [VTTool getTimeSp];
    NSDictionary *dic =  @{
                                    @"playerid":[ZhiboCommon getPlayId],
                                    @"serverid":[ZhiboCommon getServerId],
                                    @"timestamp":timestamp,
                                    @"sign":[VTTool md5:[NSString stringWithFormat:@"%@%@%@",[ZhiboCommon getPlayId],timestamp,[ZhiboCommon getSecret_key]]],
                                    };
    
    
    MBProgressHUD *hud = nil;
    if (!_isjiaz) {
       hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    
    
    
    @WeakObj(_o_zhiboPageData)
    @WeakObj(self)
    
    
    [[ZhiboRequests shareInstance]postZhiboData:dic andUrl:@"/getpage1.php" andBackObjName:@"ZhiboModel_GetPage" withSuccessBlock:^(id backId) {
        
        if ([ZhiboCommon requestStatusbyReult:[[backId objectForKey:@"result"]intValue]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!_isjiaz){
                    _isjiaz = YES;
                    [hud hide:YES];
                }
            });
            [_o_zhiboPageDataWeak removeAllObjects];
            
            NSArray *data = [backId objectForKey:@"data"];
            for (NSDictionary *dic in data) {
                ZhiboModel_GetPage *getPage = [[ZhiboModel_GetPage alloc]init];
                [getPage getModelFormJson:dic];
                [_o_zhiboPageDataWeak addObject:getPage];
            }
            
            //检查直播房间是否在线直播
            if ([data count]) {
                NSDictionary *dic = data[0];
                NSMutableArray *o_zhiboArr = [[NSMutableArray alloc]init];
                if ([dic [@"data"] count]) {
                    
                    for (NSDictionary *dicObj in dic [@"data"]) {
                        ZhiboModel_GetPage_zhibos *getPage_zhibo = [[ZhiboModel_GetPage_zhibos alloc]init];
                        [getPage_zhibo getModelFormJson:dicObj];
                        [o_zhiboArr addObject:getPage_zhibo];
                    }
                }
                ZhiboModel_GetPage *obj = _o_zhiboPageDataWeak[0];
                obj.o_zhibos = o_zhiboArr;
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                for(int i =0;i<[data count];i++){
                    ZhiboModel_GetPage *page =_o_zhiboPageDataWeak[i];
                    UIButton *bnt = _o_btn_array[i];
                    bnt.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                     [bnt setTitle:page.title forState:UIControlStateNormal];
                }
            });
            
            
            
            //被选择的选项先加载
            ZhiboModel_GetPage *obj = _o_zhiboPageDataWeak[_o_selectIndex];
            UIWebView *webView = _o_webs[_o_selectIndex];
            NSURL* url = [NSURL URLWithString:obj.url];//创建URL
            NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
            if (_o_selectIndex) {
                [webView loadRequest:request];
            }else{
                if ([obj.o_zhibos count]) {
                    _isZhibo = YES;
                    webView.hidden = YES;
                    _o_collectionView.hidden = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_o_collectionView reloadData];
                    });
                }else{
                    _isZhibo = NO;
                    _o_collectionView.hidden = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [webView loadRequest:request];
                    });
                }
            }
            
            //加载其他没有选择的
            for (int i = 0; i < [_o_zhiboPageDataWeak count]; i++) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // 耗时的操作
                    if (i != _o_selectIndex) {
                        ZhiboModel_GetPage *obj = _o_zhiboPageDataWeak[i];
                        NSURL* url = [NSURL URLWithString:obj.url];//创建URL
                        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
                        UIWebView *webView = _o_webs[i];
                        if (i == 0) {
                            if ([obj.o_zhibos count]) {
                                _isZhibo = YES;
                                _o_collectionView.hidden = NO;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [_o_collectionView reloadData];
                                });
                                
                            }else{
                                _isZhibo = NO;
                                _o_collectionView.hidden = YES;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [webView loadRequest:request];
                                });
                            }
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [webView loadRequest:request];
                            });
                        }
                    }
                });
            }
        }else{
            if (backId[@"msg"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                     [ZhiboCommon mpProgressWithView:selfWeak.view andString:backId[@"msg"]];
                });
            }
        }
           } withFaildBlock:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!_isjiaz){
                [hud hide:YES];
            }
            //加载失败  重新加载  只能加载3次
            if (_o_loadPageTime < 3) {
                 [selfWeak  getPage1];
                _o_loadPageTime ++;
            }else{
                [ZhiboCommon mpProgressWithView:selfWeak.view andString:[ZhiboCommon getStringBykey:@"加载失败"]];
            }
        });
    }];
}



#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_o_zhiboPageData count]) {
        ZhiboModel_GetPage *zhiboObj = [_o_zhiboPageData objectAtIndex:0];
        return [zhiboObj.o_zhibos count];
    }else{
        return 0;
    }
    
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"HeaderCell";
    HeaderCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    ZhiboModel_GetPage *zhiboObj = [_o_zhiboPageData objectAtIndex:0];
    ZhiboModel_GetPage_zhibos *zhibo = zhiboObj.o_zhibos[indexPath.row];
    [cell fillCollectionViewCellWithImgUrl:zhibo.thumbnail andText:zhibo.anchorNickname andName:zhibo.title andNum:FORMAT(@"%d", zhibo.seenum)];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //290 215
    return  CGSizeMake((_o_collectionView.width-48)/colletionCell, ((_o_collectionView.width-48)/colletionCell)*0.74);  //设置cell宽高
}

//定义每个UICollectionView 的 margin
#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZhiboModel_GetPage *zhiboObj = [_o_zhiboPageData objectAtIndex:0];
    ZhiboModel_GetPage_zhibos *zhibo = zhiboObj.o_zhibos[indexPath.row];
    [ZhiboCommon setAnchoruid: [NSString stringWithFormat:@"%d", zhibo.anchorUid]];
    
    ZhiBoVC *VC = [[ZhiBoVC alloc] initWithImageUrl:zhibo.thumbnail andTitle:zhibo.title];
    [self presentViewController:VC animated:YES completion:^{
        
    }];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
@end
