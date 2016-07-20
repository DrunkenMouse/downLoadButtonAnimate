//
//  ADDownloaderButton.m
//  下载按钮的动画效果
//
//  Created by 王奥东 on 16/7/20.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADDownloaderButton.h"
#import "ADDownloaderButtonProgressView.h"

@interface ADDownloaderButton()

@property(nonatomic, strong)CAShapeLayer *arrow;
@property(nonatomic, strong)ADDownloaderButtonProgressView *p;

@end



@implementation ADDownloaderButton

#pragma mark - 按钮的初始化
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.p = [[ADDownloaderButtonProgressView alloc]initWithFrame:frame];
        [self addSubview:self.p];
        
        [self addTarget:self action:@selector(startUpDownLoadAction) forControlEvents:UIControlEventTouchUpInside];
    
        [self test];
    }
    return self;
}

#pragma mark - 绘制箭头


-(UIBezierPath *)drawArrow {
    
    CGFloat startPos = self.frame.size.width / 3.f;
    CGFloat centerPos = self.frame.size.height / 2.f;
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(centerPos, startPos)];
    [path addLineToPoint:CGPointMake(centerPos, 2 *startPos)];
    [path addLineToPoint:CGPointMake(startPos, centerPos)];
    [path moveToPoint:CGPointMake(centerPos, 2 * startPos)];
    [path addLineToPoint:CGPointMake(2 * startPos, centerPos)];
    
    return path;
}


-(void)test{
    self.arrow = [CAShapeLayer layer];
    self.arrow.strokeColor = ADDownloaderButtonDefaultColor.CGColor;
    self.arrow.lineWidth = 3;
    //设置路径线条端点为圆形
    self.arrow.lineJoin = kCALineJoinRound;
    //设置路径线条交界处为圆形
    self.arrow.lineCap = kCALineCapRound;
    self.arrow.path = [self drawArrow].CGPath;
    [self.layer addSublayer:self.arrow];
    
}


-(void)startUpDownLoadAction{


    
    [self.p setNextProgress: 1];

    [self.arrow removeFromSuperlayer];
}










@end
