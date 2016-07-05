//
//  THAddressModel.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/25.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THAddressModel.h"
#import "PinYinForObjc.h"
#import "ChineseInclude.h"


@interface THAddressModel ()

@property (nonatomic,strong , readwrite) NSMutableArray<THAddressModel *> *p_subModels;
@property (nonatomic,copy , readwrite) NSString *name;
@property (nonatomic,weak , readwrite) THAddressModel *superModel;

@end

@implementation THAddressModel

@dynamic lastLayer;

+ (instancetype)addressModelWithString:(NSString *)nameString
{
    return [[self alloc] initWithString:nameString];
}

- (instancetype)initWithString:(NSString *)nameString
{
    if (self = [super init]) {
        self.name = nameString ;
    }
    return self ;
}


+ (instancetype)addressModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{

    if ([key isEqualToString:@"sub"]) {
        NSArray *tempArr  =  value;
        if (tempArr.count) {
            for (id value in tempArr) {
                if ([value isKindOfClass:[NSDictionary class]]) {
                    [self addSubModel:[THAddressModel addressModelWithDict:value]];
                }else if([value isKindOfClass:[NSString class]])
                {
                    [self addSubModel:[THAddressModel addressModelWithString:value]];
                }
            }
    }
        return;
   }
    [super setValue:value forKey:key];
}

- (void)setViewModel:(THAddressViewModel *)viewModel
{
    _viewModel = viewModel ;
    if (self.subModels.count) {
        [self enumeratSubModelsUsingBlock:^(THAddressModel *model, BOOL *stop) {
            model.viewModel = viewModel ;
        }];
    }
   
}

- (void)addSubModel:(THAddressModel *)subModel
{
    subModel.superModel = self ;
    [self.p_subModels addObject:subModel];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([value isKindOfClass:[NSString class]]) {
        self.name = value ;
    }
}
- (void)setName:(NSString *)name
{
    _name = [name copy];
   self.pinYinName = [PinYinForObjc chineseConvertToPinYin:name];
    
    self.pinYinSuoxie = [PinYinForObjc chineseConvertToPinYinHead:name];

}

- (NSString *)outputInfo
{
    NSMutableString *textStrM = [NSMutableString string];

    NSMutableArray<THAddressModel *> *tempArrM = [NSMutableArray array];
        THAddressModel *tempModel = self ;
        [tempArrM addObject:self];
        while (tempModel.superModel) {
            tempModel = tempModel.superModel ;
            [tempArrM addObject:tempModel];
        }
        
        [tempArrM enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(THAddressModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            [textStrM appendFormat:@"%@--" , model.name ];
        }];
        [textStrM replaceCharactersInRange:NSMakeRange(textStrM.length-2, 2) withString:@""];
    
    return textStrM ;
}

- (void)enumeratLevelLinkUsingBlock:(void (^)(THAddressModel *, BOOL *stop))block
{
        if (block == nil)  return ;
        BOOL stop = NO;
        THAddressModel *model = self ;
    if (stop == NO) {
        block(model , &stop);
    }
        while (model.superModel) {
            model = model.superModel ;
            if (stop == NO) {
                block(model , &stop);
            }else
            {
                break;
            }
        }
}

- (void)enumeratSubModelsUsingBlock:(void(^)(THAddressModel *model , BOOL *stop))block;
{
    if (block == nil)  return ;
    [self operationArr:self.subModels usingBlock:block];
}

- (void)operationArr:(NSArray<THAddressModel *> *)arrToOpera usingBlock:(void(^)(THAddressModel *model , BOOL *stop))block
{
    if (block == nil)  return ;
   __block BOOL stoper = NO ;
    [arrToOpera enumerateObjectsUsingBlock:^(THAddressModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (stoper == NO) {
            block(obj , &stoper);
        }
        if (stoper == YES) {
            *stop = YES ;
        }else
        {
            [self operationArr:obj.subModels usingBlock:block];
        }
    }];
}

#pragma mark - 数组懒加载

-  (NSMutableArray<THAddressModel *> *)p_subModels
{
    if (!_p_subModels) {
        _p_subModels = [NSMutableArray array];
    }
    return _p_subModels;
}

- (NSArray<THAddressModel *> *)subModels
{
    return [self.p_subModels copy];
}

- (BOOL)isLastLayer
{
    if (self.subModels.count) {
        return  NO;
    }
    return YES;
}

@end
