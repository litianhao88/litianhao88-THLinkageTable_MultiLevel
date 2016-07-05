//
//  THSearchResultDisplayTab.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/26.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THSearchResultDisplayTab.h"

#import "THAddressModel.h"

#import "THAddressTabCell.h"

#import "CBAutoScrollLabel.h"

@interface THSearchResultDisplayTab ()<UITableViewDelegate , UITableViewDataSource>


@end

@implementation THSearchResultDisplayTab




- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag ;
        self.dataSource = self ;
        self.delegate = self ;
    }
    return self ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        CBAutoScrollLabel *label   = [[CBAutoScrollLabel alloc] init];
        label.tag = 10000;
        label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        [cell.contentView addSubview:label];
        // setup the auto scroll label
        label.textColor = [UIColor blackColor];
        label.labelSpacing = 30; // distance between start and end labels
        label.pauseInterval = 0; // seconds of pause before scrolling starts again
        label.scrollSpeed = 80; // pixels per second
        label.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
        label.fadeLength = 30.f;
        label.scrollDirection = CBAutoScrollDirectionLeft;
        [label observeApplicationNotifications];
    }
    
    CBAutoScrollLabel *label =  [cell.contentView viewWithTag:10000];
    NSString *str = [_models[indexPath.row] outputInfo];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]  initWithString:str];
    
    
    
    NSRange ranger = [str rangeOfString:self.keyWord];
    [attribute setAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor] , NSUnderlineStyleAttributeName  : [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:ranger];
    
    

    label.attributedText = attribute;
    label.font = [UIFont systemFontOfSize:20];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}
- (void)setModels:(NSArray *)models
{
    self.hidden = NO;
    _models = models ;
    [self reloadData];

    CATransition *animation = [CATransition animation];
    [animation setType:@"rippleEffect"];
    [animation setDuration:1];
    [animation setSubtype:kCATransitionFromTop];
    [self.layer addAnimation:animation forKey:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    animation.duration = 0.25 ;
    [tableView.layer addAnimation:animation forKey:nil];
    tableView.hidden = YES ;
    
    //选中cell 高悬动画代码
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]  ;
    UIView *animationView = [cell snapshotViewAfterScreenUpdates:YES];
 __block   CGRect frame = [tableView convertRect:cell.frame toView:tableView.window];
    animationView.frame = frame ;
    [tableView.window addSubview:animationView];
    [UIView animateWithDuration:0.5 animations:^{
        frame.origin = CGPointMake(0 , 20);
        frame.size.width = frame.size.width - 100 ;
        animationView.frame = frame;
        animationView.alpha = 0.3 ;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"alpha" object:nil];
        if (self.cellClkBlock) {
            self.cellClkBlock(indexPath.row);
        }

    } completion:^(BOOL finished) {
        
        [animationView removeFromSuperview];
    }];
  
}


- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (hidden == NO) {
        [self.superview bringSubviewToFront:self];
    }
}

@end
