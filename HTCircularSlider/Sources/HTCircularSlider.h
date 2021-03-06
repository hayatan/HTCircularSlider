//
//  HTCircularSlider.h
//  HTCircularSlider
//
//  Created by hayatan on 2014/10/26.
//  Copyright (c) 2014年 hayatan. All rights reserved.
//

//角度>>ラジアン変換
#if !defined(RADIANS)
#define RADIANS(F) (F * (float)M_PI / 180)
#endif
//ラジアン>>角度変換
#if !defined(DEGREES)
#define DEGREES(F) (F * 180 / (float)M_PI)
#endif

#import <UIKit/UIKit.h>

@interface HTCircularSlider : UIControl
@property(nonatomic) BOOL insideOnly;
@property(nonatomic) CGFloat value;
@property(nonatomic) CGFloat minimumValue;
@property(nonatomic) CGFloat maximumValue;
@property(nonatomic) CGFloat radius;
@property(nonatomic) CGFloat unFillRadius;
@property(nonatomic) CGFloat rotateAngle;
@property(nonatomic) CGFloat handleSize;
@property(nonatomic) CGFloat handlePosition;
@property(nonatomic, retain) UIColor *unFillColor;
@property(nonatomic, retain) UIColor *fillColor;
@property(nonatomic, retain) UIImage *handleImage;
@end
