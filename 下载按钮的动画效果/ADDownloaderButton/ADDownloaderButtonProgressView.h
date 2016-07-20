//
//  ADDownloaderButtonProgressView.h
//  下载按钮的动画效果
//
//  Created by 王奥东 on 16/7/20.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADDownloaderButtonProgressView : UIView

@property(assign, nonatomic, readonly) BOOL isProgressing;
@property(assign, nonatomic, readonly) BOOL isComplete;
@property(assign, nonatomic, readonly) CGFloat nowprogress;

-(void)setNextProgress:(CGFloat)nextProgress;

@end
