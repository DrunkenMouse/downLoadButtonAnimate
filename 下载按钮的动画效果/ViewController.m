//
//  ViewController.m
//  下载按钮的动画效果
//
//  Created by 王奥东 on 16/7/20.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ViewController.h"
#import "ADDownloaderButton/ADDownloaderButton.h"

//动画效果是由一个按钮添加一个View完成的
//除了最后的成功图标
//全部都是画的，包括箭头
//进度值nowprogress是只读的，保证每次开始都是从0开始
//可以通过调用buttonProgressView的setNextProgress设置进度的最大值
//其实就是属性nextProgress的重写
//然后通过按钮的点击事件来调用buttonProgressView里面调用的动画
//使用CADisplayLink刷新动画
//通过一层层的[UIView animateWithduration]实现动画展示时间
//光点向中间聚集是通过帧动画完成的，通过CAShapeLayer生成光点
//使用数学公式计算光点走过的路径，这个我是真的看不明白，太累了。。
//通过帧动画对路径进行封装而后添加给layer完成聚集的动画效果
//layer到达中心之后通过GCD的延迟操作两秒之后从父类移除
//中间的光圈是不断增大的，不增满是没有震动效果的
//因为self.nowprogress不等于1是不会调用[self endAnimation];方法
//而self.nowprogress会在进度动画的时候随着nextProgress改变而改变
//震动效果通过UIView动画与两个View：progressView与viewShot
//通过viewShot.transform = CGAffineTransformMakeScale修改其大小与alpha
//完成光圈变大变淡
//通过progressView变小变大再变小完成填充物的动画效果
//progressView就是中间从小变到大的填充物



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];

    ADDownloaderButton *btn = [[ADDownloaderButton alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    btn.center = self.view.center;
    [self.view addSubview:btn];
}

@end
