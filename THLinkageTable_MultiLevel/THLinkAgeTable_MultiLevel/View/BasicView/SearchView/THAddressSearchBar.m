//
//  THAddressSearchBar.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/26.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THAddressSearchBar.h"

@interface THAddressSearchBar ()

@property (nonatomic,weak) UITextField *searchTF;
@property (nonatomic,weak) UIButton *searchBtn;


@end

@implementation THAddressSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        UITextField *searchTF = [[UITextField alloc] init];
        searchTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        searchTF.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        searchTF.backgroundColor = [UIColor clearColor];
        searchTF.layer.cornerRadius = 8;
        searchTF.clipsToBounds = YES ;
        searchTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        searchTF.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:searchTF];
        _searchTF = searchTF ;
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(searchBegin) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"搜索" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor greenColor]];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self addSubview:btn];
        _searchBtn = btn ;
        btn.layer.cornerRadius = 8;
        btn.clipsToBounds = YES ;
        btn.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    }
        return self ;
}

- (void)searchBegin
{
    if (self.searchBeginBlock) {
        self.searchBeginBlock(self.searchTF.text);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _searchTF.frame = CGRectMake( 8 , 8, self.bounds.size.width * 4/5 - 16 , self.bounds.size.height - 16);
    _searchBtn.frame = CGRectMake(_searchTF.frame.origin.x + _searchTF.frame.size.width + 8, 8, self.bounds.size.width/5 - 8, self.bounds.size.height - 16);
}

@end
