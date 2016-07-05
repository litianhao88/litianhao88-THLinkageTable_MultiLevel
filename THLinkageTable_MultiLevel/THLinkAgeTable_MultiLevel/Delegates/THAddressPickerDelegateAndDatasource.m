//
//  THAddressPickerDelegateAndDatasource.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/25.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THAddressPickerDelegateAndDatasource.h"
#import "THAddressModel.h"
#import "THAddressTab.h"
#import "THAddressTabCell.h"

#import "THLinkageTableBasicView.h"
#import "THAddressViewModel.h"

@interface THAddressPickerDelegateAndDatasource ()

@property (nonatomic,strong) UILabel *headerView;
@property (nonatomic,assign) BOOL shouldChangeBackground;


@end

@implementation THAddressPickerDelegateAndDatasource

- (instancetype)initWithCellId:(NSString *)cellId models:(NSArray *)models
{
    if (self = [super initWithCellId:cellId models:models ]) {
        
        if ([self.models.firstObject superModel]) {
            self.headerView.text =  [self.models[0] superModel].name ;
        }else
        {
            self.headerView.text =  @"选择省" ;
        }
    }
    return self ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    THAddressTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
    THAddressModel *model = self.models[indexPath.row];
    if ( model.selected) {
        [self setLastSelectedIndexPath:indexPath];
    }
    cell.model = model ;
    return cell ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.shouldChangeBackground) {
        cell.tag = 10000;
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.shouldChangeBackground  = YES ;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.shouldChangeBackground  = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.shouldChangeBackground  = NO;
}

- (void)setLastSelectedIndexPath:(NSIndexPath *)lastSelectedIndexPath
{
    if (lastSelectedIndexPath == nil)
    {
        super.lastSelectedIndexPath = lastSelectedIndexPath ;
         return;
    }
    
    if (!self.hostSuperTab.autoReload && self.lastSelectedIndexPath && self.lastSelectedIndexPath.row == lastSelectedIndexPath.row) return ;
    
        super.lastSelectedIndexPath = lastSelectedIndexPath ;
    
    if (self.hostSuperTab.autoReload) {
        [self.hostTab scrollToRowAtIndexPath:lastSelectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

    
        THAddressModel *model = self.models[lastSelectedIndexPath.row];
        
        if (model.subModels.count) {
            
            if (!self.subTab) {
                
                
                THAddressTab *subTab   = [[THAddressTab alloc] initWithFrame:CGRectZero models:model.subModels];
                self.subTab = subTab ;
                subTab.superTab = (THAddressTab *)self.hostTab ;
                
                [self.hostSuperTab addSubview:subTab];
                
            }
            else
            {
                if (self.subTab.hidden) {
                    self.subTab.hidden = NO ;
                }
                
                [self.subTab changeModels:model.subModels];
                if (self.hostSuperTab.autoReload == NO) {
                    THAddressTab *tempTab = self.subTab ;
                    while (tempTab.generalAgency.subTab.generalAgency.models.count >0) {
                        [tempTab.generalAgency.subTab changeModels:nil];
                        tempTab = tempTab.generalAgency.subTab ;
                    }
                }
                }
 
        }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.lastSelectedIndexPath && self.lastSelectedIndexPath.row == indexPath.row) return ;
    self.hostSuperTab.autoReload = NO ;
    [[self.models[indexPath.row] viewModel] changSelectedOfModel:self.models[indexPath.row%self.models.count]];
    [tableView reloadData];
    [tableView cellForRowAtIndexPath:indexPath].tag = 10000;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView  ;
}

- (void)changeModels:(NSArray *)models;
{
    self.lastSelectedIndexPath = nil ;
    
    self.models = models ;
    if ( [models.lastObject superModel].name) {
        self.headerView.text =  [models.lastObject superModel].name;
    }
    if (models == nil) {
        self.headerView.text = nil ;
    }
}



- (THLinkageTableBasicView *)hostSuperTab
{
    return (THLinkageTableBasicView *)self.hostTab.superview ;
}
#pragma mark - 头标签视图
- (UILabel *)headerView
{
    if (!_headerView) {
        _headerView = [[UILabel alloc] init];
        _headerView.textAlignment = NSTextAlignmentCenter ;
        _headerView.backgroundColor = [UIColor lightGrayColor];
        _headerView.userInteractionEnabled = YES ;
    }
    return _headerView ;
}

@end