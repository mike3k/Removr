/*
 *  achievements.h
 *  Removr
 *
 *  Created by Mike Cohen on 12/5/10.
 *  Copyright 2010 MC Development. All rights reserved.
 *
 */

#ifdef LITE_VERSION

#define complete_tutorial   @"fcomplete_tutorial"
#define complete_10_levels	@"fcomplete_10_levels"
#define complete_20_levels	@"fcomplete_20_levels"
#define no_blue_pieces		@"fno_blue_pieces"
#define red_exploded		@"fred_exploded"
#define complete_all_levels	@"fcomplete_all_levels"

#define gk_score_category   @"freepoints"

#else

#define complete_tutorial   @"complete_tutorial"
#define complete_10_levels	@"complete_10_levels"
#define complete_20_levels	@"complete_20_levels"
#define no_blue_pieces		@"no_blue_pieces"
#define red_exploded		@"red_exploded"
#define complete_all_levels	@"complete_all_levels"

#define gk_score_category   @"points"

#endif