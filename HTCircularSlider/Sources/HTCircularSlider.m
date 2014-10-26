//
//  HTCircularSlider.m
//  HTCircularSlider
//
//  Created by hayatan on 2014/10/26.
//  Copyright (c) 2014年 hayatan. All rights reserved.
//

#import "HTCircularSlider.h"

@implementation HTCircularSlider {
    CGFloat _maxRadius;
    CGPoint _origin;
    UIView *_handleView;
    UIImageView *_handleImageView;
}

#pragma mark initializer
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialSetup];
    }
    return self;
}

#pragma mark setter
- (void)setValue:(CGFloat)value {
    _value = value;
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self updateSetup];
}

- (void)setUnFillRadius:(CGFloat)unFillRadius {
    _unFillRadius = unFillRadius;
    [self updateSetup];
}

- (void)setHandleSize:(CGFloat)handleSize {
    _handleSize = handleSize;
    [self updateSetup];
}

- (void)setHandlePosition:(CGFloat)handlePosition {
    _handlePosition = handlePosition;
    [self updateSetup];
}

- (void)setHandleImage:(UIImage *)handleImage {
    _handleImage = handleImage;
    [self updateSetup];
}

#pragma mark setup
- (void)initialSetup {
    // create subView instances
    _handleView = [[UIView alloc] init];
    _handleImageView = [[UIImageView alloc] init];
    _handleImageView.contentMode = UIViewContentModeScaleToFill;

    // add subViews
    [self addSubview:_handleView];
    [_handleView addSubview:_handleImageView];

    // calc parameters
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    _maxRadius = w < h ? w / 2 : h / 2;
    _origin = CGPointMake(w/2, h/2);

    // set colors
    self.insideOnly = NO;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.unFillColor = [UIColor grayColor];
    self.fillColor = [UIColor purpleColor];

    // set value params
    self.minimumValue = 0.0;
    self.maximumValue = 1.0;
    self.value = 0.0;

    // set appearance params
    self.rotateAngle = 0;

    // radius
    self.radius = _maxRadius;
    self.unFillRadius = _maxRadius;

    // handle
    self.handleSize = 20;
    self.handlePosition = 10;
    self.handleImage = [UIImage imageNamed:@"handle.png"];
}

- (void)updateSetup
{
    if (_handleView) {
        CGRect handleViewFrame =
                CGRectMake(_origin.x - _handleSize / 2, _origin.y - _radius  - _handleSize / 2,
                        _handleSize, _radius * 2 + _handleSize);
        _handleView.frame = handleViewFrame;
    }
    if (_handleImageView) {
        _handleImageView.frame = CGRectMake(0, _handlePosition, _handleSize, _handleSize);
    }
    if (_handleImageView) {
        _handleImageView.image = _handleImage;
    }
}

#pragma mark Touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (!_insideOnly || [self isPointInside:point]) {
        [self sendActionsForControlEvents:UIControlEventTouchDown];
        self.value = [self angleFromPoint:point] / 360 * (_maximumValue - _minimumValue);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if ([self isPointInside:point]) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        NSLog(@"UIControlEventTouchUpInside");
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
        NSLog(@"UIControlEventTouchUpOutside");
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.value = [self angleFromPoint:point] / 360 * (_maximumValue - _minimumValue);
}

- (BOOL)isPointInside:(CGPoint)point
{
    CGFloat distance = sqrtf(powf(point.x - _origin.x, 2) + powf(point.y - _origin.y, 2));
    return _radius >= distance;
}

#pragma mark Draw slider

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();  // コンテキストを取得
    [self drawUnFill:context];
    [self drawArc:_value inContext:context];
    [self transformHandle];
}

- (void)transformHandle
{
    if (_handleView) {
        _handleView.transform =
                CGAffineTransformMakeRotation(RADIANS(([self angleFromValue:_value] + _rotateAngle)));
    }
}

- (void)drawUnFill:(CGContextRef)context
{
    [_unFillColor setFill];
    CGRect borderRect = CGRectMake(_origin.x - _unFillRadius, _origin.y - _unFillRadius, _unFillRadius * 2, _unFillRadius * 2);
    CGContextFillEllipseInRect (context, borderRect);
    CGContextFillPath(context);
}

- (void)drawArc:(CGFloat)value inContext:(CGContextRef)context
{
    CGContextBeginPath(context);
    [_fillColor setFill];
    CGFloat modAngle = [self angleFromValue:value] + _rotateAngle;
    CGContextAddArc(context, _origin.x, _origin.y,
            _radius, RADIANS(_rotateAngle) - (float)M_PI_2, RADIANS(modAngle) - (float)M_PI_2, 0);
    CGContextAddLineToPoint(context, _origin.x, _origin.y);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

#pragma mark Common Utility

- (CGFloat)angleFromPoint:(CGPoint)point
{
    CGFloat angle = -([self degree:_origin Point2:point] - 180);
    if (angle < _rotateAngle) {
        angle = 360 + (angle - _rotateAngle);
    } else {
        angle = angle - _rotateAngle;
    }
    return angle;
}

- (CGFloat)angleFromValue:(CGFloat)value
{
    return 360 * value / (_maximumValue - _minimumValue);
}

- (CGFloat)degree:(CGPoint)p1 Point2:(CGPoint)p2
{
    return DEGREES(atan2f(p2.x - p1.x, p2.y - p1.y));
}

@end
