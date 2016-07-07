//
//  ViewController.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/24.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "ViewController.h"
#import "CBAutoScrollLabel.h"
#import "THAddressViewModel.h"
#import "THLinkageTableBasicView.h"

@interface ViewController ()
@property (nonatomic,weak) THLinkageTableBasicView *addressTab;

@property (nonatomic,weak) CBAutoScrollLabel *titleLbl;

@property (nonatomic,weak) id<NSObject> observer;
@property (nonatomic,weak) id<NSObject> alphaObserver;

@property (nonatomic,assign) BOOL isTree;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleLbl];
    [self registerObserver];
    [self addAddressTab];
    [self configBtns];

}

- (void)configBtns
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_titleLbl.frame.size.width + 8, _titleLbl.frame.origin.y , 80 - 16 , _titleLbl.bounds.size.height - 25)];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.layer.cornerRadius =  8 ;
    [self.view addSubview:btn];
    _titleLbl.userInteractionEnabled = YES ;
    
    UIButton *bttomBtn = [[UIButton alloc] initWithFrame:CGRectMake(_titleLbl.frame.size.width + 8, btn.frame.origin.y + btn.frame.size.height + 5 , 80 - 16 ,btn.bounds.size.height)];
    [bttomBtn addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventTouchUpInside];
    [bttomBtn setTitle:@"换到树型" forState:UIControlStateNormal];
    [bttomBtn setTitle:@"换到联动" forState:UIControlStateSelected];
    bttomBtn.backgroundColor = [UIColor greenColor];
    [bttomBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    bttomBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    bttomBtn.layer.cornerRadius =  8 ;
    [self.view addSubview:bttomBtn];
}
- (void)changeMode:(UIButton *)sender
{
    self.isTree = !self.isTree ;
    sender.selected = self.isTree;
    CATransition *animation = [CATransition animation];
    [animation setType:@"rippleEffect"];
    [animation setDuration:1];
    [animation setSubtype:kCATransitionFromTop];
    [self.addressTab.layer addAnimation:animation forKey:nil];
    
    [self.addressTab changeModel:self.isTree];
}

- (void)back
{
    if (_titleLbl.text.length && self.popCallBack) {
        self.popCallBack(_titleLbl.text);
    }
    [THAddressViewModel resetAllSelectedModel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addAddressTab
{
    THLinkageTableBasicView *addressTab = [[THLinkageTableBasicView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 )];
    [addressTab changeModel:YES];
    addressTab.shouldShowSearchBar = YES ;
    _addressTab = addressTab ;

    [self.view addSubview:addressTab];

}
- (void)addTitleLbl
{
    CBAutoScrollLabel *label = [[CBAutoScrollLabel alloc ] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width - 80 , 44)];
    
    CAGradientLayer *backLayer = [CAGradientLayer layer];
    backLayer.frame = label.bounds ;
    backLayer.colors =    backLayer.colors = @[(__bridge id)[UIColor lightGrayColor].CGColor, (__bridge id)[UIColor darkGrayColor].CGColor , (__bridge id)[UIColor darkGrayColor].CGColor , (__bridge id)[UIColor lightGrayColor].CGColor];
    backLayer.locations = @[@(0.0f) , @(0.4f) , @(0.6f) ,@(1.0f)];
    backLayer.startPoint = CGPointMake(0, 0.5);
    backLayer.endPoint = CGPointMake(1.0, 0.5);
    [label.layer insertSublayer:backLayer atIndex:0];
    
    label.backgroundColor = [UIColor lightGrayColor];
    label.layer.cornerRadius = 18 ;
    label.textColor = [UIColor whiteColor];
    label.labelSpacing = 30; // distance between start and end labels
    label.pauseInterval = 0; // seconds of pause before scrolling starts again
    label.scrollSpeed = 30; // pixels per second
    label.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
    label.fadeLength = 30.f;
    label.scrollDirection = CBAutoScrollDirectionLeft;
    label.font = [UIFont systemFontOfSize:13];
    [label observeApplicationNotifications];

    [self.view addSubview:label];
    _titleLbl = label ;
}

- (void)registerObserver
{
    __weak typeof(self) weakSelf = self ;
   _observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"changeText" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.titleLbl.text = note.object ;
    }];
    
    _alphaObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"alpha" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [UIView commitAnimations];
        weakSelf.titleLbl.alpha = 0 ;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1 animations:^{
                weakSelf.titleLbl.alpha = 1 ;
            }];
        });
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_observer name:@"changeText" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_alphaObserver name:@"alpha" object:nil];

}

@end
