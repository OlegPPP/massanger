//
//  MyBubblesSizeCalculator.m
//  JSQMessages
//
//  Created by Neo on 5/18/17.
//  Copyright © 2017 Hexed Bits. All rights reserved.
//

#import "MyBubblesSizeCalculator.h"

#import "JSQMessagesCollectionView.h"
#import "JSQMessagesCollectionViewDataSource.h"
#import "JSQMessagesCollectionViewFlowLayout.h"
#import "JSQMessageData.h"

#import "UIImage+JSQMessages.h"


@interface MyBubblesSizeCalculator ()

@property (strong, nonatomic, readonly) NSCache *cache;

@property (assign, nonatomic, readonly) NSUInteger minimumBubbleWidth;

@property (assign, nonatomic, readonly) NSInteger additionalInset;


@end


@implementation MyBubblesSizeCalculator

#pragma mark - Init

- (instancetype)init
{
    NSCache *cache = [NSCache new];
    cache.name = @"JSQMessagesBubblesSizeCalculator.cache";
    cache.countLimit = 200;
    
    self = [super init];
    if (self) {
        _cache = cache;
        
        _usesCache = NO;
        
        // this extra inset value is needed because `boundingRectWithSize:` is slightly off
        // see comment below
        _additionalInset = 2;
    }
    return self;
}

#pragma mark - JSQMessagesBubbleSizeCalculating

- (void)prepareForResettingLayout:(JSQMessagesCollectionViewFlowLayout *)layout
{
    [self.cache removeAllObjects];
}

- (CGSize)messageBubbleSizeForMessageData:(id<JSQMessageData>)messageData
                              atIndexPath:(NSIndexPath *)indexPath
                               withLayout:(JSQMessagesCollectionViewFlowLayout *)layout
{
    if (_usesCache) {
        NSValue *cachedSize = [self.cache objectForKey:@([messageData messageHash])];
        if (cachedSize != nil) {
            return [cachedSize CGSizeValue];
        }
    }
    
    CGSize finalSize = CGSizeZero;
    
    if ([messageData isMediaMessage]) {
        finalSize = [[messageData media] mediaViewDisplaySize];
    }
    else {
        CGSize avatarSize = [self jsq_avatarSizeForMessageData:messageData withLayout:layout];
        
        //  from the cell xibs, there is a 2 point space between avatar and bubble
        CGFloat spacingBetweenAvatarAndBubble = 2.0f;
        CGFloat horizontalContainerInsets = layout.messageBubbleTextViewTextContainerInsets.left + layout.messageBubbleTextViewTextContainerInsets.right;
        CGFloat horizontalFrameInsets = layout.messageBubbleTextViewFrameInsets.left + layout.messageBubbleTextViewFrameInsets.right;
        
        CGFloat horizontalInsetsTotal = horizontalContainerInsets + horizontalFrameInsets + spacingBetweenAvatarAndBubble;
        CGFloat maximumTextWidth = [self textBubbleWidthForLayout:layout] - avatarSize.width - layout.messageBubbleLeftRightMargin - horizontalInsetsTotal;
        
        CGRect stringRect = [[messageData text] boundingRectWithSize:CGSizeMake(maximumTextWidth, CGFLOAT_MAX)
                                                             options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                          attributes:@{ NSFontAttributeName : layout.messageBubbleFont }
                                                             context:nil];
        
        CGSize stringSize = CGRectIntegral(stringRect).size;
        stringSize.width = maximumTextWidth;
        
        CGFloat verticalContainerInsets = layout.messageBubbleTextViewTextContainerInsets.top + layout.messageBubbleTextViewTextContainerInsets.bottom;
        CGFloat verticalFrameInsets = layout.messageBubbleTextViewFrameInsets.top + layout.messageBubbleTextViewFrameInsets.bottom;
        
        //  add extra 2 points of space (`self.additionalInset`), because `boundingRectWithSize:` is slightly off
        //  not sure why. magix. (shrug) if you know, submit a PR
        CGFloat verticalInsets = verticalContainerInsets + verticalFrameInsets + self.additionalInset;
        
        //  same as above, an extra 2 points of magix
        CGFloat finalWidth = stringSize.width + horizontalInsetsTotal + self.additionalInset;
        
        finalSize = CGSizeMake(finalWidth, stringSize.height + verticalInsets);
        
        // timestamp
        __block CGRect lastUsedRect = CGRectNull, lastRect = CGRectNull;
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, maximumTextWidth + horizontalContainerInsets + spacingBetweenAvatarAndBubble + _additionalInset, stringSize.height)];
        textView.font = layout.messageBubbleFont;
        textView.textContainerInset = layout.messageBubbleTextViewTextContainerInsets;
        textView.contentOffset = CGPointZero;
        textView.textContainer.lineFragmentPadding = 0;
        
        textView.text = [messageData text];
        
        [[textView layoutManager] enumerateLineFragmentsForGlyphRange:NSMakeRange(0, [messageData text].length) usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer * _Nonnull textContainer, NSRange glyphRange, BOOL * _Nonnull stop) {
            lastUsedRect = usedRect;
            lastRect = rect;
        }];
        
        if (!CGRectIsEmpty(lastUsedRect) && !CGRectIsEmpty(lastRect)) {
            CGFloat emptyWidth = lastRect.size.width - lastUsedRect.size.width;
            if (emptyWidth < 40)
                finalSize.height += 15;
        }
    }
    
    if (_usesCache)
        [self.cache setObject:[NSValue valueWithCGSize:finalSize] forKey:@([messageData messageHash])];
    
    return finalSize;
}

- (CGSize)jsq_avatarSizeForMessageData:(id<JSQMessageData>)messageData
                            withLayout:(JSQMessagesCollectionViewFlowLayout *)layout
{
    NSString *messageSender = [messageData senderId];
    
    if ([messageSender isEqualToString:[layout.collectionView.dataSource senderId]]) {
        return layout.outgoingAvatarViewSize;
    }
    
    return layout.incomingAvatarViewSize;
}

- (CGFloat)textBubbleWidthForLayout:(JSQMessagesCollectionViewFlowLayout *)layout
{
    return layout.itemWidth;
}

@end
