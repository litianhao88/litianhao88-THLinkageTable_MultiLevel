//
//  rootVC.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/27.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "rootVC.h"

#import "ViewController.h"

#import "CBAutoScrollLabel.h"

@interface rootVC ()
@property (nonatomic,strong) NSMutableArray *titleArrM;
@end

@implementation rootVC


- (NSMutableArray *)titleArrM
{
    if (!_titleArrM) {
        _titleArrM = [NSMutableArray array];
    }
    return _titleArrM ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO ;
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ViewController *vc = segue.destinationViewController ;
    __weak typeof(self) weakSelf = self ;
    [vc setPopCallBack:^(NSString *text) {
        __strong typeof(weakSelf) strongSelf = weakSelf ;
        if (text.length) {
            [strongSelf.titleArrM addObject:text];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArrM.count;
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
    
    label.text = self.titleArrM[indexPath.row];
    label.font = [UIFont systemFontOfSize:20];


    return cell;
}


@end
