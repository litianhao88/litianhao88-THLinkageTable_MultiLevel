//
//  THLinkageTablGgeneralAgency.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/29.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THLinkageTablGgeneralAgency.h"

#import "THAddressModel.h"
#import "THAddressTab.h"
#import "THAddressTabCell.h"

#import "THAddressViewModel.h"

@interface THLinkageTablGgeneralAgency ()

@end


@implementation THLinkageTablGgeneralAgency



- (instancetype)initWithCellId:(NSString *)cellId models:(NSArray *)models
{
    if (self = [super init ]) {
        _models = models;
        _cellId = [cellId copy];
    }
    return self ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    THAddressTabCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellId forIndexPath:indexPath];
    THAddressModel *model = self.models[indexPath.row];
    if ( model.selected) {
        [self setLastSelectedIndexPath:indexPath];
    }
    cell.model = model ;
    return cell ;
}


- (void)setHostTab:(THAddressTab *)hostTab
{
    _hostTab = hostTab ;
}

- (THLinkageTableBasicView *)hostSuperTab
{
    return (THLinkageTableBasicView *)self.hostTab.superview ;
}

@end
