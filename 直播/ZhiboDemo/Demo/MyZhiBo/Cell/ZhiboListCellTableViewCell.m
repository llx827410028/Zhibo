//
//  ZhiboListCellTableViewCell.m
//  Demo
//
//  Created by ugamehome on 2016/10/21.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "ZhiboListCellTableViewCell.h"

@interface ZhiboListCellTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *o_image;
@property (weak, nonatomic) IBOutlet UILabel *o_name;
@property (weak, nonatomic) IBOutlet UILabel *o_mun;

@end

@implementation ZhiboListCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)fillcellWithName:(NSString *)name andImageUrl:(NSString *)imageUrl andNum:(NSString *)num{
    [_o_image sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    _o_name.text = name;
    _o_mun.text = num;
}

+ (instancetype)liveEndView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
