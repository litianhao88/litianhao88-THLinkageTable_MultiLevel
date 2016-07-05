//
//  THSectionDownDrageCell.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/29.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THSectionDownDrageCell.h"

#import "THAddressTab.h"

@interface THSectionDownDrageCell ()

@property (nonatomic,strong) THAddressTab *addressTab;

@end

@implementation THSectionDownDrageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self ;
}

- (void)setModels:(NSArray<THAddressModel *> *)models
{
    _models = models ;
    [self.addressTab changeModels:models];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.contentView.bounds ;
    frame.origin.x +=    20 ;
    frame.size.width -= 23 ;
    self.addressTab.frame = frame;
}

- (void)setSuperTab:(THAddressTab *)superTab
{
    _superTab = superTab ;
    self.addressTab.superTab = superTab ;
}

- (THAddressTab *)addressTab
{
    if (!_addressTab) {
        THAddressTab *addressTab = [[THAddressTab alloc] initWithFrame:CGRectZero models:nil mode:YES];
        _addressTab = addressTab ;
        _addressTab.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:addressTab];
    }
    return _addressTab ;
}

@end
