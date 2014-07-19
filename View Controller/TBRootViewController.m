//
//  TBRootViewController.m
//  TBURLImageViewExample
//
//  Created by Jarvis on 14-7-2.
//  Copyright (c) 2014年 com.thongbin. All rights reserved.
//

#import "TBRootViewController.h"
#import "TBURLImageView.h"

@interface TBRootViewController ()
{
    IBOutlet TBURLImageView *_firstURLImageView;
    
    IBOutlet TBURLImageView *_secondURLImageView;
}
@end

@implementation TBRootViewController

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
    self.view.backgroundColor = DEFAULT_THEME_COLOR;
    
    
    /*
     *  all the images come from network
     *
     *  If you create imageview this way and you want use the click function, you must turn off the xib autolayout
     */

    [_firstURLImageView setURLImageViewType:TBURLImageViewTypeClickWithAnimation];
    [_firstURLImageView setTag:999];
    [_firstURLImageView setPlaceHolderImage:[UIImage imageNamed:@"default"]];
    [_firstURLImageView setFailedImage:[UIImage imageNamed:@"failedImage"]];
    [_firstURLImageView setImageUrl:@"http://www.clker.com/cliparts/c/2/4/3/1194986855125869974rubik_s_cube_random_petr_01.svg.hi.png"];
    [_firstURLImageView setLayerCornerRadius:5.0];
    [_firstURLImageView setDidClicked:^(TBURLImageView *tbURLImage){
        NSLog(@"%li",(long)tbURLImage.tag);
    }];
    
    [_secondURLImageView setImageUrl:@"http://highslide.com/samples/full2.jpg"];
    [_secondURLImageView setLayerCornerRadius:_secondURLImageView.bounds.size.height/2];
    [_secondURLImageView setPlaceHolderImage:[UIImage imageNamed:@"default"]];
    [_secondURLImageView setFailedImage:[UIImage imageNamed:@"failedImage"]];
    _secondURLImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _secondURLImageView.layer.borderWidth = 2.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
