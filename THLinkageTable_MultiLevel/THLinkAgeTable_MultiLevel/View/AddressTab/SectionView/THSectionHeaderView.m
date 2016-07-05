//
//  THSectionHeaderView.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/29.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THSectionHeaderView.h"

#import "THSectionTitleBtn.h"

NSString *const kTHSectionHeaderReuseIdentifierFolderNode = @"reuseid_FolderNode";
NSString *const kTHSectionHeaderReuseIdentifierLeafNode = @"reuseid_LeafNode";

@interface THSectionHeaderView ()


@end

@implementation THSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        THSectionTitleBtn *btn = [[THSectionTitleBtn alloc] init];
        [self.contentView addSubview:btn];
        self.titleBtn = btn ;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        if ([reuseIdentifier isEqualToString:kTHSectionHeaderReuseIdentifierFolderNode]) {
            [btn setImage:[UIImage imageNamed:@"YellowDownArrow"] forState:UIControlStateNormal];
            btn.imageView.transform = CGAffineTransformMakeRotation(-M_PI_2);

        }else if([reuseIdentifier isEqualToString:kTHSectionHeaderReuseIdentifierLeafNode])
        {
            // 备用 当前版本不需要设置额外属性
        }
 
    }
    return  self ;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleBtn.frame = self.bounds;
}



@end
