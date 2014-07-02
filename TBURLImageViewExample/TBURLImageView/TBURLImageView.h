//
//  TBURLImageView.h
//  csair-inspector
//
//  Created by Jarvis on 14-7-1.
//  Copyright (c) 2014年 com.thongbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBURLImageView : UIImageView

@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,assign) BOOL clickEnable;
@property (nonatomic,strong) void(^clickedImage)(TBURLImageView *tbURLImageView);

-(void)setPlaceHolderImage:(UIImage *)placeHolderImage;
-(void)setFailedImage:(UIImage *)failedImage;
-(void)setLayerCornerRadius:(float)radius;
@end
