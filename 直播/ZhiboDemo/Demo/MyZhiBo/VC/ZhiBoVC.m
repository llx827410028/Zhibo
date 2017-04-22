//
//  ZhiBoVC.m
//  Demo
//
//  Created by ugamehome on 2016/10/19.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "ZhiBoVC.h"
#import <AVFoundation/AVFoundation.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "BarrageRenderer.h"
#import "NSSafeObject.h"
#import "ZhiBoBottomToolView.h"
#import "ZhiBoRankingView.h"
#import "ZhiBoListView.h"
#import "ZhiBoAboveView.h"
#import "ZhiBoSetProgress.h"
#import "ZhiBoGiftView.h"
#import "PresentView.h"
#import "GiftModel.h"
#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "GSPChatMessage.h"
#import "UIView+ZUtils.h"


#define GiftName @"name"
#define GiftWidth @"width"
#define GiftHeight @"Height"
#define GiftNum @"num"
#define GiftTextName @"textName"
#define GiftId @"giftId"
#define GiftShowType @"showType"

@interface ZhiBoVC ()<UIWebViewDelegate>
{
    //弹幕
    BarrageRenderer * _renderer;
    //弹幕定时发射
    NSTimer * _timer;
    NSTimer *_loadTimer;//定时加载弹幕 和  用户信息
    NSInteger _index;
    //弹幕各个属性的配置
    CGFloat zhiboFontSize;
    float zhiboAlpha;
    int walkSide;
    //弹幕显示数量
    int o_dmSelectIndex;
    
    NSMutableDictionary *o_giftDicg;
}

@property (nonatomic,strong)NSString *o_imageUrl;//占位图片 url
@property (nonatomic,strong)NSString *o_title;//主播 title

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *o_lay_bottom_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *o_lay_above_top;
@property (weak, nonatomic) IBOutlet UIView *o_view_gift;
@property (weak, nonatomic) IBOutlet UIView *o_view_Lock;
@property (weak, nonatomic) IBOutlet UIButton *o_btn_unlock;
@property (weak, nonatomic) IBOutlet ZhiBoAboveView *o_above_view;
@property (weak, nonatomic) IBOutlet ZhiBoBottomToolView *o_bottom_view;

@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;
@property (nonatomic,strong)UIActivityIndicatorView *activity;
/** 直播开始前的占位图片 */
@property(nonatomic, weak) UIImageView *placeHolderView;
@property (weak, nonatomic) UIView *PlayerView;
@property (atomic, retain) id <IJKMediaPlayback> player;
@property (nonatomic,strong)UIWebView *o_webView;
/**<主播排行view */
@property (nonatomic,retain)ZhiBoRankingView *o_rankingView;
/**< 所有直播的房间 */
@property (nonatomic,retain)ZhiBoListView *o_listView;
/**< setView */
@property (nonatomic,retain)ZhiBoSetProgress *o_setGrogress;
/**< 顶部view */
@property (nonatomic,retain)ZhiBoGiftView *o_giftView;

//视图显示 与隐藏控制
@property (nonatomic)BOOL isLock;//是否锁住界面弹出
@property (nonatomic)BOOL isShowKeyb;
@property (nonatomic)BOOL isLoadOtherPlayer;
@property (nonatomic)BOOL isLoadDanmuInfo;
@property (nonatomic)BOOL isStartGetDanmuTimer;

//获取房间信息
@property(nonatomic,strong)ZhiboModel_Getroominfo *o_roomInfo;
//礼物弹幕 控制
@property (nonatomic,strong)GSPChatMessage *o_msg;//礼物对象
@property (strong, nonatomic) NSMutableArray *o_danmuArr;
@property (strong, nonatomic) NSMutableArray *o_giftArr;
@property (strong,nonatomic)NSMutableDictionary *o_danmuDic;
@property (strong,nonatomic)NSMutableDictionary *o_giftDic;
@property(nonatomic,strong)ZhiboModel_danmaku *o_selfSendDanmaku;
@property(nonatomic,strong)ZhiboModel_gift *o_selfSendGift;

@property (nonatomic)BOOL isFaceUrl;

@end

@implementation ZhiBoVC

-(id)initWithImageUrl:(NSString *)imageUrl andTitle:(NSString *)title{
    if ([super self]) {
        _o_imageUrl = imageUrl;
        _o_title = title;
    }
    return self;
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}


- (void)initBarrageRenderer
{
    _renderer = [[BarrageRenderer alloc]init];
    [self.view addSubview:_renderer.view];
    _renderer.canvasMargin = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.view sendSubviewToBack:_renderer.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self setupView];
    [self initBarrageRenderer];
    [self loadPlayer];
}

-(void)setupView{
    _o_view_gift.layer.cornerRadius = 5;
    _o_view_gift.layer.masksToBounds= YES;
    
    _o_view_Lock.layer.cornerRadius = 5;
    _o_view_Lock.layer.masksToBounds = YES;
    self.o_above_view.title = _o_title;
    self.o_above_view.o_zhiBoVC = self;
    self.o_bottom_view.o_zhiBoVC = self;
    [self setupAboveView];
    [self setupBottomView];
}

- (void)initData{
    _index = 0;
    _isLoadOtherPlayer = YES;
    zhiboAlpha = 1;
    if (IS_IPAD) {
        zhiboFontSize = 20;
    }else{
        zhiboFontSize = 15;
    }
    
    walkSide = BarrageWalkSideRight;
    _isStartGetDanmuTimer = NO;
    _isLoadDanmuInfo = NO;
    //存储 礼物已经弹幕
    _o_danmuArr = [[NSMutableArray alloc]init];
    _o_giftArr = [[NSMutableArray alloc]init];
    _o_giftDic = [[NSMutableDictionary alloc]init];
    _o_danmuDic = [[NSMutableDictionary alloc]init];
    
    [self initGiftText];
}

- (void)loadPlayer{
    if (_player) {
        //视频
        [_player pause];
        [_player stop];
    }
    
    if (_renderer) {
        //视频
        //弹幕关闭
        [_renderer stop];
        [_timer invalidate];
    }
    
    self.o_above_view.title = _o_title;
    if (_isLoadOtherPlayer) {
        [ZhiboCommon downLoadImageWithURLString:_o_imageUrl andBlock:^(UIImage *image) {
            self.placeHolderView.image = image;
        }];
        _isLoadOtherPlayer = NO;
         [self.view bringSubviewToFront:self.placeHolderView];
        [self bringSubView];
    }
    

    [self getroominfo];
}



- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer {
    if (_isShowKeyb) {
        [_o_bottom_view hideKeyBoard];
        return;
    }
    
    if (!_isLock) {
        if (_o_above_view.y == 0) {
            [self  showOrHideBottomandAboveViewWithY:-_o_above_view.height andView:_o_above_view];
            [self  showOrHideBottomandAboveViewWithY:-_o_bottom_view.height andView:_o_bottom_view];
        }else{
            [self  showOrHideBottomandAboveViewWithY:0 andView:_o_above_view];
            [self  showOrHideBottomandAboveViewWithY:0 andView:_o_bottom_view];
        }
        _o_view_gift.hidden = !_o_view_gift.hidden;
    }

    if(_o_rankingView.isViewShow){
        [self showOrHideView:_o_rankingView];
        _o_rankingView.isViewShow = NO;
    }
    
    if (_o_setGrogress.isViewShow) {
         [self showOrHideView:_o_setGrogress];
        _o_setGrogress.isViewShow = NO;
    }
    
    
    if(_o_listView.isViewShow){
        [self showOrHideView:_o_listView];
        _o_listView.isViewShow = NO;
    }
    
    if (_o_giftView.isViewShow) {
         [self showOrHideView:_o_giftView];
        _o_giftView.isViewShow = NO;
    }
    
    _o_view_Lock.hidden = !_o_view_Lock.hidden;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSSafeObject * safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
    NSSafeObject * loadsafeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(loadTime)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
    _loadTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:loadsafeObj selector:@selector(excute) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [_player pause];
    [_player stop];
    [_renderer stop];
    [_timer invalidate];
    _timer = nil;
    [_loadTimer invalidate];
    _loadTimer = nil;
}

- (void)loadTime{
    [self getDanmaku];
    [self getUserInfo];
}

#pragma  mark --属性赋值

- (void)setupBottomView{
    //自己发送的弹幕
    @WeakObj(self)
    @WeakObj(_o_view_gift)
    @WeakObj(_o_view_Lock)

    _o_bottom_view.o_noticeDanmuBlock = ^(NSString *o_danmu){
        _o_selfSendDanmaku = [[ZhiboModel_danmaku alloc]init];
        _o_selfSendDanmaku.playerid = [[ZhiboCommon getPlayId]intValue];
        _o_selfSendDanmaku.playername = [ZhiboCommon getPlayName];
        _o_selfSendDanmaku.danmakutext = o_danmu;

        if (!_isLoadDanmuInfo) {
            [selfWeak getDanmaku];
            _isStartGetDanmuTimer = YES;
        }
    };
    
    _o_bottom_view.showBottomBntBlock = ^(BottomType type,BOOL isDm){
        if (type == BottomType_RankView) {
            _o_view_LockWeak.hidden = !_o_view_LockWeak.hidden;
            _o_view_giftWeak.hidden = !_o_view_giftWeak.hidden;
            [selfWeak showOrHideBottomAndAboveView];
            _o_rankingView.isViewShow = YES;
            [selfWeak showOrHideView:_o_rankingView];
            [_o_rankingView getRankinfo];
        }else if(type == BottomType_ListView ){
            _o_view_LockWeak.hidden = !_o_view_LockWeak.hidden;
            _o_view_giftWeak.hidden = !_o_view_giftWeak.hidden;
            [selfWeak showOrHideBottomAndAboveView];
            _o_listView.isViewShow = YES;
            [selfWeak showOrHideView:_o_listView];
            [_o_listView getZhiboListinfo];
        }else if(type == BottomType_Refresh){
            [selfWeak loadPlayer];
        }else if(type == BottomType_DmStatus){
            if(isDm){
                [ZhiboCommon mpProgressWithView:selfWeak.view andString:[ZhiboCommon getStringBykey:@"弹幕已关闭"]];
                [_timer setFireDate:[NSDate distantFuture]];
                [_renderer stop];
            }else{
                 [ZhiboCommon mpProgressWithView:selfWeak.view andString:[ZhiboCommon getStringBykey:@"弹幕已开启"]];
                [_timer setFireDate:[NSDate distantPast]];
                [_renderer start];
            }
        }
    };
}

- (void)setupAboveView{
    __weak ZhiBoVC * weakSelf= self;
    _o_above_view.o_clickAboveBtnBlock = ^(BoAboveType type){
        if (type == BoAboveType_Back) {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                
            }];
        }else if(type == BoAboveType_Set){
            _o_view_Lock.hidden = !_o_view_Lock.hidden;
            _o_view_gift.hidden = !_o_view_gift.hidden;
            [weakSelf showOrHideBottomAndAboveView];
            _o_setGrogress.isViewShow = YES;
            [self showOrHideView:_o_setGrogress];
        }
    };
}


- (ZhiBoGiftView *)o_giftView{
    if (!_o_giftView) {
        int viewIndex = 0;
        if (IS_IPAD) {
            viewIndex = 2;
        }
        ZhiBoGiftView *view = [VTTool loadViewFromNib:@"ZhiBoGiftView" owner:nil atIndex:viewIndex];
        if (IS_IPAD) {
            view.y = llx_screenHeight;
            view.width = llx_screenWidth;
            view.heightOrWidthScale = view.height;
        }else{
            view.x = llx_screenWidth;
            
            view.heightOrWidthScale = llx_screenHeight * 0.66;;
        }
         __weak ZhiBoVC * weakSelf= self;
         //自己发送的礼物
        view.o_sendGiftBlock = ^(int num,int giftId){
            if (_o_giftView.isViewShow) {
                [weakSelf showOrHideView:_o_giftView];
                _o_giftView.isViewShow = NO;
            }
            ZhiboModel_gift *a = [[ZhiboModel_gift alloc]init];
            a.playerid = [[ZhiboCommon getPlayId]intValue];
            a.playername = [ZhiboCommon getPlayName];
            a.giftnum = num;
            a.giftid = giftId;
            _o_selfSendGift = a;
            if (!_isLoadDanmuInfo) {
                [weakSelf getDanmaku];
                _isStartGetDanmuTimer = YES;
            }
        };
        
        [self.view addSubview:view];
        [view getGift];
        view.isHide = YES;
        view.o_zhiBoVC = self;
        _o_giftView = view;
    }
    return _o_giftView;
}

- (ZhiBoSetProgress *)o_setGrogress{
    if (!_o_setGrogress) {
        ZhiBoSetProgress *view = [ZhiBoSetProgress liveEndView];
       [view setWidthScale];
        [self.view addSubview:view];
        view.isHide = YES;
        view.o_block = ^(SetProgressWalkType type){
            if (type == SetProgressWalkType_All) {
                walkSide = BarrageWalkSideDefault;
            }else if(type == SetProgressWalkType_Top){
                 walkSide = BarrageWalkSideLeft;
            }else if(type == SetProgressWalkType_Bottom){
                 walkSide = BarrageWalkSideRight;
            }
        };
        view.o_adjustBlock = ^(int type,int value){
            if (type == 1) {
                //调节弹幕透明度
                float   y =  value;
                float   x =  100.00;
                //调节弹幕透明度
                zhiboAlpha = y/x;
            }else{
                //调节弹幕文字大小
                if (IS_IPAD) {
                    zhiboFontSize = (20 + value/5);
                }else{
                    zhiboFontSize = (15 + value/10);
                }
                
            }
        };
        _o_setGrogress = view;
    }
    return _o_setGrogress;
}

- (ZhiBoListView *)o_listView{
    if (!_o_listView) {
        ZhiBoListView *view = [ZhiBoListView liveEndView];
        view.heightOrWidthScale = 230;
        view.x = llx_screenWidth;
        view.width = 230;
        view.isHide = YES;
        @WeakObj(self)
        view.o_block = ^(NSString *imageStr,NSString *title){
            _o_imageUrl = imageStr;
            _o_title = title;
            _isLoadOtherPlayer = YES;
            [selfWeak handleSingleTapFrom:nil];
            [selfWeak loadPlayer];
        };
        [self.view addSubview:view];
        _o_listView = view;
    }
    return _o_listView;
}

- (ZhiBoRankingView *)o_rankingView{
    if (!_o_rankingView) {
        ZhiBoRankingView *view = [ZhiBoRankingView liveEndView];
        view.isHide = YES;
        [view setWidthScale];
        [self.view addSubview:view];
        _o_rankingView = view;
    }
    return _o_rankingView;
}

#pragma  mark --showorhideview

- (void)showOrHideView:(ZhiBoBaseView*)view{
    [view ShowOrHide];
}

- (void)showOrHideBottomandAboveViewWithY:(CGFloat)y andView:(ZhiBoBaseView*)view{
    [UIView animateWithDuration:0.3 animations:^{
        if (view == _o_above_view) {
            _o_lay_above_top.constant = y;
        }else{
            _o_lay_bottom_bottom.constant = y;
        }
    } completion:^(BOOL finished) {
    }];
}

- (void)showOrHideBottomAndAboveView{
    if (_isShowKeyb) {
        [_o_bottom_view hideKeyBoard];
    }
    [self  showOrHideBottomandAboveViewWithY:-_o_above_view.height andView:_o_above_view];
    [self  showOrHideBottomandAboveViewWithY:-_o_bottom_view.height andView:_o_bottom_view];
}


#pragma mark --弹幕描述符生产方法
- (void)autoSendBarrage
{
    if (o_dmSelectIndex ==[_o_danmuArr count]) {
        [_timer setFireDate:[NSDate distantFuture]];
        return;
    }
    NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
    NSLog(@"当前屏幕弹幕数量: %ld",(long)spriteNumber);
    if (spriteNumber <= 10) { // 用来演示如何限制屏幕上的弹幕量
        [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L side:walkSide andFontSzie:zhiboFontSize andAlpha:zhiboAlpha]];
    }
}

/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(BarrageWalkDirection)direction side:(BarrageWalkSide)side  andFontSzie:(CGFloat)size andAlpha:(CGFloat)alpha
{
    ZhiboModel_danmaku *obj = [_o_danmuArr objectAtIndex:o_dmSelectIndex];
    o_dmSelectIndex ++;
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = obj.danmakutext;
    descriptor.params[@"textColor"] = [UIColor whiteColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"side"] = @(side);
    descriptor.params[@"showAlpha"] = @(alpha);
    descriptor.params[@"fontSize"] = @(size);
    descriptor.params[@"clickAction"] = ^{

    };
    return descriptor;
}

#pragma mark --直播前的占位图片
//直播前的占位图片
- (UIImageView *)placeHolderView{
    if (_placeHolderView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, llx_screenWidth, llx_screenHeight);
        [self.view addSubview:imageView];
        _placeHolderView = imageView;
        // 强制布局
        [_placeHolderView layoutIfNeeded];
    }
    return _placeHolderView;
}

#pragma mark --其他按钮
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//1为 锁 2为 礼物
- (IBAction)zhiboClickBnt:(UIButton *)sender{
    if ( (sender.tag - BTN_TAG) == 1) {
        _isLock = !_isLock;
        [_o_btn_unlock setSelected:_isLock];
        [self handleSingleTapFrom:nil];
    }else{
        _o_view_Lock.hidden = !_o_view_Lock.hidden;
        _o_view_gift.hidden = !_o_view_gift.hidden;
        [self showOrHideBottomAndAboveView];
        _o_giftView.isViewShow = YES;
        [self showOrHideView:_o_giftView];
        //礼物
    }
}

#pragma mark --network
/**
 *   获取房间信息
 */
- (void)getroominfo{
    NSString *timestamp = [VTTool getTimeSp];
    NSDictionary *dic =  @{
                           @"playerid":[ZhiboCommon getPlayId],
                           @"serverid":[ZhiboCommon getServerId],
                           @"timestamp":timestamp,
                           @"sign":[VTTool md5:[NSString stringWithFormat:@"%@%@%@%@",[ZhiboCommon getPlayId],[ZhiboCommon getAnchoruid],timestamp,[ZhiboCommon getSecret_key]]],
                           @"anchorUid":[ZhiboCommon getAnchoruid],
                           };
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    @WeakObj(hud)
    @WeakObj(self)
    
    [[ZhiboRequests shareInstance]postZhiboData:dic andUrl:@"/getroominfo.php" andBackObjName:@"getroominfo" withSuccessBlock:^(id backId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudWeak hide:YES];
        });
        if([ZhiboCommon requestStatusbyReult:[backId[@"result"]intValue]]){
        }else{
            return;
        }
       _o_roomInfo = [[ZhiboModel_Getroominfo alloc]init];
        [_o_roomInfo getModelFormJson:backId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           [selfWeak zhiBoIJKFFMovieWithPlayUrl:_o_roomInfo.liveurl andCmSWat:_o_roomInfo.cmSWat];
            [selfWeak getDanmaku];
        });
        } withFaildBlock:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudWeak hide:YES];
        });
    }];
}

/**
 *  获取弹幕
 */
- (void)getDanmaku{
    NSString *timestamp = [VTTool getTimeSp];
    NSDictionary *dic =  @{
                           @"playerid":[ZhiboCommon getPlayId],
                           @"serverid":[ZhiboCommon getServerId],
                           @"timestamp":timestamp,
                           @"sign":[VTTool md5:[NSString stringWithFormat:@"%@%@%@%@",[ZhiboCommon getPlayId],[ZhiboCommon getAnchoruid],timestamp,[ZhiboCommon getSecret_key]]],
                           @"anchorUid":[ZhiboCommon getAnchoruid],
                           @"number":@"100",
                           @"second":@"3",
                           };
    __weak ZhiBoVC * weakSelf= self;
    _isLoadDanmuInfo = YES;
    if (_isStartGetDanmuTimer) {
//        [_loadTimer setFireDate:[NSDate distantPast]];
        _isStartGetDanmuTimer = NO;
    }
    
    
    @WeakObj(_o_danmuArr)
    @WeakObj(_o_selfSendGift)
    @WeakObj(_o_giftArr)
    @WeakObj(_timer)
    @WeakObj(self)
    
    [[ZhiboRequests shareInstance]postZhiboData:dic andUrl:@"/getDanmaku.php" andBackObjName:@"getDanmaku" withSuccessBlock:^(id backId) {
        if([ZhiboCommon requestStatusbyReult:[backId[@"result"]intValue]]){
        }else{
            if (backId[@"msg"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ZhiboCommon mpProgressWithView:selfWeak.view andString:backId[@"msg"]];
                });
            }
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            [_o_danmuArrWeak removeAllObjects];
            [_o_giftArrWeak removeAllObjects];
            
            if (_o_selfSendGiftWeak) {
                [_o_giftArrWeak addObject:_o_selfSendGift];
                _o_selfSendGift = nil;
            }
            
            if (_o_selfSendDanmaku) {
                [_o_danmuArrWeak addObject:_o_selfSendDanmaku];
                _o_selfSendDanmaku = nil;
            }
            
            for (NSDictionary *dicObj in backId[@"danmaku"]) {
                ZhiboModel_danmaku *danmakuObj = [[ZhiboModel_danmaku alloc]init];
                [danmakuObj getModelFormJson:dicObj];
                //查重
                if ([_o_danmuDic objectForKey:FORMAT(@"%d",danmakuObj.id)]) {
                }else{
                    [_o_danmuArrWeak addObject:danmakuObj];
                }
            }
            
            for (NSDictionary *dicObj in backId[@"gift"]) {
                ZhiboModel_gift *gift = [[ZhiboModel_gift alloc]init];
                [gift getModelFormJson:dicObj];
                [_o_giftArrWeak addObject:gift];
                //查重
                if ([_o_giftDic objectForKey:FORMAT(@"%d",gift.id)]) {
                }else{
                    [_o_giftArrWeak addObject:gift];
                }
            }
            [_o_giftDic removeAllObjects];
            [_o_danmuDic removeAllObjects];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
#warning 弹幕入口
                //            [weakSelf giftTest];//假数据
                if ([_o_danmuArrWeak count]) {
                    [_timerWeak setFireDate:[NSDate distantPast]];
                }
                
                o_dmSelectIndex =0;
                if ([_o_giftArrWeak count]) {
                    [weakSelf sendAllGift];
                }
                _isLoadDanmuInfo = NO;
            });
            
            for (NSDictionary *dicObj in backId[@"danmaku"]) {
                ZhiboModel_danmaku *danmakuObj = [[ZhiboModel_danmaku alloc]init];
                [danmakuObj getModelFormJson:dicObj];
                [_o_danmuDic setObject:FORMAT(@"%d",danmakuObj.id) forKey:FORMAT(@"%d",danmakuObj.id)];
            }
            
            for (NSDictionary *dicObj in backId[@"gift"]) {
                ZhiboModel_gift *gift = [[ZhiboModel_gift alloc]init];
                [gift getModelFormJson:dicObj];
                [_o_giftDic setObject:FORMAT(@"%d",gift.id) forKey:FORMAT(@"%d",gift.id)];
            }
        });
        
    } withFaildBlock:^(NSError * error) {
         _isLoadDanmuInfo = NO;
    }];
}


/**
 *  获取用户信息
 */
- (void)getUserInfo{
    NSString *timestamp = [VTTool getTimeSp];
    NSDictionary *dic =  @{
                           @"playerid":[ZhiboCommon getPlayId],
                           @"serverid":[ZhiboCommon getServerId],
                           @"timestamp":timestamp,
                           @"sign":[VTTool md5:[NSString stringWithFormat:@"%@%@%@",[ZhiboCommon getPlayId],timestamp,[ZhiboCommon getSecret_key]]],
                           };
    [[ZhiboRequests shareInstance]postZhiboData:dic andUrl:@"/getuserinfo.php" andBackObjName:@"getuserinfo" withSuccessBlock:^(id backId) {
        if([ZhiboCommon requestStatusbyReult:[backId[@"result"]intValue]]){
        }else{
            return;
        }
        [ZhiboCommon setDiamondnum:backId[@"diamondnum"]];
        [ZhiboCommon setGoldnum:backId[@"goldnum"]];
        [_o_giftView initgoldandkc];
    } withFaildBlock:^(NSError * error) {
    }];
}



//播放
- (void)zhiBoIJKFFMovieWithPlayUrl:(NSString *)playUrl andCmSWat:(int)type{
    if ([playUrl rangeOfString:@"www.youtube.com"].location == NSNotFound) {
        _isFaceUrl = YES;
    }
    NSURL *url = [NSURL URLWithString:playUrl];
    NSLog(@"class name>> %@---playUrllog---》%@",NSStringFromClass([self class]),playUrl);
    UIView *displayView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.PlayerView = displayView;
    self.PlayerView.backgroundColor = [UIColor blackColor];
    if (type == 1) {
        [self.view addSubview:self.PlayerView];
        _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
        UIView *playerView = [self.player view];
        
        playerView.frame = self.PlayerView.bounds;
        playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [playerView addGestureRecognizer:singleRecognizer];
        [self.PlayerView insertSubview:playerView atIndex:1];
        [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
        [_player prepareToPlay];
        [self installMovieNotificationObservers];
    }else{
        
        NSURLRequest * _request = [[NSURLRequest alloc] initWithURL:url];
        
        if (!_o_webView) {
            UIWebView *webViews = [[UIWebView alloc] initWithFrame:CGRectZero];
            NSString *oldAgent = [webViews stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
            NSLog(@"old agent :%@", oldAgent);
            NSString *newAgent = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Safari/602.1.50";
            NSLog(@"new agent :%@", newAgent);
            //regist the new agent
            NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
            
            _o_webView = [[UIWebView alloc]initWithFrame:self.view.frame];
            _o_webView .allowsInlineMediaPlayback  =  YES ;
            _o_webView.mediaPlaybackAllowsAirPlay = YES;
            _o_webView.delegate = self;
            UITapGestureRecognizer* singleRecognizer;
            singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
            singleRecognizer.numberOfTapsRequired = 1; // 单击
            [_PlayerView addGestureRecognizer:singleRecognizer];
            [self.view addSubview:_o_webView];
            _PlayerView.backgroundColor = [UIColor clearColor];
//            [_o_webView insertSubview:_PlayerView atIndex:1];
        }
        [_o_webView loadRequest:_request];
    }
    
    [self bringSubView];
}

- (void)bringSubView{
    [self.view bringSubviewToFront:_o_above_view];
    [self.view bringSubviewToFront:self.o_rankingView];
    [self.view bringSubviewToFront:self.o_listView];
    [self.view bringSubviewToFront:_o_bottom_view];
    [self.view bringSubviewToFront:self.o_view_gift];
    [self.view bringSubviewToFront:self.o_view_Lock];
    [self.view bringSubviewToFront:self.o_setGrogress];
    [self.view bringSubviewToFront:_renderer.view];
    [self.view bringSubviewToFront:self.o_giftView];
    [_renderer start];
    [_timer setFireDate:[NSDate date]];
}


#pragma mark - 网页视频
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"%@",webView);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorCancelled) {
        NSLog(@"Canceled request: %@", webView.request.URL);
        return;
    }
    else if ([error.domain isEqualToString:@"WebKitErrorDomain"] && (error.code == 101 || error.code == 204)) {
        NSLog(@"ignore: %@", error);
        return;
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(!_isFaceUrl){
        NSString *js = @"javascript: var v = document.getElementsByClassName('video-stream html5-main-video'); v[0].click();v[0].setAttribute('Playsinline','Playsinline');";
        [webView stringByEvaluatingJavaScriptFromString:js];
    }else{
        NSString *js = @"javascript: var v = document.getElementsByClassName('_ox1'); v[0].play();v[0].setAttribute('Playsinline','Playsinline');var image = document.getElementsByClassName('_3fnx');image[0].style.display = 'none';";
//        [webView stringByEvaluatingJavaScriptFromString:js];
    }

}

#pragma mark --视频播放通知
#pragma Install Notifiacation

- (void)installMovieNotificationObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
}

- (void)removeMovieNotificationObservers {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
}


#pragma Selector func

- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    
    _placeHolderView.hidden = YES;
    
    switch (_player.playbackState) {
            
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark -- 键盘通知 方法

// 监听键盘的frame即将改变的时候调用
- (void)keyboardWillChange:(NSNotification *)note{
    // 获得键盘的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 修改底部约束
    _o_lay_bottom_bottom.constant = self.view.frame.size.height - frame.origin.y;
    if (!_o_lay_bottom_bottom.constant) {
        _o_view_gift.hidden = NO;
        _o_view_Lock.hidden = NO;
        _isShowKeyb = NO;
        [_o_bottom_view showTfbeginBnt];
    }else{
        _o_view_gift.hidden = YES;
        _o_view_Lock.hidden = YES;
        _isShowKeyb = YES;
    }
    // 执行动画
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        // 如果有需要,重新排版
        [self.view layoutIfNeeded];
    }];
}


#pragma mark -- 赠送礼物
- (void)giftTest{
    for (int i = 0; i< 20; i++) {
        ZhiboModel_danmaku *a = [[ZhiboModel_danmaku alloc]init];
        a.playerid = 1;
        a.playername = @"kabuda";
        a.danmakutext = [NSString stringWithFormat:@"弹幕弹幕弹幕%d",i];
        [_o_danmuArr addObject:a];
    }
    for (int i = 1; i< 7; i++) {
        ZhiboModel_gift *a = [[ZhiboModel_gift alloc]init];
        a.playerid = i;
        a.playername = @"我是谁";
        a.giftnum = 10;
        a.giftid = 100+i;
        [_o_giftArr addObject:a];
    }
}


- (void)sendAllGift{
    for (ZhiboModel_gift * obj in _o_giftArr) {
        _o_msg.senderName = obj.playername;
        _o_msg.senderChatID =[NSString stringWithFormat:@"%d",obj.playerid];
        NSDictionary * dic = [o_giftDicg objectForKey:FORMAT(@"%d",obj.giftid)];
        ZhiboModel_getGiftList *giftObj = [_o_giftView getGiftListWithTag:obj.giftid];
        UIImage *giftImg =[_o_giftView getGiftImageWithTag:obj.giftid];
    
        [self sendGiftWithWChatMessage:giftObj.name andSenderChatID:[NSString stringWithFormat:@"%d",obj.playerid] AndSenderName:obj.playername andSendImg:giftImg andReceiveImg:giftObj.iconItem andGiftNum:obj.giftnum andAnimDic:dic];
    }
}

- (void)sendGiftWithWChatMessage:(NSString *)msg andSenderChatID:(NSString *)senderChatID AndSenderName:(NSString *)senderName andSendImg:(UIImage*)sendImge andReceiveImg:(NSString*)receiveStr andGiftNum:(NSInteger)num andAnimDic:(NSDictionary *)dic{
    // 礼物模型
    GiftModel *giftModel = [[GiftModel alloc] init];
    giftModel.recviceImgStr =receiveStr;
    giftModel.name = senderName;
    giftModel.giftImage = sendImge;
    giftModel.giftName = msg;
    giftModel.giftCount = num;
    giftModel.o_dic = dic;
    
    AnimOperationManager *manager = [AnimOperationManager sharedManager];
    manager.parentView = self.view;
    // 用用户唯一标识 msg.senderChatID 存礼物信息,model 传入礼物模型
    
    
    CGFloat offy = 0;
    if (_o_above_view.y == 0) {
        offy = llx_screenHeight - _o_above_view.height - 110;
    }else{
        offy = llx_screenHeight - 110;
    }
    NSLog(@"kabuda%f,%f,%f",llx_screenHeight,_o_above_view.height,offy);
    [manager animWithUserID:senderChatID model:giftModel andViewY:offy finishedBlock:^(BOOL result) {
        
    }];
}

#pragma mark -- 礼物动画
- (void)initGiftText{
    o_giftDicg = [[NSMutableDictionary alloc]init];
    NSDictionary *aircraft = [NSDictionary dictionaryWithObjectsAndKeys:@"aircraft",GiftName,@"150",GiftWidth,@"66",GiftHeight,@"8",GiftNum,@"2",GiftId,@"1",GiftShowType, [ZhiboCommon getStringBykey:@"战斗机"],GiftTextName, nil];
    [o_giftDicg setObject:aircraft forKey:@"104"];
    NSDictionary *car = [NSDictionary dictionaryWithObjectsAndKeys:@"car",GiftName,@"180",GiftWidth,@"55",GiftHeight,@"8",GiftNum,@"2",GiftId,@"1",GiftShowType, [ZhiboCommon getStringBykey:@"跑车"],GiftTextName,nil];
   [o_giftDicg setObject:car forKey:@"106"];
    NSDictionary *castle = [NSDictionary dictionaryWithObjectsAndKeys:@"castle",GiftName,@"150",GiftWidth,@"116",GiftHeight,@"16",GiftNum,@"2",GiftId,@"3",GiftShowType, [ZhiboCommon getStringBykey:@"城堡"],GiftTextName,nil];
   [o_giftDicg setObject:castle forKey:@"107"];
    NSDictionary *rocket = [NSDictionary dictionaryWithObjectsAndKeys:@"rocket",GiftName,@"150",GiftWidth,@"141",GiftHeight,@"8",GiftNum,@"2",GiftId,@"2",GiftShowType, [ZhiboCommon getStringBykey:@"火箭"],GiftTextName,nil];
      [o_giftDicg setObject:rocket forKey:@"105"];
    NSDictionary *yacht = [NSDictionary dictionaryWithObjectsAndKeys:@"yacht",GiftName,@"150",GiftWidth,@"83",GiftHeight,@"8",GiftNum,@"2",GiftId,@"1",GiftShowType, [ZhiboCommon getStringBykey:@"游艇"],GiftTextName,nil];
    [o_giftDicg setObject:yacht forKey:@"108"];
}
@end
