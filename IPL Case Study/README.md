# Case Study: Exploring IPL Seasons 2008, 2009, and 2017

## Introduction
Embarking on a journey of self-exploration and fueled by a passion for the game, I delved into the IPL schema for the seasons 2008, 2009, and 2017. Gathering data and query requests from the dynamic world of data science enthusiasts at cloudyML, I tailored my exploration to encompass a diverse set of SQL functions and clauses. The solutions to queries span the spectrum from fundamental WHERE clauses to the intricacies of advanced windowing functions. This case study not only enriches my understanding of the IPL datasets but also hones my skills in leveraging SQL for comprehensive data analysis and insights.

## Schema Description
The schema comprises only two tables, each offering crucial insights into the IPL seasons of 2008, 2009, and 2017:

* Matches: Records key information about 128 matches, including match_id, IPL season, competing team names, toss details, toss winner, winning team, margin of victory, player of the match, and details of the acting umpires.
* Deliveries: Documents the minutiae of each delivery in all matches. The 'id' serves as a foreign key referencing the 'match_id' from the Matches table. Details include bowler, batsman, non-striker batsman, wide, no ball, leg bye, batter runs, boundaries, and dismissal information if the batsman is out.

Check out the [ER-Diagram](https://github.com/praneeth377/IPL_CaseStudy-SQL/blob/main/ER-Diagram1.png)

## Analysis - Unraveling the Cricketing Insights
Engaging with diverse and intricate query requests, this exploration into the IPL schema for the seasons 2008, 2009, and 2017 has been a journey of both complexity and nostalgia. The multifaceted questions demanded not only a mastery of advanced SQL structures but also sparked innovative thinking, encouraging experimentation with varied approaches to problem-solving.

The complexity of the queries prompted a deeper understanding and utilization of Common Table Expressions (CTEs), pushing the boundaries of SQL capabilities. Each request became an opportunity to unravel the rich cricketing data, revealing nuanced statistics and patterns within the matches and deliveries.

As the queries delved into the intricate details of the tournaments, they also resurfaced memorable moments. Notably, the quest to determine the highest partnership in the 2017 season led to a heartwarming recall of the dynamic duo, S. Dhawan and David Warner, orchestrating a formidable partnership for Sunrisers Hyderabad (SRH).

## Conclusion and Future Works
It has been a rewarding journey. Unveiling cricketing insights and memories, this exploration has not only enriched my technical skills but also deepened my appreciation for the narratives embedded within the data, showcasing the profound impact of data analysis in the realm of sports.

The extensive nature of this IPL schema opens avenues for future exploration, with potential analyses ranging from player performance trends to team dynamics across seasons. Further investigations could involve predictive modeling, leveraging machine learning algorithms for outcome predictions. Continuous updates and expansions to the dataset could uncover evolving patterns and contribute to a more comprehensive understanding of cricket analytics.
