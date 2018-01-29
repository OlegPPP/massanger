//
//  MyPhotoMediaItem.h
//  ChatDemo
//
//  Created by Neo on 5/21/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <JSQMediaItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyPhotoMediaItem : JSQMediaItem <JSQMessageMediaData, NSCoding, NSCopying>

/**
 *  The image for the photo media item. The default value is `nil`.
 */
@property (copy, nonatomic, nullable) UIImage *image;

/**
 *  Initializes and returns a photo media item object having the given image.
 *
 *  @param image The image for the photo media item. This value may be `nil`.
 *
 *  @return An initialized `JSQPhotoMediaItem`.
 *
 *  @discussion If the image must be dowloaded from the network,
 *  you may initialize a `JSQPhotoMediaItem` object with a `nil` image.
 *  Once the image has been retrieved, you can then set the image property.
 */
- (instancetype)initWithImage:(nullable UIImage *)image withBubbleImage:(UIImage *)bubbleImage;

@end
NS_ASSUME_NONNULL_END
