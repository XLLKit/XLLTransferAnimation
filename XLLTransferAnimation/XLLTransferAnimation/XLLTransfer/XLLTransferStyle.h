//
//  XLLTransferStyle.h
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/28.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#ifndef XLLTransferStyle_h
#define XLLTransferStyle_h

/**
 手势驱动转场类型
 */
typedef NS_ENUM(NSInteger, XLLInteractiveStyle) {
    
    XLLTransferInteractiveShow = 1000, //push pop
    XLLTransferInteractiveModal,       //present dismiss
    XLLTransferInteractiveTabSelect    //tab选择
};

/**
 转场动画类型
 */
typedef NS_ENUM(NSInteger, XLLAnimationStyle) {
    
    XLLAnimationStyleDoor = 1000, //开门动画
    XLLAnimationStyleCircle,      //圆形扩展动画
    XLLAnimationStyleKuGou,       //酷狗音乐那种动画
    XLLAnimationStyleTab          //tab样式
};


#endif /* XLLTransferStyle_h */
