//
//  THLinkageTablGgeneralAgency.h
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/29.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THLinkageTableBasicView ;
@class THAddressTab;
@class THAddressViewModel ;

@interface THLinkageTablGgeneralAgency : NSObject <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic,weak) THAddressTab *hostTab;
@property (nonatomic,weak) THAddressTab *subTab;
@property (nonatomic,strong) NSArray *models;
@property (nonatomic,copy) NSString *cellId;
@property (nonatomic,copy) NSIndexPath *lastSelectedIndexPath;

@property (nonatomic,weak) THLinkageTableBasicView *hostSuperTab;
@property (nonatomic,weak) THAddressViewModel *viewModel;

- (instancetype)initWithCellId:(NSString *)cellId models:(NSArray *)models;

@end
