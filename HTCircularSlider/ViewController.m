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
    // Do any additional setup after loading the view, typically from a nib.
    CGRect frame = CGRectInset(self.view.bounds, 20, 100);

    HTCircularSlider *subView = [[HTCircularSlider alloc] initWithFrame:frame];
    [self.view addSubview:subView];
    subView.handleImage = [UIImage imageNamed:@"handle.png"];
    [subView addTarget:self action:@selector( onValueChange: ) forControlEvents:UIControlEventValueChanged ];

}

- (void)onValueChange:(HTCircularSlider *)slider {
    NSLog(@"%f", slider.value);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
