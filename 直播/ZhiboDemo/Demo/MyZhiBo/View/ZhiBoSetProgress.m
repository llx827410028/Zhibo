//
//  ZhiBoSetProgress.m
//  Demo
//
//  Created by ugamehome on 2016/10/25.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "ZhiBoSetProgress.h"
#define SET_WIDTH 230

@interface ZhiBoSetProgress ()
@property (weak, nonatomic) IBOutlet UISlider *o_slider_one;
@property (weak, nonatomic) IBOutlet UISlider *o_slider_two;
@property (weak, nonatomic) IBOutlet UISlider *o_silder_three;
@property (weak, nonatomic) IBOutlet UIButton *o_btn_one;
@property (weak, nonatomic) IBOutlet UIButton *_o_btn_two;
@property (weak, nonatomic) IBOutlet UIButton *o_btn_three;
@property (weak, nonatomic) IBOutlet UILabel *o_oneName;
@property (weak, nonatomic) IBOutlet UILabel *o_twoName;
@property (weak, nonatomic) IBOutlet UILabel *o_threeName;
@property (weak, nonatomic) IBOutlet UILabel *o_transparent;
@property (weak, nonatomic) IBOutlet UILabel *o_size;
@property (weak, nonatomic) IBOutlet UILabel *o_bright;
@property (nonatomic,strong)NSMutableArray *o_arr;
@property (weak, nonatomic) IBOutlet UILabel *o_pointion;
@end

@implementation ZhiBoSetProgress

-(void)awakeFromNib{
    [super awakeFromNib];
    _o_arr =[ [NSMutableArray alloc]initWithObjects:_o_btn_one,__o_btn_two ,_o_btn_three,nil];
    _o_slider_one.value = 100;
    _o_slider_two.value = 20;
    _o_oneName.text = @"100%";
    _o_twoName.text = @"20%";
    //屏幕亮度
    float value = [UIScreen mainScreen].brightness;
    _o_silder_three.value =  value*100;
    _o_threeName.text = [NSString stringWithFormat:@"%d%%",(int)(value*100)];
    _o_transparent .text = [ZhiboCommon getStringBykey:@"弹幕透明度"];
    _o_size.text = [ZhiboCommon getStringBykey:@"弹幕字体大小"];
    _o_bright.text = [ZhiboCommon getStringBykey:@"屏幕亮度"];
    _o_pointion.text = [ZhiboCommon getStringBykey:@"弹幕位置"];
}

- (IBAction)changeDMlocation:(id)sender {
    UIButton *button = (UIButton *)sender;
    for (UIButton *btn in _o_arr) {
        if (btn == sender) {
            btn .selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    if(_o_block){
        _o_block((int)(button.tag - BTN_TAG));
    }
}

- (IBAction)changeValue:(UISlider *)slider {
    switch (slider.tag - 300) {
        case 1:
        {
            //调节弹幕透明度
            if(_o_adjustBlock){
                _o_adjustBlock(1,(int)slider.value);
            }
            _o_oneName.text = [NSString stringWithFormat:@"%d%%",(int)slider.value];
        }
            break;
        case 2:
        {
            //调节弹幕字体大小
            if(_o_adjustBlock){
                _o_adjustBlock(2,(int)slider.value);
            }
            _o_twoName.text = [NSString stringWithFormat:@"%d%%",(int)slider.value];
        }
            break;
        case 3:
            _o_threeName.text = [NSString stringWithFormat:@"%d%%",(int)slider.value];
                [[UIScreen mainScreen] setBrightness:(slider.value)/100];
            break;
        default:
            break;
    }
    
    NSLog(@"%f",slider.value);
}

@end
