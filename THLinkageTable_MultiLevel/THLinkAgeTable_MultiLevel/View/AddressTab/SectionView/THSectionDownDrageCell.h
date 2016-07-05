//
//  THSectionDownDrageCell.h
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/29.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THAddressModel ;
@class THAddressTab ;

@interface THSectionDownDrageCell : UITableViewCell

@property (nonatomic,strong) NSArray<THAddressModel *> *models;
@property (nonatomic,weak) THAddressTab *superTab;

@end
