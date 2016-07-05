//
//  THLinkageTableBasicView.h
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/25.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THAddressViewModel ;
@interface THLinkageTableBasicView : UIView

@property (nonatomic,copy) void(^reLayoutSubTabBlock) (NSArray *visibleViews);

@property (nonatomic,assign) BOOL shouldShowSearchBar;

@property (nonatomic,assign) BOOL autoReload ;
@property (nonatomic,strong) THAddressViewModel *viewModel;


- (instancetype)initWithFrame:(CGRect)frame plistName:(NSString *)plistName;
- (void)changeModel:(BOOL)isTree;
@end
