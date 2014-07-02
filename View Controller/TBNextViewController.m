//
//  TBNextViewController.m
//  TBURLImageViewExample
//
//  Created by Jarvis on 14-7-2.
//  Copyright (c) 2014年 com.thongbin. All rights reserved.
//

#import "TBNextViewController.h"
#import "TBURLImageView.h"

@interface TBNextViewController ()

@end

@implementation TBNextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:DEFAULT_THEME_COLOR];
    TBURLImageView *_urlimage = [[TBURLImageView alloc]initWithFrame:CGRectMake(20, 150, 100, 100)];
    [_urlimage setPlaceHolderImage:[UIImage imageNamed:@"default"]];
    [_urlimage setFailedImage:[UIImage imageNamed:@"failedImage"]];
    [_urlimage setImageUrl:@"http://www.ctvnews.ca/polopoly_fs/1.1061284!/httpImage/image.jpeg_gen/derivatives/landscape_620/image.jpeg"];
    [_urlimage setClickEnable:YES];
    [_urlimage setClickedImage:^(TBURLImageView *tb){
        NSLog(@"%@",tb);
    }];
    [self.view addSubview:_urlimage];
    
    TBURLImageView *_urlimage2 = [[TBURLImageView alloc]initWithFrame:CGRectMake(200, 150, 100, 100)];
    [_urlimage2 setPlaceHolderImage:[UIImage imageNamed:@"default"]];
    [_urlimage2 setFailedImage:[UIImage imageNamed:@"failedImage"]];
    [_urlimage2 setImageUrl:@"http://highslide.com/samples/full2.jpg"];
    [_urlimage2 setClickEnable:YES];
    [self.view addSubview:_urlimage2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
