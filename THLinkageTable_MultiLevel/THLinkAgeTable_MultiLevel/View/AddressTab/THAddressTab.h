//
//  THAddressTab.h
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/25.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THLinkageTablGgeneralAgency ;


@interface THAddressTab : UITableView


@property (nonatomic,weak) THAddressTab *superTab;
@property (nonatomic,strong) THLinkageTablGgeneralAgency *generalAgency;


- (instancetype)initWithFrame:(CGRect)frame models:(NSArray *)models;
- (instancetype)initWithFrame:(CGRect)frame models:(NSArray *)models mode:(BOOL)isTree;

- (void)changeModels:(NSArray *)models;

- (void)changeDisplayMode:(BOOL)isTree;

@end
