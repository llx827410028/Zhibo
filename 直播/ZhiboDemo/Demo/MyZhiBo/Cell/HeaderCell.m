//
//  HeaderCell.m
//  Demo
//
//  Created by ugamehome on 2016/11/17.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "HeaderCell.h"
@interface HeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *o_text;
@property (weak, nonatomic) IBOutlet UIImageView *o_img_head;
@property (weak, nonatomic) IBOutlet UILabel *o_name;
@property (weak, nonatomic) IBOutlet UILabel *o_num;

@end
@implementation HeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)fillCollectionViewCellWithImgUrl:(NSString *)imgUrl andText:(NSString *)text andName:(NSString *)name andNum:(NSString *)num{
    [_o_img_head sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    NSLog(@"hahha%@---%@----%@",text,name,num);
    _o_text.text = name;
    _o_name.text = text;
    _o_num.text = [ZhiboCommon ComputemoneyWithMoney: [num intValue]];
}

@end
