//
//  THAddressViewModel.h
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/24.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THAddressModel ;

@interface THAddressViewModel : NSObject

@property (nonatomic,strong , readonly) NSArray<THAddressModel *> *proviences;

@property (nonatomic,weak) THAddressModel *selectedModel;

+ (instancetype)viewModelWithPlistName:(NSString *)plistFileName;
+ (void)resetAllSelectedModel;

- (void)changSelectedOfModel:(THAddressModel *)modelToChanged;

- (void)addSelectedModel:(THAddressModel *)modelToAdd;
- (void)removeSelectedModel:(THAddressModel *)modelToRemove;

@end
