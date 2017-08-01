#import "FFFastImageView.h"

@implementation FFFastImageView

- (void)setResizeMode:(RCTResizeMode)resizeMode
{
    if (_resizeMode != resizeMode) {
        _resizeMode = resizeMode;
        self.contentMode = (UIViewContentMode)resizeMode;
        [self reloadImage:_source];
    }
}
    
- (void)setOnFastImageError:(RCTDirectEventBlock)onFastImageError {
    if (![_onFastImageError isEqual: onFastImageError]) {
        _onFastImageError = onFastImageError;
        [self reloadImage:_source];
    }
}
    
- (void)setOnFastImageLoad:(RCTDirectEventBlock)onFastImageLoad {
    if (![_onFastImageLoad isEqual: onFastImageLoad]) {
        _onFastImageLoad = onFastImageLoad;
        [self reloadImage:_source];
    }
}

- (void)reloadImage:(FFFastImageSource *)source {
    if (!self.source || !self.onFastImageLoad || !self.onFastImageError) {
        return;
    }
    [source.headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString* header, BOOL *stop) {
        [[SDWebImageDownloader sharedDownloader] setValue:header forHTTPHeaderField:key];
    }];
    
    // Set priority.
    SDWebImageOptions options = 0;
    options |= SDWebImageRetryFailed;
    switch (source.priority) {
        case FFFPriorityLow:
        options |= SDWebImageLowPriority;
        break;
        case FFFPriorityNormal:
        // Priority is normal by default.
        break;
        case FFFPriorityHigh:
        options |= SDWebImageHighPriority;
        break;
    }
    
    // Load the new source.
    [self sd_setImageWithURL:source.uri
            placeholderImage:nil
                     options:options
                   completed:^(UIImage *image,
                               NSError *error,
                               SDImageCacheType cacheType,
                               NSURL *imageURL) {
                       if (error) {
                           if (_onFastImageError) {
                               _onFastImageError(@{});
                           }
                       } else {
                           if (_onFastImageLoad) {
                               _onFastImageLoad(@{});
                           }
                       }
                   }];
}

- (void)setSource:(FFFastImageSource *)source {
    if (![_source isEqual:source]) {
        _source = source;
        [self reloadImage:source];
    }
}

@end
