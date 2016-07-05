//
//  THAddressViewModel.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/24.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THAddressViewModel.h"

#import "THAddressModel.h"

static THAddressViewModel *singleTon = nil ;

@interface THAddressViewModel ()

@property (nonatomic,weak) id<NSObject> observer_selected;
@property (nonatomic,weak) id<NSObject> observer_remove;


@property (nonatomic,strong) NSMutableArray *selectedModels;

@end

@implementation THAddressViewModel

+ (instancetype)viewModelWithPlistName:(NSString *)plistFileName
{
    if (singleTon == nil) {
        singleTon = [[self alloc] initWithPlistName:plistFileName];
    }
    return singleTon;
}

- (instancetype)initWithPlistName:(NSString *)plistFileName
{
    if (self = [super init]) {
        
        [self loadDataWithPlistName:plistFileName];
    }
        return self;
}

- (void)loadDataWithPlistName:(NSString *)plistFileName
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistFileName ofType:@"plist"]];
    
    NSArray *array = dict[@"address"];
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:array.count];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        THAddressModel *model = [THAddressModel addressModelWithDict:dict];
        model.viewModel = self ;
        [tempArr addObject:model];
    }];
    _proviences = [tempArr copy];

}

- (void)changSelectedOfModel:(THAddressModel *)modelToChanged
{

    THAddressModel *originModel = self.selectedModel;
    if (originModel == modelToChanged)  return ;
    
    originModel.selected = NO;
//    while (originModel.superModel) {
//        originModel = originModel.superModel ;
//        originModel.selected = NO;
//    }
    self.selectedModel = modelToChanged ;
  
    
    NSMutableArray<THAddressModel *> *tempArrM = [NSMutableArray array];

    THAddressModel *model = self.selectedModel;
    if (model != nil) {

    [tempArrM addObject:model];
    model.selected = YES ;
    while (model.superModel) {
        model = model.superModel ;
        model.selected = YES ;
        [tempArrM addObject:model];
    }
    }
    NSMutableString *textStrM = [NSMutableString stringWithString:@"当前选择:"];

        [tempArrM enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(THAddressModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            [textStrM appendFormat:@"%@--" , model.name ];
        }];
        [textStrM replaceCharactersInRange:NSMakeRange(textStrM.length-2, 2) withString:@""];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeText" object: textStrM];

}

- (void)addSelectedModel:(THAddressModel *)modelToAdd
{
    
    if (modelToAdd == nil || [self.selectedModels containsObject:modelToAdd])  return ;
    
    
    modelToAdd.selected = YES ;
   __weak THAddressModel *model = modelToAdd ;
    
//  __block  BOOL shouldReturn = NO ;
//    
//    [model enumeratSubModelsUsingBlock:^(THAddressModel *model, BOOL *stop) {
//        if (model.selected == YES) {
//            *stop = YES ;
//            shouldReturn = YES;
//        }
//    }];
    
//    if (shouldReturn) return ;
    __weak typeof(self) weakSelf = self ;

    [model enumeratLevelLinkUsingBlock:^(THAddressModel *model, BOOL *stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf ;
        if ([strongSelf.selectedModels containsObject:model]) {
            [strongSelf.selectedModels removeObject:model];
        }
    }];

    [self.selectedModels addObject:modelToAdd];
}

- (void)removeSelectedModel:(THAddressModel *)modelToRemove
{
    modelToRemove.selected = NO ;
    [self.selectedModels removeObject:modelToRemove];
    [modelToRemove enumeratSubModelsUsingBlock:^(THAddressModel *model, BOOL *stop) {
        model.selected = NO;
    }];
    [self addSelectedModel:modelToRemove.superModel];
}

+ (void)resetAllSelectedModel
{
    [singleTon.selectedModels enumerateObjectsUsingBlock:^(THAddressModel  *_Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [model enumeratLevelLinkUsingBlock:^(THAddressModel *model, BOOL *stop) {
            model.selected = NO;
        }];
    }];
    [singleTon.selectedModels removeAllObjects];
    [singleTon changSelectedOfModel:nil];
}
#pragma mark - 集合对象懒加载

- (NSMutableArray *)selectedModels
{
    if (!_selectedModels) {
        _selectedModels = [NSMutableArray array];
    }
    return  _selectedModels ;
}

@end
