//
//  TBURLImageView.h
//  csair-inspector
//
//  Created by Jarvis on 14-7-1.
//  Copyright (c) 2014年 com.thongbin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TBURLImageViewType){
    TBURLImageViewTypeDefault,
    TBURLImageViewTypeClick,
    TBURLImageViewTypeClickWithAnimation,
};

@interface TBURLImageView : UIImageView

@property (nonatomic,assign)TBURLImageViewType URLImageViewType;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,strong) void(^didClicked)(TBURLImageView *URLImageView);

- (instancetype)initWithFrame:(CGRect)frame ByType:(TBURLImageViewType)URLImageViewType;

-(void)setPlaceHolderImage:(UIImage *)placeHolderImage;
-(void)setFailedImage:(UIImage *)failedImage;
-(void)setLayerCornerRadius:(float)radius;
@end
