//
//  ADDownloadMath.h
//  下载按钮的动画效果
//
//  Created by 王奥东 on 16/7/20.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ADDownloadMath : NSObject


+ (CGFloat) calcDistance: (CGPoint)x to: (CGPoint)y;

+ (CGPoint) calcControlPoint: (CGPoint)O1 and: (CGPoint)O2;
+ (CGPoint) calcControlPoint: (CGPoint)O1 and: (CGPoint)O2 random: (bool)isRandom;
+ (CGPoint) calcBeginPoint: (CGPoint)O radius: (CGFloat)r coefficent: (CGFloat)c;

@end
