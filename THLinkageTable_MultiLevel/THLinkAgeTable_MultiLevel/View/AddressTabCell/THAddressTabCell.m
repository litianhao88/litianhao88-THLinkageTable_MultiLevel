//
//  THAddressTabCell.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/25.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THAddressTabCell.h"

#import "THAddressModel.h"

#import "CBAutoScrollLabel.h"

@interface THAddressTabCell ()

@property (nonatomic,weak) UIView *separeLine;
@property (nonatomic,weak) CBAutoScrollLabel *displayLbl;

@end
@implementation THAddressTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([reuseIdentifier isEqualToString:@"basicCell"]) {
            [self settingSrpareLine];
                   }
        [self settingLabel];
        if ([reuseIdentifier isEqualToString:@"subCellId"]) {
            self.displayLbl.textAlignment = NSTextAlignmentLeft;
        }
        
    }
    return self ;
}

- (void)settingLabel
{
    CBAutoScrollLabel *label   = [[CBAutoScrollLabel alloc] init];
    [self.contentView addSubview:label];
    // setup the auto scroll label
    label.textColor = [UIColor blackColor];
    label.labelSpacing = 30; // distance between start and end labels
    label.pauseInterval = 0; // seconds of pause before scrolling starts again
    label.scrollSpeed = 30; // pixels per second
    label.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
    label.fadeLength = 30.f;
    label.scrollDirection = CBAutoScrollDirectionLeft;
    [label observeApplicationNotifications];
    self.displayLbl = label;
}

- (void)settingSrpareLine
{
    UIView *separeLine = [[UIView alloc] init];
    separeLine.layer.cornerRadius = 8 ;
    separeLine.layer.masksToBounds = YES ;
    separeLine.layer.shouldRasterize = YES ;
    separeLine.layer.rasterizationScale = [UIScreen mainScreen].scale;
    separeLine.backgroundColor = [UIColor blackColor];
    separeLine.alpha = 0.8;
    _separeLine = separeLine ;
    [self.contentView insertSubview:separeLine belowSubview:self.textLabel];
    self.textLabel.textAlignment = NSTextAlignmentCenter ;
    self.selectionStyle = UITableViewCellSelectionStyleNone ;

}

- (void)setTag:(NSInteger)tag
{
    if ([self.reuseIdentifier isEqualToString:@"basicCell"]) {

    if (tag == 10000) {
        [self.contentView bringSubviewToFront:self.textLabel];
        self.separeLine.backgroundColor = [UIColor redColor];

        [UIView animateWithDuration:0.25 animations:^{
            self.separeLine.backgroundColor = [UIColor orangeColor];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
                self.separeLine.backgroundColor = [UIColor blackColor];
            }];
        }];
    }else
    {
        [super setTag:tag];
    }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.reuseIdentifier isEqualToString:@"basicCell"]) {
    self.separeLine.frame = CGRectMake(8, 8 ,self.bounds.size.width - 16 , self.bounds.size.height - 16);
        self.displayLbl.frame = self.separeLine.frame ;
    }
    self.displayLbl.frame = CGRectMake(8, 0 ,self.bounds.size.width - 16 , self.bounds.size.height);

}

- (void)setModel:(THAddressModel *)model
{
    _model = model ;
    if ([self.reuseIdentifier isEqualToString:@"basicCell"]) {

    self.displayLbl.textColor = model.isSelected ? [UIColor orangeColor] : [UIColor whiteColor];
    }else if([self.reuseIdentifier isEqualToString:@"subCellId"]){
        self.displayLbl.textColor = model.isSelected ? [UIColor orangeColor] : [UIColor colorWithWhite:0.5 alpha:1];
    }
    self.displayLbl.text = model.name;

}

@end
