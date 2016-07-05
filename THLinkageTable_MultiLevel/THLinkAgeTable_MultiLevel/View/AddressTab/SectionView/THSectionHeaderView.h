//
//  THSectionHeaderView.h
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/29.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic,weak) UIButton *titleBtn;

@end

UIKIT_EXTERN NSString *const kTHSectionHeaderReuseIdentifierFolderNode;
UIKIT_EXTERN NSString *const kTHSectionHeaderReuseIdentifierLeafNode;
