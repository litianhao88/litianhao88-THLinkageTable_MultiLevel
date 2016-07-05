//
//  THSearchResultDisplayTab.h
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/26.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THSearchResultDisplayTab : UITableView

@property (nonatomic,strong) NSArray *models;
@property (nonatomic,copy) void(^cellClkBlock)(NSInteger indexer);
@property (nonatomic,copy) NSString *keyWord;

@end
