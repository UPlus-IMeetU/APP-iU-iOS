//
//  StitchImage.h
//  StitchingImage
//
//  Created by Jin on 10/9/15.
//  Copyright © 2015 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMStitchingImage : UIImageView

/**
 * 给出一组图片，拼接为一张图片
 */
- (UIImage*)stitchingImages:(NSArray*)images size:(CGSize)size margin:(CGFloat)margin backgroundColor:(UIColor*)color;

@end
