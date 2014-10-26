//
//  HTCircularSlider.m
//  HTCircularSlider
//
//  Created by hayatan on 2014/10/26.
//  Copyright (c) 2014年 hayatan. All rights reserved.
//

#import "HTCircularSlider.h"

@implementation HTCircularSlider {
    CGPoint _origin;
    UIView *_handleView;
    UIImageView *_handleImageView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setValue:(CGFloat)value {
    _value = value;
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    if (_handleView) {
        CGRect handleViewFrame = CGRectMake(_origin.x - _handleSize / 2, _origin.y - _radius  - _handleSize / 2, _handleSize, _radius * 2 + _handleSize);
        _handleView.frame = handleViewFrame;
    }
}

- (void)setHandleSize:(CGFloat)handleSize {
    _handleSize = handleSize;
    if (_handleView) {
        CGRect handleViewFrame = CGRectMake(_origin.x - _handleSize / 2, _origin.y - _radius  - _handleSize / 2, _handleSize, _radius * 2 + _handleSize);
        _handleView.frame = handleViewFrame;
    }
    if (_handleImageView) {
        _handleImageView.frame = CGRectMake(0, _handlePosition, _handleSize, _handleSize);
    }
}

- (void)setHandlePosition:(CGFloat)handlePosition {
    _handlePosition = handlePosition;
    if (_handleImageView) {
        _handleImageView.frame = CGRectMake(0, _handlePosition, _handleSize, _handleSize);
    }
}

- (void)setHandleImage:(UIImage *)handleImage {
    _handleImage = handleImage;
    if (_handleImageView) {
        _handleImageView.image = handleImage;
    }
}

- (void)setup {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.rotateAngle = 0;
    self.value = 0.0;
    self.minimumValue = 0.0;
    self.maximumValue = 1.0;
    self.unFillColor = [UIColor grayColor];
    self.fillColor = [UIColor purpleColor];
    self.handleSize = 20;
    self.handlePosition = 10;

    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    self.radius = w < h ? w / 2 : h / 2;
    _origin = CGPointMake(w/2, h/2);
    CGRect handleViewFrame = CGRectMake(_origin.x - _handleSize / 2, _origin.y - _radius  - _handleSize / 2, _handleSize, _radius * 2 + _handleSize);

    _handleView = [[UIView alloc] initWithFrame:handleViewFrame];
    [self addSubview:_handleView];

    _handleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _handlePosition, _handleSize, _handleSize)];
    _handleImageView.contentMode = UIViewContentModeScaleToFill;

    [_handleView addSubview:_handleImageView];
    self.handleImage = [UIImage imageNamed:@"handle.png"];

    /**
    * This tapGesture isn't used yet but will allow to jump to a specific location in the circle
    */
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHappened:)];
    [self addGestureRecognizer:tapGestureRecognizer];

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHappened:)];
    panGestureRecognizer.maximumNumberOfTouches = panGestureRecognizer.minimumNumberOfTouches;
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)panGestureHappened:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint point = [panGestureRecognizer locationInView:self];

    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateChanged:
            self.value = [self angleFromPoint:point] / 360 * (_maximumValue - _minimumValue);
            break;
        case UIGestureRecognizerStateEnded:
            if ([self isPointInside:point]) {
                [self sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            else {
                [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
            }
            break;
        default:
            break;
    }
}

- (void)tapGestureHappened:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint point = [tapGestureRecognizer locationInView:self];
    self.value = [self angleFromPoint:point] / 360 * (_maximumValue - _minimumValue);
}

- (BOOL)isPointInside:(CGPoint)point
{

    CGRect thumbTouchRect = CGRectMake(_origin.x - _radius, _origin.y - _radius, _radius*2, _radius*2);
    return CGRectContainsPoint(thumbTouchRect, point);
}

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
        _handleView.transform = CGAffineTransformMakeRotation(([self angleFromValue:_value] + _rotateAngle) * ((float)M_PI / 180));
    }
}

- (void)drawUnFill:(CGContextRef)context
{
    CGContextBeginPath(context);
    [_unFillColor setFill];
    CGContextAddArc(context, _origin.x, _origin.y, _radius, 0, 2 * (float)M_PI, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void)drawArc:(CGFloat)value inContext:(CGContextRef)context
{
    CGContextBeginPath(context);
    [_fillColor setFill];
    CGFloat modAngle = [self angleFromValue:value] + _rotateAngle;
    CGContextAddArc(context, _origin.x, _origin.y, _radius, RADIANS(_rotateAngle) - (float)M_PI_2, RADIANS(modAngle) - (float)M_PI_2, 0);
    CGContextAddLineToPoint(context, _origin.x, _origin.y);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

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
    CGFloat radian = atan2f(p2.x - p1.x, p2.y - p1.y);
    CGFloat degree = radian * 180 / (float)M_PI;
    return degree;
}

@end
