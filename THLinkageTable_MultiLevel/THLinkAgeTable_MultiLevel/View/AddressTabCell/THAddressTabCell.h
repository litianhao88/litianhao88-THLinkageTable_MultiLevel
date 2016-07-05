//
//  THAddressTabCell.h
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/25.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THAddressModel ;

@interface THAddressTabCell : UITableViewCell

@property (nonatomic,strong) THAddressModel *model;
@property (nonatomic,assign) NSInteger level;

@end
