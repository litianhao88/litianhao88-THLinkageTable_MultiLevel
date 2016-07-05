//
//  THAddressSearchBar.h
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/26.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THAddressSearchBar : UIView

@property (nonatomic,copy) void(^searchBeginBlock) (NSString *stringForSearch);

@end
