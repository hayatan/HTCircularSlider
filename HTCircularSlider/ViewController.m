//
//  ViewController.m
//  HTCircularSlider
//
//  Created by hayatan on 2014/10/26.
//  Copyright (c) 2014年 hayatan. All rights reserved.
//

#import "ViewController.h"
#import "HTCircularSlider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional initialSetup after loading the view, typically from a nib.
    CGRect frame = CGRectInset(self.view.bounds, 0, 0);

    HTCircularSlider *slider = [[HTCircularSlider alloc] initWithFrame:frame];
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(onValueChange:) forControlEvents:UIControlEventValueChanged];
    slider.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    slider.unFillColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4];
    slider.fillColor = [UIColor colorWithRed:0.7 green:0.3 blue:0.1 alpha:0.4];
    slider.handleSize = 40;
    slider.maximumValue = 72;
    slider.value = 6;

    slider.radius = frame.size.width/2 - 30;
    slider.unFillRadius = frame.size.width/2 - 30;
}

- (void)onValueChange:(HTCircularSlider *)slider {
    NSLog(@"%f", slider.value);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
