//
//  THLinkAgeTableSectionDownDelegateAndDataSource.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/29.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THLinkAgeTableSectionDownDelegateAndDataSource.h"

#import "THAddressModel.h"
#import "THAddressTab.h"

#import "THLinkageTableBasicView.h"
#import "THAddressViewModel.h"

#import "THSectionHeaderView.h"
#import "THSectionDownDrageCell.h"

static NSInteger const leafNodeSectionSign = 1<<8 ;

@interface THLinkAgeTableSectionDownDelegateAndDataSource ()

@property (nonatomic,strong) UILabel *headerView;
@property (nonatomic,assign) BOOL shouldChangeBackground;

@property (nonatomic,strong) NSIndexPath *scrollIndexPath;

@end

@implementation THLinkAgeTableSectionDownDelegateAndDataSource


- (instancetype)initWithCellId:(NSString *)cellId models:(NSArray *)models
{
    if (self = [super initWithCellId:cellId models:models ]) {

    }
    return self ;
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

#pragma mark - data source

//MARK:- section
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return  self.models.count;
}

//组高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  30;
}

//组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.models[section] isLastLayer])
    {
    THSectionHeaderView *sectionTitle =  (THSectionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:kTHSectionHeaderReuseIdentifierLeafNode] ;
    sectionTitle.contentView.backgroundColor = [UIColor whiteColor];
    THAddressModel *model = self.models[section];
    BOOL selected = model.isSelected ;
    NSInteger level = 0 ;
    while (model.superModel) {
        model = model.superModel ;
        level ++ ;
    }
    
    UIButton *btn = sectionTitle.titleBtn ;
    [btn setTitleColor:selected ? [UIColor orangeColor] : [UIColor colorWithWhite:0.2*level alpha:1] forState:UIControlStateNormal];
    [btn setTitle: [self.models[section] name] forState:UIControlStateNormal] ;
    [btn addTarget:self action:@selector(sectionClk:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = section | leafNodeSectionSign ;
    btn.imageView.transform =   selected ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(-M_PI_2);
        return sectionTitle ;
    }
    THSectionHeaderView *sectionTitle =  (THSectionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:kTHSectionHeaderReuseIdentifierFolderNode] ;
    sectionTitle.contentView.backgroundColor = [UIColor whiteColor];
    THAddressModel *model = self.models[section];
    BOOL selected = model.isSelected ;
    NSInteger level = 0 ;
    while (model.superModel) {
        model = model.superModel ;
        level ++ ;
    }
    
    UIButton *btn = sectionTitle.titleBtn ;
    [btn setTitleColor:selected ? [UIColor orangeColor] : [UIColor colorWithWhite:0.1*level alpha:1] forState:UIControlStateNormal];
    [btn setTitle: [self.models[section] name] forState:UIControlStateNormal] ;
    [btn addTarget:self action:@selector(sectionClk:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = section ;
    btn.imageView.transform =   selected ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(-M_PI_2);
    return  sectionTitle;
}

//组头点击回调
- (void)sectionClk:(UIButton *)sender
{
    if (sender.tag & leafNodeSectionSign) {

        sender.tag = sender.tag ^ leafNodeSectionSign ;
        THAddressModel *model = self.models[sender.tag];
        [model.viewModel removeSelectedModel:model.viewModel.selectedModel];
        [[model  viewModel] changSelectedOfModel:model];
        [model.viewModel addSelectedModel:model];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
        return ;
    }
    THAddressModel *model = self.models[sender.tag];
    if ([model isSelected]) {
        [model.viewModel removeSelectedModel:model];
    }else
    {
        [model.viewModel addSelectedModel:model];
    }
    
    BOOL selected = [model isSelected] ;
    
    [UIView animateWithDuration:0.25 animations:^{
        sender.imageView.transform =   selected ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(-M_PI_2);
    }];

    [self.hostTab reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
//    [model enumeratLevelLinkUsingBlock:^(THAddressModel *model, BOOL *stop) {
//                if (model.superModel == nil) {
//                    NSInteger indexer = [model.viewModel.proviences indexOfObject:model];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:@(indexer)];
//                    *stop  = YES ;
//                }
//            }];

}

//MARK:- row

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    THAddressModel *model =  self.models[section] ;
    if (model.isLastLayer == NO && model.isSelected) {
        return 1  ;
    }
    return 0 ;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    THAddressModel *model = self.models[indexPath.section];
    if(model.isLastLayer) return 0;
    if (model.isSelected) {
      __block  CGFloat height = model.subModels.count * 30  ;
        [model.subModels enumerateObjectsUsingBlock:^(THAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.selected) {
                height += obj.subModels.count * 30 ;
            }
        }];
        return MAX(height, 130)  ;
    }
    
    return 130 ;
}

//行cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    THAddressModel *model = self.models[indexPath.section];
    
    THSectionDownDrageCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
    
    cell.models = model.subModels;
    cell.superTab = self.hostTab ;
    return cell ;
}

#pragma mark - delegate


#pragma mark - getter
#pragma mark - setter
- (void)setHostTab:(THAddressTab *)hostTab
{

    [super setHostTab:hostTab];
    
    [hostTab registerClass:[THSectionHeaderView class] forHeaderFooterViewReuseIdentifier:kTHSectionHeaderReuseIdentifierFolderNode];
    [hostTab registerClass:[THSectionHeaderView class] forHeaderFooterViewReuseIdentifier:kTHSectionHeaderReuseIdentifierLeafNode];

}
#pragma mark - lazy load

@end
