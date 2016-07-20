//
//  ADDownloaderButtonProgressView.m
//  下载按钮的动画效果
//
//  Created by 王奥东 on 16/7/20.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADDownloaderButtonProgressView.h"

#import "ADDownloadMath.h"

#define ADDownloaderButtonDefaultColor [UIColor colorWithRed: 50 / 255.f green: 171 / 255.f blue: 155 / 255.f alpha: 1]
#define eps 1e-6

@interface ADDownloaderButtonProgressView()

@property(nonatomic, strong) UIView *progressView;
@property(nonatomic, strong) UIImageView *successView;
@property(nonatomic, strong) CADisplayLink *gameTime;
@property(assign,nonatomic,readonly) CGFloat nextProgress;
@property(assign,nonatomic,readonly) CGPoint circlePoint;
@property (assign,nonatomic,readonly) CGFloat circleRadius;
@property(assign,nonatomic,readonly) NSUInteger count;

@end

@implementation ADDownloaderButtonProgressView

#pragma mark - Override
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //绘制边框
        [self drawCircleBorder];
        [self addSubview:self.progressView];
        
        //几何量初始化
        _circlePoint = self.center;
        _circleRadius = self.frame.size.width / 2.f;
        _count = 0;
        
        //参数初始化
        _isProgressing = YES;
        _isComplete = NO;
        [self setNextProgress:0.0f];
        [self setNowprogress:0.0f];
        [self addSubview:self.successView];
        
        self.userInteractionEnabled = NO;
        
    }
    return self;
}

#pragma mark - 懒加载


-(UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc]initWithFrame:self.bounds];
        _progressView.center = self.center;
        _progressView.backgroundColor = ADDownloaderButtonDefaultColor;
        _progressView.layer.cornerRadius = _progressView.frame.size.width / 2.f;
        _progressView.transform = CGAffineTransformMakeScale(0, 0);
    }
    return _progressView;
}

-(UIImageView *)successView{
    if (!_successView) {
        
        _successView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checkmark3"]];
        
        
        _successView.frame = CGRectMake(0, 0, self.frame.size.width / 2.f, self.frame.size.width / 2.f);
        _successView.alpha = 0;
        _successView.center = self.center;
    }
    return _successView;
}

#pragma mark - Override
-(void)setNextProgress:(CGFloat)nextProgress{
    _nextProgress = nextProgress;
    [self useShapeLayer];

}
-(void)setNowprogress:(CGFloat)nowprogress{
    _nowprogress = nowprogress;
}



#pragma mark - 绘制边框
-(void)drawCircleBorder {
    
    self.layer.borderWidth = 3.f;
    self.layer.borderColor = ADDownloaderButtonDefaultColor.CGColor;
    self.layer.cornerRadius = self.frame.size.width / 2;
}


#pragma mark - 进度动画
-(void) useShapeLayer {
    
    _isProgressing = YES;
//  1e-6  1*10的-6次方
    if (fabs(self.nextProgress - self.nowprogress) > eps) {
    
        [UIView animateWithDuration:6.18f * fabs(self.nextProgress - self.nowprogress) delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _progressView.transform = CGAffineTransformMakeScale(self.nextProgress, self.nextProgress);
              [self startAnimation];
        } completion:^(BOOL finished) {
            self.nowprogress = self.nextProgress;
            _isProgressing = NO;
            if (self.nowprogress == 1) {
                _isComplete = YES;
                [self endAnimation];
            }
            
        }];
        
        
    }
}


#pragma mark - 动画开启入口
-(void)startAnimation {
    if (self.gameTime != nil) {
        [self stopAnimation];
    }
    self.gameTime = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshAnimation)];
    
    [self.gameTime addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - 动画关闭方法
- (void) stopAnimation {
    
    [self.gameTime invalidate];
    self.gameTime = nil;
}


#pragma mark - 刷新动画，判断是否需要增加动点
-(void)refreshAnimation{
    if (!self.isProgressing) {
        [self stopAnimation];
    }
    _count ++;
    _count %= 50;
    if (_count == 40) {
        [self readyPointAnimation:[ADDownloadMath calcBeginPoint:self.circlePoint radius:self.circleRadius coefficent:2.0f]];
    }
}

#pragma mark - 进入动画，传入起始坐标点
-(void)readyPointAnimation: (CGPoint) center{
    
    CGFloat pointRadius = 8.f;
    CALayer *shape = [[CALayer alloc]init];
    shape.backgroundColor = ADDownloaderButtonDefaultColor.CGColor;
    shape.cornerRadius = pointRadius;
    shape.frame = CGRectMake(center.x, center.y, pointRadius * 2, pointRadius * 2);
    [self.layer addSublayer:shape];
    [self runPointAnimation:shape];
}

#pragma mark - 启动动画，向中心吸收

-(void)runPointAnimation:(CALayer *)point{
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.path = [self makePointPath:point].CGPath;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    keyAnimation.duration = 2;
    keyAnimation.removedOnCompletion = NO;
    [point addAnimation:keyAnimation forKey:@"moveAnimation"];
    
    double delay = 2;
    dispatch_time_t popTiome = dispatch_time(DISPATCH_TIME_NOW, (int64_t)delay *NSEC_PER_SEC);
    dispatch_after(popTiome, dispatch_get_main_queue(), ^{
        [point removeFromSuperlayer];
    });
    
}

#pragma mark - 生成曲线路径

-(UIBezierPath *)makePointPath: (CALayer *)point{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point.position];

    [path addQuadCurveToPoint:self.circlePoint controlPoint:[ADDownloadMath calcControlPoint:self.circlePoint and:point.position random:YES]];
    return path;
}

#pragma mark - 结束动画

-(void)endAnimation{
    
    self.layer.borderColor = [UIColor clearColor].CGColor;
    UIView *viewShot = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.progressView ]];
    viewShot.alpha = 0.4f;
    
    viewShot.layer.cornerRadius = viewShot.frame.size.width / 2.f;
    viewShot.transform = CGAffineTransformMakeScale(.9, .9);
    [self addSubview:viewShot];
   
    [UIView animateWithDuration:.9 delay:1.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _progressView.transform = CGAffineTransformMakeScale(.9, .9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.1 animations:^{
        
            viewShot.transform = CGAffineTransformMakeScale(3, 3);
            viewShot.alpha = 0;
            self.successView.alpha = 1;
      
        } completion:^(BOOL finished) {
            [viewShot removeFromSuperview];
        }];
        

        [UIView animateWithDuration:1.f delay:0.2 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressView.transform = CGAffineTransformMakeScale(1.8, 1.8);
            _progressView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            
        }];
    }];
}







@end
