//
//  TBURLImageView.m
//  csair-inspector
//
//  Created by Jarvis on 14-7-1.
//  Copyright (c) 2014年 com.thongbin. All rights reserved.
//

#import "TBURLImageView.h"

static const float kScale_x = 0.90;
static const float kScale_y = 0.90;
static const float kDuration = 0.06;
static NSCache *_cache = nil;

@implementation TBURLImageView
{
    UIImage *_placeHolderImage;
    UIImage *_failedImage;
    UIActivityIndicatorView *_indicatorView;
   
    NSFileManager *_fileManager;
    NSString *_fileName;
    NSString *_filePath;
    NSString *_fileType;
    NSURLSession *_session;
    
    UITapGestureRecognizer *_tapRecognizer;
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSomething];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSomething];
    }
    return self;
}

-(void)initSomething
{
    // do something ,you know.
    
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicatorView.frame = self.bounds;
    _indicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _indicatorView.hidesWhenStopped = YES;
    
    self.clipsToBounds = YES;
    
    _placeHolderImage = nil;
    _failedImage = nil;
    _filePath = nil;
    
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _cache = [[NSCache alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
            
            [_cache removeAllObjects];
            
        }];
    });
}

-(void)setClickEnable:(BOOL)clickEnable
{
    // if u want to click the image , set it to yes and do not forget set the clicked block.
    if (clickEnable) {
        [self setUserInteractionEnabled:clickEnable];
        _tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapEvent)];
        [self addGestureRecognizer:_tapRecognizer];
    }
}

-(void)setClickAnimationEnable:(BOOL)clickAnimationEnable
{
    _clickAnimationEnable = clickAnimationEnable;
}

-(void)setImageUrl:(NSString *)imageUrl
{
    if (!imageUrl) {
        return;
    }
    
    _imageUrl = imageUrl;
    [self disposeImageUrl];
    
    if (_fileName) {
        NSData *_data = [self readForKey:_fileName];
        if (_data) {
            self.image = [UIImage imageWithData:_data];
            [self setNeedsDisplay];
        }else{
            [self downloadImage];
        }
    }
    
    
}

-(void)disposeImageUrl
{
    //take the filename & filetype from the url string
    
    NSArray *_urlComponents = [_imageUrl componentsSeparatedByString:@"/"];
    NSString *_lastComponent = [_urlComponents lastObject];
    NSArray *_name_type = [_lastComponent componentsSeparatedByString:@"."];
    
    if ([_name_type count] >= 2) {
        _fileName = [_name_type firstObject];
        _fileType = [_name_type lastObject];
    }
}

#pragma mark - Asy Download
-(void)downloadImage
{
    //Asy download
    _session = [NSURLSession sharedSession];
    NSURLSessionDataTask *_dataTask = [_session dataTaskWithURL:[NSURL URLWithString:_imageUrl]
                                              completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
                                                  
                                                  [self downloadCompletion:data Response:response Error:error];
                                                  
                                              }];
    [self addSubview:_indicatorView];
    [_indicatorView startAnimating];
    [_dataTask resume];
}

-(void)downloadCompletion:(NSData *)data Response:(NSURLResponse *)response Error:(NSError *)error
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [_indicatorView stopAnimating];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if ([httpResponse statusCode] == 200) {
            if (data) {
                self.image = [UIImage imageWithData:data];
                [self setNeedsDisplay];
                [self cachesImage:data forKey:_fileName];
                
            } else {
                self.image = _failedImage;
            }
        } else {
            self.image = _failedImage;
        }
    });
}


#pragma mark - Cahces & Read
-(void)cachesImage:(NSData*)data forKey:(NSString*)key
{
    //caches the data into NSCache first , wirte into file second
    
    [self filePathForKey:key];
    [_cache setObject:data forKey:key];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [data writeToFile:_filePath atomically:YES];
    });
}

-(NSData*)readForKey:(NSString*)key
{
    //reads the image data from the NSCache , if not exist , get data from file
    
    if(key == nil){
        return nil;
    }
    
    NSData *cacheData = [_cache objectForKey:key];
    
    if(cacheData){
        
        NSLog(@"get data from cache");
        return cacheData;
        
    }else{

        NSLog(@"miss data from cache");
        [self filePathForKey:key];
        NSData *fileData =  [[NSFileManager defaultManager] contentsAtPath:_filePath];
        
        if(fileData){
            
            [_cache setObject:fileData forKey:key];
            
        }
        return fileData;
    }
    
}

-(void)filePathForKey:(NSString*)key
{
    
    //Get the path of Caches , will caches the image data to the path
    
    NSArray *_pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *TBURLImageCachesDirectory = [[_pathArray objectAtIndex:0] stringByAppendingPathComponent:@"TBURLImageCaches"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:TBURLImageCachesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    _filePath = [TBURLImageCachesDirectory stringByAppendingPathComponent:key];
    
}

#pragma mark - Expose method

-(void)setLayerCornerRadius:(float)radius
{
    self.layer.cornerRadius = radius;
    self.layer.opaque = YES;
}

-(void)setPlaceHolderImage:(UIImage *)placeHolderImage
{
    _placeHolderImage = placeHolderImage;
    if (!self.image) {
        self.image = _placeHolderImage;
    }
}

-(void)setFailedImage:(UIImage *)failedImage
{
    _failedImage = failedImage;
}

#pragma mark - UITapGestureRecognizer handle
-(void)handleTapEvent
{
    if (_clickAnimationEnable) {
        [UIView animateWithDuration:kDuration
                         animations:^(){
                             self.transform = CGAffineTransformMakeScale(kScale_x, kScale_y);
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:kDuration
                                              animations:^(){
                                                  self.transform = CGAffineTransformIdentity;
                                              }
                                              completion:^(BOOL finished){
                                                  if (_clickedImage) {
                                                      _clickedImage(self);
                                                  }
                                              }];
                         }];
    } else {
        
        if (_clickedImage) {
            _clickedImage(self);
        }
    }
}

@end
