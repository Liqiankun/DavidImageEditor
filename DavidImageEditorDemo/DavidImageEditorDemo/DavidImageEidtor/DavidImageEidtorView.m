//
//  DavidImageEidtorView.m
//  DavidImageEditorDemo
//
//  Created by DavidLee on 16/1/20.
//  Copyright © 2016年 DavidLee. All rights reserved.
//

#import "DavidImageEidtorView.h"
#import "UIImage+Rotation.h"
@interface DavidImageEidtorView ()


@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,assign) CGSize originalImageViewSize;

@end

@implementation DavidImageEidtorView

- (id)initWithFrame:(CGRect)frame withImage:(UIImage*)image {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = frame;
        [self setup];
        
        self.image = [self fixOrientation:image];
        float _imageScale = self.frame.size.width / self.image.size.width;
        self.imageView.frame = CGRectMake(0, 0, self.image.size.width * _imageScale, self.image.size.height * _imageScale);
        _originalImageViewSize = CGSizeMake(self.image.size.width*_imageScale, self.image.size.height*_imageScale);
        self.imageView.image = self.image;
        self.imageView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        
    }
    
    return self;
}

- (void)setup
{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    self.imageView.userInteractionEnabled = YES;
    [self addSubview:self.imageView];
   
    UIPinchGestureRecognizer *scaleGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
    [self.imageView addGestureRecognizer:scaleGes];

    UIPanGestureRecognizer *moveGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
    [moveGes setMinimumNumberOfTouches:1];
    [moveGes setMaximumNumberOfTouches:1];
    [self.imageView addGestureRecognizer:moveGes];

}

float _lastTransX = 0.0, _lastTransY = 0.0;
- (void)moveImage:(UIPanGestureRecognizer *)sender
{
    CGPoint translatedPoint = [sender translationInView:self];
    
    if([sender state] == UIGestureRecognizerStateBegan) {
        _lastTransX = 0.0;
        _lastTransY = 0.0;
    }
    
    CGAffineTransform trans = CGAffineTransformMakeTranslation(translatedPoint.x - _lastTransX, translatedPoint.y - _lastTransY);
    CGAffineTransform newTransform = CGAffineTransformConcat(self.imageView.transform, trans);
    _lastTransX = translatedPoint.x;
    _lastTransY = translatedPoint.y;
    
    self.imageView.transform = newTransform;
}

float _lastScale = 1.0;
- (void)scaleImage:(UIPinchGestureRecognizer *)sender
{
    if([sender state] == UIGestureRecognizerStateBegan) {
        
        _lastScale = 1.0;
        return;
    }
    
    CGFloat scale = [sender scale]/_lastScale;
    
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [self.imageView setTransform:newTransform];
    
    _lastScale = [sender scale];
}

-(void)rotateImage
{
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,M_PI/2);
    [self.imageView setTransform:newTransform];
    
}

- (void)finishEditing
{
    float zoomScale = [[self.imageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
    float rotate = [[self.imageView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
    
    float _imageScale = self.image.size.width/_originalImageViewSize.width;
    CGSize cropSize = CGSizeMake(self.frame.size.width/zoomScale, self.frame.size.height/zoomScale);
    CGPoint cropperViewOrigin = CGPointMake((0.0 - self.imageView.frame.origin.x)/zoomScale,
                                            (0.0 - self.imageView.frame.origin.y)/zoomScale);
    
    if((NSInteger)cropSize.width % 2 == 1)
    {
        cropSize.width = ceil(cropSize.width);
    }
    if((NSInteger)cropSize.height % 2 == 1)
    {
        cropSize.height = ceil(cropSize.height);
    }
    
    CGRect CropRectinImage = CGRectMake((NSInteger)(cropperViewOrigin.x*_imageScale) ,(NSInteger)( cropperViewOrigin.y*_imageScale), (NSInteger)(cropSize.width*_imageScale),(NSInteger)(cropSize.height*_imageScale));
    
    UIImage *rotInputImage = [self.image imageRotatedByRadians:rotate];
    CGImageRef tmp = CGImageCreateWithImageInRect([rotInputImage CGImage], CropRectinImage);
    self.croppedImage = [UIImage imageWithCGImage:tmp scale:self.image.scale orientation:self.image.imageOrientation];
    CGImageRelease(tmp);
}


/** 解决拍照时编辑图片自动旋转90°问题  */
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



- (void)dealloc {
    self.image = nil;
    self.croppedImage = nil;
    self.imageView = nil;
}






@end
