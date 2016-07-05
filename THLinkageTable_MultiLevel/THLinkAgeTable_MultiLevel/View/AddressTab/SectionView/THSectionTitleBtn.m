//
//  THSectionTitleBtn.m
//  THLinkageTable_MultiLevel
//
//  Created by litianhao on 16/5/29.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THSectionTitleBtn.h"


@implementation THSectionTitleBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [super imageRectForContentRect:contentRect];
    frame.origin.x = 8 ;
    return frame ;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [self imageRectForContentRect:contentRect];
    CGRect frameTitle =  [super titleRectForContentRect:contentRect] ;
    frameTitle.origin.x = frame.origin.x + frame.size.width + 8 ;
    return frameTitle ;
}

@end
