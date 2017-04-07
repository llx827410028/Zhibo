//
//  RankingCell.m
//  Demo
//
//  Created by ugamehome on 2016/10/21.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "RankingCell.h"
@interface RankingCell()
@property (weak, nonatomic) IBOutlet UILabel *o_rank;
@property (weak, nonatomic) IBOutlet UILabel *o_name;
@property (weak, nonatomic) IBOutlet UILabel *o_num;

@end

@implementation RankingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)liveEndView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)fillCellWithRank:(NSString *)rank andName:(NSString *)name andZan:(NSString *)zanNum{
    _o_rank.text = rank;
    _o_name.text = name;
    _o_num.text = zanNum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
