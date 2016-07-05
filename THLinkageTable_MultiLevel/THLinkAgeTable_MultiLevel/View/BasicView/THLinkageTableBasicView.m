//
//  THLinkageTableBasicView.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/25.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THLinkageTableBasicView.h"

#import "THAddressTab.h"
#import "THAddressViewModel.h"
#import "THAddressSearchBar.h"
#import "THAddressModel.h"

#import "THSearchResultDisplayTab.h"

@interface THLinkageTableBasicView ()

@property (nonatomic,weak) THSearchResultDisplayTab *displayTab;

@property (nonatomic,weak) THAddressSearchBar *addressSearchBar;
@property (nonatomic,strong) NSMutableArray *addressTabArrM;

@property (nonatomic,strong) NSMutableArray<THAddressModel *> *resultModels;

@property (nonatomic,weak) id<NSObject> observer;

@end

@implementation THLinkageTableBasicView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_observer name:@"reloadData" object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame plistName:(NSString *)plistName
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        NSString *plistNameTemp = plistName.length > 0 ? plistName : @"address" ;

          _viewModel = [THAddressViewModel viewModelWithPlistName:plistNameTemp];
        
        THAddressTab *addressTab = [[THAddressTab alloc] initWithFrame:self.bounds models:_viewModel.proviences];
        [self addSubview:addressTab];
        __weak typeof(addressTab) weakAddressTab = addressTab ;

        [[NSNotificationCenter defaultCenter] addObserverForName:@"reloadData" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            if (note.object == nil) {
                [weakAddressTab reloadData];
            }else{
            [weakAddressTab reloadSections:[NSIndexSet indexSetWithIndex:[note.object integerValue]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
    return self ;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame plistName:nil];
}

- (void)addSubview:(UIView *)view
{
    if ([self.subviews containsObject:view]) {
        self.addressSearchBar.hidden ?  [self reLayoutSubTab] : [self reLayoutForSearchBar];

        return ;
    }
    [super addSubview:view];
    
    if ([view isKindOfClass:[THAddressTab class]]) {
        [self.addressTabArrM addObject:view];
        self.addressSearchBar.hidden ?  [self reLayoutSubTab] : [self reLayoutForSearchBar];
    }
    
}

- (void)reLayoutSubTab
{
    NSMutableArray *tempArrM = [NSMutableArray array];
    for (UIView *view in self.addressTabArrM) {
        if (view.hidden == NO) {
            [tempArrM addObject:view];
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat width = self.bounds.size.width /tempArrM.count ;
        [tempArrM enumerateObjectsUsingBlock:^(UIView  *_Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            view.frame = CGRectMake(idx * width, 0,  width , self.bounds.size.height);
        }];
    }];
}

- (void)reLayoutForSearchBar
{
    NSMutableArray *tempArrM = [NSMutableArray array];
    for (UIView *view in self.addressTabArrM) {
        if (view.hidden == NO) {
            [tempArrM addObject:view];
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGFloat width = self.bounds.size.width /tempArrM.count ;
        [tempArrM enumerateObjectsUsingBlock:^(UIView  *_Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            view.frame = CGRectMake(idx * width, self.addressSearchBar.bounds.size.height,  width , self.bounds.size.height - self.addressSearchBar.bounds.size.height);
        }];
    }];
}

- (void)setShouldShowSearchBar:(BOOL)shouldShowSearchBar
{
    _shouldShowSearchBar = shouldShowSearchBar ;
    self.addressSearchBar.hidden = !shouldShowSearchBar ;
    if (shouldShowSearchBar) {
        [self reLayoutForSearchBar];
    }else
    {
        [self reLayoutSubTab];
    }
    
}

- (THAddressSearchBar *)addressSearchBar
{
    if (!_addressSearchBar) {
        THAddressSearchBar *searchBar = [[THAddressSearchBar alloc] init];
        _addressSearchBar = searchBar ;
        searchBar.frame = CGRectMake(0, 0, self.bounds.size.width, 40) ;
        [self addSubview:_addressSearchBar];
        
        __weak typeof(self) weakSelf = self ;
        [searchBar setSearchBeginBlock:^(NSString *stringForSearch){
            if (stringForSearch.length) {
                [weakSelf actionSearchWithText:stringForSearch];
                self.displayTab.models = self.resultModels ;
                self.displayTab.keyWord = stringForSearch;
                [self.displayTab setCellClkBlock:^(NSInteger indexer) {
                  
                    THAddressModel *model = self.resultModels[indexer];
                   [self.viewModel changSelectedOfModel:model];
                    self.autoReload = YES ;
                    [self.addressTabArrM.firstObject reloadData];

                    //
//                    NSInteger count = 0 ;
//                    while (model.superModel) {
//                        model = model.superModel;
//                        count ++ ;
//                    }
//                    [self.addressTabArrM enumerateObjectsUsingBlock:^(UITableView  *_Nonnull table, NSUInteger idx, BOOL * _Nonnull stop) {
//                        if (idx > count  ) {
//                            table.hidden = YES ;
//                        }
//                    }];
                    
                }];
            }
        }];
    }
    return _addressSearchBar ;
}

- (void)actionSearchWithText:(NSString *)textForSearch
{
    [self.resultModels removeAllObjects];
    NSArray<THAddressModel *> *arrForSearch = [self.viewModel.proviences copy];
    [self addResultOfArr:arrForSearch toArr:self.resultModels searchString:textForSearch];
}

- (void)addResultOfArr:(NSArray<THAddressModel *> *)arr toArr:(NSMutableArray<THAddressModel *> *)arrM searchString:(NSString *)searchString
{
    if (arr.count) {
        [arr enumerateObjectsUsingBlock:^(THAddressModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.name containsString:searchString] || [model.pinYinName containsString:searchString] || [model.pinYinSuoxie containsString:searchString]) {
                [arrM addObject:model];
            }
            if (model.subModels.count) {
                [self addResultOfArr:model.subModels toArr:arrM searchString:searchString];
            }
        }];
    }
}
- (NSMutableArray *)addressTabArrM
{
    if (!_addressTabArrM) {
        _addressTabArrM = [NSMutableArray array];
    }
    return _addressTabArrM ;
}

- (THSearchResultDisplayTab *)displayTab
{
    if (!_displayTab) {
        THSearchResultDisplayTab *table = [[THSearchResultDisplayTab alloc] initWithFrame:CGRectMake(0, self.addressSearchBar.bounds.size.height, self.bounds.size.width, self.bounds.size.height - self.addressSearchBar.bounds.size.height)];

        _displayTab = table ;
        [self addSubview:table];
    }
    return _displayTab;
}



- (NSMutableArray<THAddressModel *> *)resultModels
{
    if (!_resultModels) {
        _resultModels = [NSMutableArray array];
    }
    return  _resultModels ;
}

- (void)changeModel:(BOOL)isTree
{
    THAddressTab *table = self.addressTabArrM.firstObject ;

    if (isTree) {
        [self.addressTabArrM enumerateObjectsUsingBlock:^(UITableView  *_Nonnull tab, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 0) {
                [tab removeFromSuperview];
            }
        }];
        [self.addressTabArrM removeObjectsInRange:NSMakeRange(1, self.addressTabArrM.count-1)];
    table.frame = CGRectMake(0, self.addressSearchBar.bounds.size.height,  self.bounds.size.width , self.bounds.size.height - self.addressSearchBar.bounds.size.height);
    }

    [table changeDisplayMode:isTree];
    
}

@end
