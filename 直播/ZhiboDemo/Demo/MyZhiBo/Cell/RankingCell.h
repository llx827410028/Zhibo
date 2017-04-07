//
//  RankingCell.h
//  Demo
//
//  Created by ugamehome on 2016/10/21.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingCell : UITableViewCell
- (void)fillCellWithRank:(NSString *)rank andName:(NSString *)name andZan:(NSString *)zanNum;
+ (instancetype)liveEndView;
@end
