#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "FLAnimatedImage.h"

#import <React/RCTComponent.h>
#import <React/RCTResizeMode.h>

#import "FFFastImageSource.h"

@interface FFFastImageView : FLAnimatedImageView

@property(nonatomic, copy) RCTDirectEventBlock onFastImageError;
@property(nonatomic, copy) RCTDirectEventBlock onFastImageLoad;
@property(nonatomic, assign) RCTResizeMode resizeMode;
@property(nonatomic, strong) FFFastImageSource *source;

@end
