//
//  ZhiboListCellTableViewCell.h
//  Demo
//
//  Created by ugamehome on 2016/10/21.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhiboListCellTableViewCell : UITableViewCell
+ (instancetype)liveEndView;
- (void)fillcellWithName:(NSString *)name andImageUrl:(NSString *)imageUrl andNum:(NSString *)num;
@end
