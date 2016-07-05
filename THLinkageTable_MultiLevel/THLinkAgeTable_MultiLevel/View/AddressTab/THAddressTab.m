//
//  THAddressTab.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/25.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THAddressTab.h"
#import "THAddressPickerDelegateAndDatasource.h"
#import "THAddressTabCell.h"
#import "THSectionDownDrageCell.h"
#import "THLinkAgeTableSectionDownDelegateAndDataSource.h"


static NSString *const cellId = @"basicCell" ;
static NSString *const subCellId = @"subCellId" ;

static NSString *const THSectionDownDrageCellId = @"THSectionDownDrageCellId" ;

@interface THAddressTab()

@property (nonatomic,assign) BOOL isTree;

@end

@implementation THAddressTab

- (instancetype)initWithFrame:(CGRect)frame models:(NSArray *)models mode:(BOOL)isTree
{
    if (self = [super initWithFrame:frame]) {
        
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag ;
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO ;
        self.separatorStyle = UITableViewCellSeparatorStyleNone ;
        
        
        
        self.tableFooterView = [[UITableViewHeaderFooterView alloc] init];
        
        [self registerClass:[THAddressTabCell class] forCellReuseIdentifier:cellId];
        [self registerClass:[THAddressTabCell class] forCellReuseIdentifier:subCellId];
        [self registerClass:[THSectionDownDrageCell class] forCellReuseIdentifier:THSectionDownDrageCellId];
        self.backgroundColor = [UIColor clearColor];

        if (isTree) {
        self.generalAgency = [[THLinkAgeTableSectionDownDelegateAndDataSource alloc] initWithCellId:THSectionDownDrageCellId models:models];
        }else
        {
        self.generalAgency = [[THAddressPickerDelegateAndDatasource alloc] initWithCellId:cellId models:models];
        }
    }
    return self ;
}

- (instancetype)initWithFrame:(CGRect)frame models:(NSArray *)models
{

    return [self initWithFrame:frame models:models mode:NO]; ;
}

- (void)setGeneralAgency:(THAddressPickerDelegateAndDatasource *)generalAgency
{
    _generalAgency = generalAgency ;
    _generalAgency.hostTab = self ;
    self.dataSource = _generalAgency ;
    self.delegate = _generalAgency ;

}

- (void)changeModels:(NSArray *)models
{
    if ([_generalAgency isKindOfClass:[THAddressPickerDelegateAndDatasource class]]) {
        [(THAddressPickerDelegateAndDatasource *)_generalAgency changeModels:models];
        [self reloadData];
        
#warning 错误提示 no index path for table cell being reused [self reloadData]放在后面就有问题 尚未解决
        if (models == nil) {
            self.hidden = YES ;
            self.frame = CGRectZero ;
        }
    }
  else
  {
      _generalAgency.models = models ;
      [self reloadData];
  }
}

- (void)setHidden:(BOOL)hidden
{
    BOOL shouldRelayout = self.hidden != hidden ;
        [super setHidden:hidden];
    if (shouldRelayout) {
        [self.superview addSubview:self];
    }
}


- (void)changeDisplayMode:(BOOL)isTree;
{
    if (self.isTree == isTree)  return ;
    _isTree = isTree ;
    if (isTree) {
        self.generalAgency =  [[THLinkAgeTableSectionDownDelegateAndDataSource alloc] initWithCellId:THSectionDownDrageCellId models:self.generalAgency.models];
    }else
    {
        self.generalAgency = [[THAddressPickerDelegateAndDatasource alloc] initWithCellId:cellId models:self.generalAgency.models];
    }
        
        [self reloadData];
}


@end
