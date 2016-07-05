//
//  THAddressModel.h
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/25.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THAddressViewModel ;

@interface THAddressModel : NSObject

@property (nonatomic,strong , readonly) NSArray<THAddressModel *> *subModels;

@property (nonatomic,copy , readonly) NSString *name;
@property (nonatomic,copy) NSString *pinYinName;
@property (nonatomic,copy) NSString *pinYinSuoxie;

@property (nonatomic,assign , getter=isSelected) BOOL selected;
@property (nonatomic,weak , readonly) THAddressModel *superModel;

@property (nonatomic,assign ,getter = isLastLayer , readonly) BOOL lastLayer;

@property (nonatomic,weak) THAddressViewModel *viewModel;

+ (instancetype)addressModelWithDict:(NSDictionary *)dict;
+ (instancetype)addressModelWithString:(NSString *)nameString;

-  (instancetype)initWithString:(NSString *)nameString;;
-  (instancetype)initWithDict:(NSDictionary *)dict;

- (void)addSubModel:(THAddressModel *)subModel ;
/// 依据模型层级链自顶向下输出模型信息
- (NSString *)outputInfo;

- (void)enumeratLevelLinkUsingBlock:(void(^)(THAddressModel *model , BOOL *stop))block;
- (void)enumeratSubModelsUsingBlock:(void(^)(THAddressModel *model , BOOL *stop))block;


@end
