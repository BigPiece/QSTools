//
//  MacroFonts.h
//  QSRuler
//
//  Created by qws on 2018/7/4.
//  Copyright © 2018年 qws. All rights reserved.
//

#ifndef MacroFonts_h
#define MacroFonts_h

//系统字体
#define Font(F)                         [UIFont systemFontOfSize:(F)]
#define FontBold(F)                     [UIFont boldSystemFontOfSize:(F)]

//等宽字体
#define FontMonoLight(F)                [UIFont monospacedDigitSystemFontOfSize:F weight:UIFontWeightLight]
#define FontMonoRegular(F)              [UIFont monospacedDigitSystemFontOfSize:F weight:UIFontWeightRegular]
#define FontMonoMedium(F)               [UIFont monospacedDigitSystemFontOfSize:F weight:UIFontWeightMedium]
#define FontMonoBold(F)                 [UIFont monospacedDigitSystemFontOfSize:F weight:UIFontWeightBold]

//AvenirNext
#define FontAvenirNextUltraLight(F)     [UIFont fontWithName:@"AvenirNext-UltraLight" size:F]
#define FontAvenirNextRegular(F)        [UIFont fontWithName:@"AvenirNext-Regular" size:F]
#define FontAvenirNextBold(F)           [UIFont fontWithName:@"AvenirNext-Bold" size:F]

//AvenirNextCondensed
#define FontCondensedRegular(F)         [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:F]
#define FontCondensedMedium(F)          [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:F]
#define FontCondensedDemiBold(F)        [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:F]


#endif /* MacroFonts_h */
