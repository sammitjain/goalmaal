# Goalmaal - Real-time Club Football Player Goal Statistics inside MATLAB&reg;


**Tl;dr**: Goalmaal is a quick data scraper I wrote in MATLAB&reg; to source all goal statistics for a specific player.




I wanted to experiment a bit with Messi's goal statistics and find out some more insights about the players who have assisted him the most (It's not Dani Alves or Xavi or Iniesta!). Turns out that it's not so easy to directly get football goal data into MATLAB&reg; (I could be wrong about this, but I didn't find a quick solution) - so I wrote a quick scraper for collecting goal data given a player's name.




**Disclaimer:** In this case, all the data is available thanks to the amazing folks at [transfermarkt.com](https://www.transfermarkt.com/) and I don't own any of it. Would have loved to see a filter on the website itself but here we are.


  


Let's first zero in on a specific player for this demo: *Lionel Messi*. Visit the above link and find the data available for your selected player.




**IMPORTANT:** Please select "Detailed view" on the website and then set the correct value inside `goalsURL`


## Set player data

```matlab:Code
playerName = "Lionel Messi";
goalsURL = "https://www.transfermarkt.com/lionel-messi/alletore/spieler/28003/saison//verein/0/liga/0/wettbewerb//pos/0/trainer_id/0/minute/0/torart/0/plus/1";
```

## Read the URL and retrieve HTML data

```matlab:Code
goalsHTML = urlread(goalsURL);
```



Here's what `goalsHTML` looks like:



```matlab:Code
disp(goalsHTML(1:700));
```


```text:Output
<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
    
<script type="text/javascript">
    !function () { var e = function () { var e, t = "__tcfapiLocator", a = [], n = window; for (; n;) { try { if (n.frames[t]) { e = n; break } } catch (e) { } if (n === window.top) break; n = n.parent } e || (!function e() { var a = n.document, r = !!n.frames[t]; if (!r) if (a.body) { var i = a.createElement("iframe"); i.style.cssText = "display:none", i.name = t, a.body.appendChild(i) } else setTimeout(e, 5); return !r }(), n.__tcfapi = function () { for (var e, t = arguments.length, n = new Array(t), r = 0; r < t; r++)n[r] = arguments[r]; if (!n.length) return a; if ("setGdprApplies" === n[0]) n.len
```

## Parse HTML Information - Tree and rows


Convert raw HTML data to `htmlTree` type for easier element parsing



```matlab:Code
goalsHTMLTree = htmlTree(goalsHTML);
```



Each goal entry in the HTML table is a single row. Find all valid table rows using `<tr>` tag



```matlab:Code
goalRows = findElement(goalsHTMLTree,"tr");
disp(goalRows(1:15));
```


```text:Output
  15x1 htmlTree:

    <TR><TD>Filter by season:</TD><TD><DIV class="inline-select"><SELECT name="saison" data-placeholder="Filter by season" class="chzn-select" tabindex="0"><OPTION value="">All seasons</OPTION><OPTION value="2021">21/22</OPTION><OPTION value="2020">20/21</OPTION><OPTION value="2019">19/20</OPTION><OPTION value="2018">18/19</OPTION><OPTION value="2017">17/18</OPTION><OPTION value="2016">16/17</OPTION><OPTION value="2015">15/16</OPTION><OPTION value="2014">14/15</OPTION><OPTION value="2013">13/14</OPTION><OPTION value="2012">12/13</OPTION><OPTION value="2011">11/12</OPTION><OPTION value="2010">10/11</OPTION><OPTION value="2009">09/10</OPTION><OPTION value="2008">08/09</OPTION><OPTION value="2007">07/08</OPTION><OPTION value="2006">06/07</OPTION><OPTION value="2005">05/06</OPTION><OPTION value="2004">04/05</OPTION></SELECT></DIV></TD><TD/></TR>
    <TR><TD>Filter by club:</TD><TD><DIV class="inline-select"><SELECT name="verein" data-placeholder="Filter by club" class="chzn-select" tabindex="0"><OPTION value="">All clubs</OPTION><OPTION value="583">Paris Saint-Germain</OPTION><OPTION value="131">FC Barcelona</OPTION></SELECT></DIV></TD><TD/></TR>
    <TR><TD>League ranking / League type:</TD><TD><DIV class="inline-select"><SELECT name="liga" data-placeholder="Select type" class="chzn-select" tabindex="0"><OPTION value="">All types</OPTION><OPTION value="1">First Tier</OPTION><OPTION value="8">Domestic Cup</OPTION><OPTION value="9">Domestic Super Cup</OPTION><OPTION value="10">International Cup</OPTION><OPTION value="13">International Super Cup</OPTION></SELECT></DIV></TD><TD/></TR>
    <TR><TD>Filter by competition:</TD><TD><DIV class="inline-select"><SELECT name="wettbewerb" data-placeholder="Filter by competition" class="chzn-select" tabindex="0"><OPTION value="">All competitions</OPTION><OPTION value="CL">UEFA Champions League</OPTION><OPTION value="USC">UEFA Super Cup</OPTION><OPTION value="OLYM">Olympic Games</OPTION><OPTION value="WMQ4">World Cup qualification South America</OPTION><OPTION value="FS">International Friendlies</OPTION><OPTION value="KLUB">FIFA Club World Cup</OPTION><OPTION value="ES1">LaLiga</OPTION><OPTION value="FR1">Ligue 1</OPTION><OPTION value="CDR">Copa del Rey</OPTION><OPTION value="SUC">Supercopa</OPTION><OPTION value="C19A">Copa América 2019</OPTION><OPTION value="CA16">Copa América Centenario 2016</OPTION><OPTION value="CA11">Copa América 2011</OPTION><OPTION value="CAM2">Copa América 2021</OPTION><OPTION value="CA15">Copa América 2015</OPTION><OPTION value="CA07">Copa América 2007</OPTION><OPTION value="U20N">U20-Weltmeisterschaft 200…
    <TR><TD>Filter by position:</TD><TD><DIV class="inline-select"><SELECT name="pos" data-placeholder="Filter by position" class="chzn-select" tabindex="0"><OPTION value="">All positions</OPTION><OPTION value="12">Right Winger</OPTION><OPTION value="14">Centre-Forward</OPTION><OPTION value="13">Second Striker</OPTION><OPTION value="10">Attacking Midfield</OPTION><OPTION value="11">Left Winger</OPTION></SELECT></DIV></TD><TD/></TR>
    <TR><TD>Minute:</TD><TD><DIV class="inline-select"><SELECT name="minute" data-placeholder="Select minute" class="chzn-select" tabindex="0"><OPTION value="">Entire game</OPTION><OPTION value="1">1 - 15</OPTION><OPTION value="2">16 - 30</OPTION><OPTION value="3">31 - 45</OPTION><OPTION value="4">45+</OPTION><OPTION value="5">46 - 60</OPTION><OPTION value="6">61 - 75</OPTION><OPTION value="7">76 - 90</OPTION><OPTION value="8">90+</OPTION><OPTION value="9">Extra time</OPTION><OPTION value="10">First half</OPTION><OPTION value="11">Second half</OPTION></SELECT></DIV></TD><TD/></TR>
    <TR><TD>Filter by position:</TD><TD><DIV class="inline-select"><SELECT name="pos" data-placeholder="Filter by position" class="chzn-select" tabindex="0"><OPTION value="">All positions</OPTION><OPTION value="12">Right Winger</OPTION><OPTION value="14">Centre-Forward</OPTION><OPTION value="13">Second Striker</OPTION><OPTION value="10">Attacking Midfield</OPTION><OPTION value="11">Left Winger</OPTION></SELECT></DIV></TD><TD/></TR>
    <TR><TD>Type of goal:</TD><TD><DIV class="inline-select"><SELECT name="torart" data-placeholder="Select type of goal" class="chzn-select" tabindex="0"><OPTION value="">All types</OPTION><OPTION value="200">Not reported</OPTION><OPTION value="201">Left-footed shot</OPTION><OPTION value="202">Right-footed shot</OPTION><OPTION value="203">Header</OPTION><OPTION value="204">Penalty</OPTION><OPTION value="205">Penalty rebound</OPTION><OPTION value="207">Direct free kick</OPTION><OPTION value="208">Counter attack goal</OPTION><OPTION value="209">Long distance kick</OPTION><OPTION value="210">Tap-in</OPTION><OPTION value="211">Direct corner</OPTION><OPTION value="212">Deflected shot on goal</OPTION><OPTION value="213">Solo run</OPTION><OPTION value="214">Chest</OPTION></SELECT></DIV></TD><TD/></TR>
    <TR><TD>More filter:</TD><TD><DIV class="inline-select"><SELECT name="stand" data-placeholder="Select state" class="chzn-select" tabindex="0"><OPTION value="">All goals</OPTION><OPTION value="gamewinning">Just game winning goals</OPTION></SELECT></DIV></TD><TD><INPUT type="submit" class="small button" value="Show"/></TD></TR>
    <TR><TH class="" colspan="2">competition</TH><TH class="zentriert">Matchday</TH><TH class="zentriert">Date</TH><TH class="zentriert">Venue</TH><TH class="zentriert" colspan="2">For</TH><TH colspan="2">Opponent</TH><TH class="zentriert">Result</TH><TH class="zentriert">Pos.</TH><TH class="zentriert">Minute</TH><TH class="zentriert">At score</TH><TH class="">Type of goal</TH><TH class="">Goal assist</TH></TR>
    <TR style="border-top:1px dotted red !important;"><TD colspan="18" class="hauptlink highlight">Season 04/05</TD></TR>
    <TR class=""><TD class="zentriert no-border-rechts"><IMG src="https://tmssl.akamaized.net/images/logo/tiny/es1.png?lm=1557051003" title="LaLiga" alt="LaLiga" class=""/></TD><TD class="links no-border-links"><A title="LaLiga" href="/laliga/startseite/wettbewerb/ES1">LaLiga</A></TD><TD class="zentriert"><A href="/laliga/spieltag/wettbewerb/ES1/saison_id/2004/spieltag/34">34</A></TD><TD class="zentriert">5/1/05</TD><TD class="zentriert hauptlink">H</TD><TD class="zentriert no-border-rechts"><A title="FC Barcelona" href="/fc-barcelona/spielplan/verein/131/saison_id/2004"><IMG src="https://tmssl.akamaized.net/images/wappen/tiny/131.png?lm=1406739548" title=" " alt="FC Barcelona" class="tiny_wappen"/></A></TD><TD class="zentriert no-border-links"><SPAN class="tabellenplatz">(1.)</SPAN></TD><TD class="zentriert no-border-rechts"><A title="Albacete Balompié" href="/albacete-balompie/spielplan/verein/1532/saison_id/2004"><IMG src="https://tmssl.akamaized.net/images/wappen/tiny/1532.png?lm=14075…
    <TR style="border-top:1px dotted red !important;"><TD colspan="18" class="hauptlink highlight">Season 05/06</TD></TR>
    <TR class="bg_grey"><TD class="zentriert no-border-rechts"><IMG src="https://tmssl.akamaized.net/images/logo/tiny/cl.png?lm=1626810555" title="UEFA Champions League" alt="UEFA Champions League" class=""/></TD><TD class="links no-border-links"><A title="Champions League" href="/uefa-champions-league/startseite/pokalwettbewerb/CL">Champions League</A></TD><TD class="zentriert"><A href="/champions-league/spieltag/pokalwettbewerb/CL/saison_id/2005/gruppe/C">Group Stage</A></TD><TD class="zentriert">11/2/05</TD><TD class="zentriert hauptlink">H</TD><TD class="zentriert" colspan="2"><A title="FC Barcelona" href="/fc-barcelona/spielplan/verein/131/saison_id/2005"><IMG src="https://tmssl.akamaized.net/images/wappen/tiny/131.png?lm=1406739548" title=" " alt="FC Barcelona" class="tiny_wappen"/></A></TD><TD class="zentriert no-border-rechts"><A title="Panathinaikos Athens" href="/panathinaikos-athen/spielplan/verein/265/saison_id/2005"><IMG src="https://tmssl.akamaized.net/images/wappen/tiny/265.…
    <TR class=""><TD class="zentriert no-border-rechts"><IMG src="https://tmssl.akamaized.net/images/logo/tiny/es1.png?lm=1557051003" title="LaLiga" alt="LaLiga" class=""/></TD><TD class="links no-border-links"><A title="LaLiga" href="/laliga/startseite/wettbewerb/ES1">LaLiga</A></TD><TD class="zentriert"><A href="/laliga/spieltag/wettbewerb/ES1/saison_id/2005/spieltag/13">13</A></TD><TD class="zentriert">11/27/05</TD><TD class="zentriert hauptlink">H</TD><TD class="zentriert no-border-rechts"><A title="FC Barcelona" href="/fc-barcelona/spielplan/verein/131/saison_id/2005"><IMG src="https://tmssl.akamaized.net/images/wappen/tiny/131.png?lm=1406739548" title=" " alt="FC Barcelona" class="tiny_wappen"/></A></TD><TD class="zentriert no-border-links"><SPAN class="tabellenplatz">(1.)</SPAN></TD><TD class="zentriert no-border-rechts"><A title="Racing Santander" href="/racing-santander/spielplan/verein/630/saison_id/2005"><IMG src="https://tmssl.akamaized.net/images/wappen/tiny/630.png?lm=1407484…
```



That doesn't help much. Let's look at the real text inside these rows using the `extractHTMLText` function in MATLAB



```matlab:Code
disp(extractHTMLText(goalRows(1:15)));
```


```text:Output
    "All seasons   21/22   20/21   19/20   18/19   17/18   16/17   15/16   14/15   13/14   12/13   11/12   10/11   09/10   08/09   07/08   06/07   05/06   04/05"
    "All clubs   Paris Saint-Germain   FC Barcelona"
    "All types   First Tier   Domestic Cup   Domestic Super Cup   International Cup   International Super Cup"
    "All competitions   UEFA Champions League   UEFA Super Cup   Olympic Games   World Cup qualification South America   International Friendlies   FIFA Club World Cup   LaLiga   Ligue 1   Copa del Rey   Supercopa   Copa América 2019   Copa América Centenario 2016   Copa América 2011   Copa América 2021   Copa América 2015   Copa América 2007   U20-Weltmeisterschaft 2005   World Cup 2010   World Cup 2018   World Cup 2006   World Cup 2014"
    "All positions   Right Winger   Centre-Forward   Second Striker   Attacking Midfield   Left Winger"
    "Entire game   1 - 15   16 - 30   31 - 45   45+   46 - 60   61 - 75   76 - 90   90+   Extra time   First half   Second half"
    "All positions   Right Winger   Centre-Forward   Second Striker   Attacking Midfield   Left Winger"
    "All types   Not reported   Left-footed shot   Right-footed shot   Header   Penalty   Penalty rebound   Direct free kick   Counter attack goal   Long distance kick   Tap-in   Direct corner   Deflected shot on goal   Solo run   Chest"
    "All goals   Just game winning goals"
    "competition  Matchday  Date  Venue  For  Opponent  Result  Pos.  Minute  At score  Type of goal  Goal assist"
    "Season 04/05"
    "LaLiga   34  5/1/05  H     (1.)      Albacete (19.)   2:0   CF  90'+1  2:0  Left-footed shot   Ronaldinho Gaúcho"
    "Season 05/06"
    "Champions League   Group Stage  11/2/05  H         Panathinaikos   5:0   RW  34'  3:0  Left-footed shot"
    "LaLiga   13  11/27/05  H     (1.)      Racing (18.)   4:1   RW  51'  2:0  Left-footed shot   Samuel Eto'o"
```



Now that the data is starting to feel a little more familiar - the first few rows seem to be a little irrelevant to our current problem. Also the last row has overall statistics. Could be useful later on.



```matlab:Code
goalRows(1:10) = [];
overallStats = goalRows(end);
goalRows(end) = [];
```

## `extractGoalInfo` - Function to parse a single HTML Goal Row


At the end of this, we want to get a `goal` structure which has the following fields:



   -  `player`        -    Name of the goal-scoring player 
   -  `season`        -    Season info. YY/YY+1
   -  `competition`   -    Name of the competition/tournament
   -  `matchday`      -    Matchday info / Round info
   -  `date`          -    Match date
   -  `venue`         -    H/A
   -  `team`          -    scoring team
   -  `opponent`      -    opposing team
   -  `score`         -    Result of the match
   -  `position`      -    Player's position
   -  `minute`        -    Scoring minute
   -  `atscore`       -    Scoreline at the time of goal
   -  `type`          -    Type of goal. For e.g. Direct Free Kick, Solo run, etc
   -  `assist`        -    Assisting player (if any)



I played around a bit with this data and turns out that there are a lot of inconsistencies - there are missing fields throughout the table and that makes any sort of group operation ("vectorized operation") a little tricky. Check out the first 10 rows of our data:



```matlab:Code
disp(extractHTMLText(goalRows(1:10)));
```


```text:Output
    "Season 04/05"
    "LaLiga   34  5/1/05  H     (1.)      Albacete (19.)   2:0   CF  90'+1  2:0  Left-footed shot   Ronaldinho Gaúcho"
    "Season 05/06"
    "Champions League   Group Stage  11/2/05  H         Panathinaikos   5:0   RW  34'  3:0  Left-footed shot"
    "LaLiga   13  11/27/05  H     (1.)      Racing (18.)   4:1   RW  51'  2:0  Left-footed shot   Samuel Eto'o"
    "LaLiga   19  1/15/06  H     (1.)      Athletic (19.)   2:1   RW  50'  2:1  Left-footed shot   Mark van Bommel"
    "LaLiga   20  1/22/06  H     (1.)      Alavés (20.)   2:0   CF  82'  2:0  Left-footed shot   Ronaldinho Gaúcho"
    "LaLiga   21  1/29/06  A     (1.)      RCD Mallorca (17.)   0:3   CF  75'  0:2  Right-footed shot   Sylvinho"
    "83'  0:3  Left-footed shot   Ronaldinho Gaúcho"
    "Copa del Rey   Quarter-Finals  2/1/06  H         Real Zaragoza   2:1   CF  42'  1:0  Header   Ludovic Giuly"
```



Notice that there are some rows that mark the beginning of a season, and then even rows with all information have varying number of fields that were scraped - maybe the goal had an assist. maybe it didn't. Sometimes transfermarkt doesn't repeat the table data when there are multiple goals in a single match. Therefore, writing a function to take care of a single row at a time. 




*Note: This makes the process inefficient but remember that the scale of one player's goals is at most of order 1e2.*




For extracting information from a row of goal data, we need to know about the previously extracted goal. We also need to consider the season information.




After that, it's a lot of data cleanup + trying to fill in the missing information. 




This results in a function called `extractGoalInfo`. The definition for this function is towards the end of this readme. Let's see if it works as expected. We'll give it the season information the first time we run it. Also since there's no goal before this one - let's just take an empty structure.



```matlab:Code
previousGoal = struct;
season = "Season 04/05";
[goal,~,~] = extractGoalInfo(goalRows(2),previousGoal,season);
disp(goal);
```


```text:Output
         season: "Season 04/05"
    competition: "LaLiga"
       matchday: "34"
           date: "5/1/05"
          venue: "H"
           team: "FC Barcelona"
       opponent: "Albacete Balompié"
         result: "2:0"
       position: "CF"
         minute: "90'+1"
        atscore: "2:0"
           type: "Left-footed shot"
         assist: "Ronaldinho Gaúcho"
```



Perfect! Now we just need to do this for all the goals.


## Process all goals for Player!


Storing all the goals in a MATLAB structure array called `goals`




Letting `extractGoalInfo` handle extraction of the season information the first time.



```matlab:Code
[goal,~,season] = extractGoalInfo(goalRows(1));
```



Extract the first `goal` and populate `goals` with this goal.



```matlab:Code
[goal,~,season] = extractGoalInfo(goalRows(2),goal,season);
goals = goal;
```



Repeat the process for the subsequent rows + append to `goals` array



```matlab:Code
for rowIdx = 3:numel(goalRows)
    [goal,errId,season] = extractGoalInfo(goalRows(rowIdx),goal,season);
    if errId~=1                 % Not a season heading
        goals = [goals goal];
    end
end
```



Convert this `goals` into a nicer table for visualization `goalsTable`



```matlab:Code
goalsTable = struct2table(goals)
```

| |season|competition|matchday|date|venue|team|opponent|result|position|minute|atscore|type|assist|
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
|1|"Season 04/05"|"LaLiga"|"34"|"5/1/05"|"H"|"FC Barcelona"|"Albacete Balompié"|"2:0"|"CF"|"90'+1"|"2:0"|"Left-footed shot"|"Ronaldinho Gaúcho"|
|2|"Season 05/06"|"Champions League"|"Group Stage"|"11/2/05"|"H"|"FC Barcelona"|"Panathinaikos Athen...|"5:0"|"RW"|"34'"|"3:0"|"Left-footed shot"|""|
|3|"Season 05/06"|"LaLiga"|"13"|"11/27/05"|"H"|"FC Barcelona"|"Racing Santander"|"4:1"|"RW"|"51'"|"2:0"|"Left-footed shot"|"Samuel Eto'o"|
|4|"Season 05/06"|"LaLiga"|"19"|"1/15/06"|"H"|"FC Barcelona"|"Athletic Bilbao"|"2:1"|"RW"|"50'"|"2:1"|"Left-footed shot"|"Mark van Bommel"|
|5|"Season 05/06"|"LaLiga"|"20"|"1/22/06"|"H"|"FC Barcelona"|"Deportivo Alavés"|"2:0"|"CF"|"82'"|"2:0"|"Left-footed shot"|"Ronaldinho Gaúcho"|
|6|"Season 05/06"|"LaLiga"|"21"|"1/29/06"|"A"|"FC Barcelona"|"RCD Mallorca"|"0:3"|"CF"|"75'"|"0:2"|"Right-footed shot"|"Sylvinho"|
|7|"Season 05/06"|"LaLiga"|"21"|"1/29/06"|"A"|"FC Barcelona"|"RCD Mallorca"|"0:3"|"CF"|"83'"|"0:3"|"Left-footed shot"|"Ronaldinho Gaúcho"|
|8|"Season 05/06"|"Copa del Rey"|"Quarter-Finals"|"2/1/06"|"H"|"FC Barcelona"|"Real Zaragoza"|"2:1"|"CF"|"42'"|"1:0"|"Header"|"Ludovic Giuly"|
|9|"Season 05/06"|"LaLiga"|"24"|"2/18/06"|"H"|"FC Barcelona"|"Real Betis Balompié...|"5:1"|"RW"|"84'"|"5:1"|"Left-footed shot"|""|
|10|"Season 06/07"|"LaLiga"|"1"|"8/28/06"|"A"|"FC Barcelona"|"Celta de Vigo"|"2:3"|"LW"|"59'"|"1:2"|"Left-footed shot"|"Andrés Iniesta"|
|11|"Season 06/07"|"LaLiga"|"2"|"9/9/06"|"H"|"FC Barcelona"|"CA Osasuna"|"3:0"|"RW"|"36'"|"3:0"|"Left-footed shot"|"Samuel Eto'o"|
|12|"Season 06/07"|"Champions League"|"Group Stage"|"9/27/06"|"A"|"FC Barcelona"|"SV Werder Bremen"|"1:1"|"RW"|"89'"|"1:1"|"Left-footed shot"|"Deco"|
|13|"Season 06/07"|"LaLiga"|"6"|"10/15/06"|"H"|"FC Barcelona"|"Sevilla FC"|"3:1"|"RW"|"80'"|"3:1"|"Right-footed shot"|"Xavi"|
|14|"Season 06/07"|"LaLiga"|"26"|"3/10/07"|"H"|"FC Barcelona"|"Real Madrid"|"3:3"|"RW"|"11'"|"1:1"|"Left-footed shot"|"Samuel Eto'o"|
|15|"Season 06/07"|"LaLiga"|"26"|"3/10/07"|"H"|"FC Barcelona"|"Real Madrid"|"3:3"|"RW"|"28'"|"2:2"|"Left-footed shot"|""|
|16|"Season 06/07"|"LaLiga"|"26"|"3/10/07"|"H"|"FC Barcelona"|"Real Madrid"|"3:3"|"RW"|"90'+1"|"3:3"|"Left-footed shot"|"Ronaldinho Gaúcho"|
|17|"Season 06/07"|"LaLiga"|"27"|"3/17/07"|"A"|"FC Barcelona"|"Recreativo Huelva"|"0:4"|"RW"|"86'"|"0:4"|"Left-footed shot"|""|
|18|"Season 06/07"|"LaLiga"|"28"|"3/31/07"|"H"|"FC Barcelona"|"Deportivo de La Cor...|"2:1"|"RW"|"45'"|"1:0"|"Left-footed shot"|"Ronaldinho Gaúcho"|
|19|"Season 06/07"|"Copa del Rey"|"Semi-Finals"|"4/18/07"|"H"|"FC Barcelona"|"Getafe CF"|"5:2"|"RW"|"29'"|"2:0"|"Solo run"|"Xavi"|
|20|"Season 06/07"|"Copa del Rey"|"Semi-Finals"|"4/18/07"|"H"|"FC Barcelona"|"Getafe CF"|"5:2"|"RW"|"45'"|"3:0"|"Left-footed shot"|"Deco"|
|21|"Season 06/07"|"LaLiga"|"35"|"5/20/07"|"A"|"FC Barcelona"|"Atlético de Madrid"|"0:6"|"RW"|"39'"|"0:1"|"Left-footed shot"|"Samuel Eto'o"|
|22|"Season 06/07"|"LaLiga"|"35"|"5/20/07"|"A"|"FC Barcelona"|"Atlético de Madrid"|"0:6"|"RW"|"80'"|"0:5"|"Left-footed shot"|"Giovanni van Bronck...|
|23|"Season 06/07"|"LaLiga"|"37"|"6/9/07"|"H"|"FC Barcelona"|"RCD Espanyol Barcel...|"2:2"|"RW"|"43'"|"1:1"|""|"Gianluca Zambrotta"|
|24|"Season 06/07"|"LaLiga"|"37"|"6/9/07"|"H"|"FC Barcelona"|"RCD Espanyol Barcel...|"2:2"|"RW"|"57'"|"2:1"|"Right-footed shot"|"Deco"|
|25|"Season 06/07"|"LaLiga"|"38"|"6/17/07"|"A"|"FC Barcelona"|"Gimnàstic de Tarrag...|"1:5"|"RW"|"34'"|"0:2"|"Left-footed shot"|"Deco"|
|26|"Season 06/07"|"LaLiga"|"38"|"6/17/07"|"A"|"FC Barcelona"|"Gimnàstic de Tarrag...|"1:5"|"RW"|"51'"|"0:4"|"Left-footed shot"|"Deco"|
|27|"Season 07/08"|"Champions League"|"Group Stage"|"9/19/07"|"H"|"FC Barcelona"|"Olympique Lyon"|"3:0"|"RW"|"82'"|"2:0"|"Left-footed shot"|"Andrés Iniesta"|
|28|"Season 07/08"|"LaLiga"|"4"|"9/22/07"|"H"|"FC Barcelona"|"Sevilla FC"|"2:1"|"RW"|"72'"|"1:0"|"Left-footed shot"|"Thierry Henry"|
|29|"Season 07/08"|"LaLiga"|"4"|"9/22/07"|"H"|"FC Barcelona"|"Sevilla FC"|"2:1"|"RW"|"79'"|"2:0"|"Penalty"|""|
|30|"Season 07/08"|"LaLiga"|"5"|"9/26/07"|"H"|"FC Barcelona"|"Real Zaragoza"|"4:1"|"RW"|"5'"|"1:0"|"Left-footed shot"|"Thierry Henry"|
|31|"Season 07/08"|"LaLiga"|"5"|"9/26/07"|"H"|"FC Barcelona"|"Real Zaragoza"|"4:1"|"RW"|"10'"|"2:1"|"Left-footed shot"|"Deco"|
|32|"Season 07/08"|"LaLiga"|"6"|"9/29/07"|"A"|"FC Barcelona"|"Levante UD"|"1:4"|"RW"|"50'"|"0:4"|"Left-footed shot"|"Deco"|
|33|"Season 07/08"|"Champions League"|"Group Stage"|"10/2/07"|"A"|"FC Barcelona"|"VfB Stuttgart"|"0:2"|"RW"|"66'"|"0:2"|"Deflected shot on g...|"Thierry Henry"|
|34|"Season 07/08"|"LaLiga"|"7"|"10/7/07"|"H"|"FC Barcelona"|"Atlético de Madrid"|"3:0"|"RW"|"19'"|"2:0"|"Left-footed shot"|"Ronaldinho Gaúcho"|
|35|"Season 07/08"|"LaLiga"|"9"|"10/28/07"|"H"|"FC Barcelona"|"UD Almería"|"2:0"|"RW"|"80'"|"2:0"|"Penalty"|""|
|36|"Season 07/08"|"Champions League"|"Group Stage"|"11/7/07"|"H"|"FC Barcelona"|"Rangers FC"|"2:0"|"RW"|"41'"|"2:0"|"Left-footed shot"|"Ronaldinho Gaúcho"|
|37|"Season 07/08"|"LaLiga"|"13"|"11/24/07"|"H"|"FC Barcelona"|"Recreativo Huelva"|"3:0"|"RW"|"81'"|"3:0"|"Penalty"|""|
|38|"Season 07/08"|"Champions League"|"Group Stage"|"11/27/07"|"A"|"FC Barcelona"|"Olympique Lyon"|"2:2"|"RW"|"58'"|"1:2"|"Penalty"|""|
|39|"Season 07/08"|"Champions League"|"last 16"|"2/20/08"|"A"|"FC Barcelona"|"Celtic FC"|"2:3"|"RW"|"18'"|"1:1"|"Left-footed shot"|"Deco"|
|40|"Season 07/08"|"Champions League"|"last 16"|"2/20/08"|"A"|"FC Barcelona"|"Celtic FC"|"2:3"|"RW"|"79'"|"2:3"|"Left-footed shot"|""|
|41|"Season 07/08"|"LaLiga"|"25"|"2/24/08"|"H"|"FC Barcelona"|"Levante UD"|"5:1"|"RW"|"44'"|"2:1"|"Left-footed shot"|"Xavi"|
|42|"Season 07/08"|"LaLiga"|"35"|"5/4/08"|"H"|"FC Barcelona"|"Valencia CF"|"6:0"|"RW"|"5'"|"1:0"|"Penalty"|""|
|43|"Season 08/09"|"LaLiga"|"2"|"9/13/08"|"H"|"FC Barcelona"|"Racing Santander"|"1:1"|"RW"|"70'"|"1:0"|"Penalty"|""|
|44|"Season 08/09"|"LaLiga"|"3"|"9/21/08"|"A"|"FC Barcelona"|"Sporting Gijón"|"1:6"|"RW"|"85'"|"1:5"|"Left-footed shot"|"Andrés Iniesta"|
|45|"Season 08/09"|"LaLiga"|"3"|"9/21/08"|"A"|"FC Barcelona"|"Sporting Gijón"|"1:6"|"RW"|"89'"|"1:6"|"Header"|"Xavi"|
|46|"Season 08/09"|"LaLiga"|"5"|"9/27/08"|"A"|"FC Barcelona"|"RCD Espanyol Barcel...|"1:2"|"RW"|"90'"|"1:2"|"Penalty"|""|
|47|"Season 08/09"|"Champions League"|"Group Stage"|"10/1/08"|"A"|"FC Barcelona"|"Shakhtar Donetsk"|"1:2"|"RW"|"87'"|"1:1"|"Right-footed shot"|"Bojan Krkic"|
|48|"Season 08/09"|"Champions League"|"Group Stage"|"10/1/08"|"A"|"FC Barcelona"|"Shakhtar Donetsk"|"1:2"|"RW"|"90'+2"|"1:2"|"Left-footed shot"|"Xavi"|
|49|"Season 08/09"|"LaLiga"|"6"|"10/4/08"|"H"|"FC Barcelona"|"Atlético de Madrid"|"6:1"|"RW"|"8'"|"3:0"|"Direct free kick"|""|
|50|"Season 08/09"|"Champions League"|"Group Stage"|"10/22/08"|"A"|"FC Barcelona"|"FC Basel 1893"|"0:5"|"CF"|"4'"|"0:1"|"Left-footed shot"|"Dani Alves"|
|51|"Season 08/09"|"LaLiga"|"9"|"11/1/08"|"A"|"FC Barcelona"|"Málaga CF"|"1:4"|"RW"|"19'"|"1:2"|"Left-footed shot"|""|
|52|"Season 08/09"|"Champions League"|"Group Stage"|"11/4/08"|"H"|"FC Barcelona"|"FC Basel 1893"|"1:1"|"RW"|"61'"|"1:0"|"Left-footed shot"|"Thierry Henry"|
|53|"Season 08/09"|"Copa del Rey"|"Fifth Round"|"11/12/08"|"H"|"FC Barcelona"|"Benidorm CD"|"1:0"|"RW"|"86'"|"1:0"|"Penalty rebound"|""|
|54|"Season 08/09"|"LaLiga"|"11"|"11/16/08"|"A"|"FC Barcelona"|"Recreativo Huelva"|"0:2"|"RW"|"51'"|"0:1"|"Left-footed shot"|"Xavi"|
|55|"Season 08/09"|"Champions League"|"Group Stage"|"11/26/08"|"A"|"FC Barcelona"|"Sporting CP"|"2:5"|"RW"|"49'"|"0:3"|"Left-footed shot"|"Dani Alves"|
|56|"Season 08/09"|"LaLiga"|"13"|"11/29/08"|"A"|"FC Barcelona"|"Sevilla FC"|"0:3"|"RW"|"78'"|"0:2"|"Left-footed shot"|"Xavi"|
|57|"Season 08/09"|"LaLiga"|"13"|"11/29/08"|"A"|"FC Barcelona"|"Sevilla FC"|"0:3"|"RW"|"90'+2"|"0:3"|"Left-footed shot"|"Aleksandr Hleb"|
|58|"Season 08/09"|"LaLiga"|"15"|"12/13/08"|"H"|"FC Barcelona"|"Real Madrid"|"2:0"|"RW"|"89'"|"2:0"|"Left-footed shot"|"Thierry Henry"|
|59|"Season 08/09"|"Copa del Rey"|"Round of 16"|"1/6/09"|"A"|"FC Barcelona"|"Atlético de Madrid"|"1:3"|"RW"|"11'"|"0:1"|"Left-footed shot"|"Dani Alves"|
|60|"Season 08/09"|"Copa del Rey"|"Round of 16"|"1/6/09"|"A"|"FC Barcelona"|"Atlético de Madrid"|"1:3"|"RW"|"57'"|"0:2"|"Penalty"|""|
|61|"Season 08/09"|"Copa del Rey"|"Round of 16"|"1/6/09"|"A"|"FC Barcelona"|"Atlético de Madrid"|"1:3"|"RW"|"79'"|"1:3"|"Right-footed shot"|"Andrés Iniesta"|
|62|"Season 08/09"|"LaLiga"|"18"|"1/11/09"|"A"|"FC Barcelona"|"CA Osasuna"|"2:3"|"RW"|"84'"|"2:3"|"Left-footed shot"|"Dani Alves"|
|63|"Season 08/09"|"LaLiga"|"19"|"1/17/09"|"H"|"FC Barcelona"|"Deportivo de La Cor...|"5:0"|"RW"|"21'"|"1:0"|"Left-footed shot"|""|
|64|"Season 08/09"|"LaLiga"|"20"|"1/24/09"|"H"|"FC Barcelona"|"CD Numancia"|"4:1"|"RW"|"49'"|"1:0"|"Left-footed shot"|"Dani Alves"|
|65|"Season 08/09"|"LaLiga"|"20"|"1/24/09"|"H"|"FC Barcelona"|"CD Numancia"|"4:1"|"RW"|"76'"|"4:1"|"Right-footed shot"|""|
|66|"Season 08/09"|"LaLiga"|"21"|"2/1/09"|"A"|"FC Barcelona"|"Racing Santander"|"1:2"|"RW"|"65'"|"1:1"|"Right-footed shot"|"Xavi"|
|67|"Season 08/09"|"LaLiga"|"21"|"2/1/09"|"A"|"FC Barcelona"|"Racing Santander"|"1:2"|"RW"|"81'"|"1:2"|"Right-footed shot"|""|
|68|"Season 08/09"|"LaLiga"|"25"|"3/1/09"|"A"|"FC Barcelona"|"Atlético de Madrid"|"4:3"|"RW"|"30'"|"0:2"|"Left-footed shot"|""|
|69|"Season 08/09"|"Copa del Rey"|"Semi-Finals"|"3/4/09"|"A"|"FC Barcelona"|"RCD Mallorca"|"1:1"|"RW"|"81'"|"1:1"|"Left-footed shot"|"Gerard Piqué"|
|70|"Season 08/09"|"LaLiga"|"26"|"3/7/09"|"H"|"FC Barcelona"|"Athletic Bilbao"|"2:0"|"RW"|"31'"|"2:0"|"Penalty"|""|
|71|"Season 08/09"|"Champions League"|"last 16"|"3/11/09"|"H"|"FC Barcelona"|"Olympique Lyon"|"5:2"|"RW"|"40'"|"3:0"|"Left-footed shot"|"Samuel Eto'o"|
|72|"Season 08/09"|"LaLiga"|"28"|"3/22/09"|"H"|"FC Barcelona"|"Málaga CF"|"6:0"|"RW"|"26'"|"2:0"|"Right-footed shot"|"Xavi"|
|73|"Season 08/09"|"Champions League"|"Quarter-Finals"|"4/8/09"|"H"|"FC Barcelona"|"Bayern Munich"|"4:0"|"RW"|"9'"|"1:0"|"Left-footed shot"|"Samuel Eto'o"|
|74|"Season 08/09"|"Champions League"|"Quarter-Finals"|"4/8/09"|"H"|"FC Barcelona"|"Bayern Munich"|"4:0"|"RW"|"38'"|"3:0"|"Right-footed shot"|"Thierry Henry"|
|75|"Season 08/09"|"LaLiga"|"31"|"4/18/09"|"A"|"FC Barcelona"|"Getafe CF"|"0:1"|"RW"|"18'"|"0:1"|"Left-footed shot"|"Xavi"|
|76|"Season 08/09"|"LaLiga"|"33"|"4/25/09"|"A"|"FC Barcelona"|"Valencia CF"|"2:2"|"RW"|"23'"|"0:1"|"Left-footed shot"|"Andrés Iniesta"|
|77|"Season 08/09"|"LaLiga"|"34"|"5/2/09"|"A"|"FC Barcelona"|"Real Madrid"|"2:6"|"CF"|"35'"|"1:3"|"Left-footed shot"|"Xavi"|
|78|"Season 08/09"|"LaLiga"|"34"|"5/2/09"|"A"|"FC Barcelona"|"Real Madrid"|"2:6"|"CF"|"75'"|"2:5"|"Left-footed shot"|"Xavi"|
|79|"Season 08/09"|"Copa del Rey"|"Final"|"5/13/09"|"H"|"FC Barcelona"|"Athletic Bilbao"|"4:1"|"RW"|"55'"|"2:1"|"Left-footed shot"|"Samuel Eto'o"|
|80|"Season 08/09"|"Champions League"|"Final"|"5/27/09"|"H"|"FC Barcelona"|"Manchester United"|"2:0"|"CF"|"70'"|"2:0"|"Header"|"Xavi"|
|81|"Season 09/10"|"Supercopa"|"final"|"8/23/09"|"H"|"FC Barcelona"|"Athletic Bilbao"|"3:0"|"RW"|"50'"|"1:0"|"Right-footed shot"|"Zlatan Ibrahimovic"|
|82|"Season 09/10"|"Supercopa"|"final"|"8/23/09"|"H"|"FC Barcelona"|"Athletic Bilbao"|"3:0"|"RW"|"68'"|"2:0"|"Penalty"|""|
|83|"Season 09/10"|"LaLiga"|"2"|"9/12/09"|"A"|"FC Barcelona"|"Getafe CF"|"0:2"|"RW"|"78'"|"0:2"|"Header"|"Zlatan Ibrahimovic"|
|84|"Season 09/10"|"LaLiga"|"3"|"9/19/09"|"H"|"FC Barcelona"|"Atlético de Madrid"|"5:2"|"RW"|"15'"|"2:0"|"Left-footed shot"|"Xavi"|
|85|"Season 09/10"|"LaLiga"|"3"|"9/19/09"|"H"|"FC Barcelona"|"Atlético de Madrid"|"5:2"|"RW"|"90'+3"|"5:2"|"Right-footed shot"|"Dani Alves"|
|86|"Season 09/10"|"LaLiga"|"4"|"9/22/09"|"A"|"FC Barcelona"|"Racing Santander"|"1:4"|"RW"|"23'"|"0:2"|"Left-footed shot"|"Xavi"|
|87|"Season 09/10"|"LaLiga"|"4"|"9/22/09"|"A"|"FC Barcelona"|"Racing Santander"|"1:4"|"RW"|"63'"|"0:4"|"Left-footed shot"|"Xavi"|
|88|"Season 09/10"|"Champions League"|"Group Stage"|"9/29/09"|"H"|"FC Barcelona"|"Dynamo Kyiv"|"2:0"|"RW"|"25'"|"1:0"|"Left-footed shot"|"Andrés Iniesta"|
|89|"Season 09/10"|"LaLiga"|"8"|"10/25/09"|"H"|"FC Barcelona"|"Real Zaragoza"|"6:1"|"RW"|"80'"|"5:1"|"Left-footed shot"|"Andrés Iniesta"|
|90|"Season 09/10"|"LaLiga"|"10"|"11/7/09"|"H"|"FC Barcelona"|"RCD Mallorca"|"4:2"|"RW"|"86'"|"4:1"|"Penalty"|""|
|91|"Season 09/10"|"Copa del Rey"|"5th round"|"11/10/09"|"H"|"FC Barcelona"|"Cultural Leonesa"|"5:0"|"RW"|"64'"|"4:0"|"Left-footed shot"|"Pedro"|
|92|"Season 09/10"|"LaLiga"|"13"|"12/5/09"|"A"|"FC Barcelona"|"Deportivo de La Cor...|"1:3"|"RW"|"26'"|"0:1"|"Left-footed shot"|"Dani Alves"|
|93|"Season 09/10"|"LaLiga"|"13"|"12/5/09"|"A"|"FC Barcelona"|"Deportivo de La Cor...|"1:3"|"RW"|"80'"|"1:2"|"Header"|"Pedro"|
|94|"Season 09/10"|"Champions League"|"Group Stage"|"12/9/09"|"A"|"FC Barcelona"|"Dynamo Kyiv"|"1:2"|"RW"|"86'"|"1:2"|"Direct free kick"|""|
|95|"Season 09/10"|"Club World Cup"|"Semi-Finals"|"12/16/09"|"A"|"FC Barcelona"|"CF Atlante"|"1:3"|"RW"|"55'"|"1:2"|"Left-footed shot"|"Zlatan Ibrahimovic"|
|96|"Season 09/10"|"Club World Cup"|"Final"|"12/19/09"|"A"|"FC Barcelona"|"Club Estudiantes de...|"1:2 AET"|"RW"|"110'"|"1:2"|"Chest"|"Dani Alves"|
|97|"Season 09/10"|"LaLiga"|"17"|"1/10/10"|"A"|"FC Barcelona"|"CD Tenerife"|"0:5"|"RW"|"36'"|"0:1"|"Left-footed shot"|"Bojan Krkic"|
|98|"Season 09/10"|"LaLiga"|"17"|"1/10/10"|"A"|"FC Barcelona"|"CD Tenerife"|"0:5"|"RW"|"45'"|"0:3"|"Right-footed shot"|"Bojan Krkic"|
|99|"Season 09/10"|"LaLiga"|"17"|"1/10/10"|"A"|"FC Barcelona"|"CD Tenerife"|"0:5"|"RW"|"75'"|"0:4"|"Left-footed shot"|"Bojan Krkic"|
|100|"Season 09/10"|"LaLiga"|"18"|"1/16/10"|"H"|"FC Barcelona"|"Sevilla FC"|"4:0"|"RW"|"85'"|"3:0"|"Left-footed shot"|"Dani Alves"|



IMPORTANT: Don't forget to add player information to goals table



```matlab:Code
player = repmat(playerName,[height(goalsTable) 1]);
goalsTable.player = player;
```

## `extractGoalInfo`


    Inputs:
        goalRow         - current row of HTML information about goal
        previousGoal    - goal structure of the previously scored goal
        season          - track information about season changes

    Outputs:
        goal            - goal structure of current goal
        errId           - return error codes (season changes, data mis-match, etc)
        season          - season information changes

```matlab:Code
function [goal,errId,season] = extractGoalInfo(goalRow, previousGoal,season)
    goalRaw = extractHTMLText(goalRow);
    goalWords = strtrim(strsplit(goalRaw,"  "));

    % normalize rowWords for all entries
    if(numel(goalWords)>9)
        if(regexp(goalWords(5),'\(.+\)')==1)
            goalWords(5) = [];
        end
    end

    % Initialize goal struct to store goal metadata
    goal = struct;

    % Validate goal entry vs season change entry
    if numel(goalWords)==1 % season title
        season = goalWords(1);
        errId = 1;
        return;
    end
    
    % Use alt words in case of missing table information
    altWords = goalRow.findElement("img").getAttribute("alt");

    
    % Find and locate type and assist information
    goalTypeDictionary = ...
        ["Solo run",...
        "Right-footed shot",...
        "Left-footed shot",...
        "Direct free kick",...
        "Header",...
        "Penalty",...
        "Penalty rebound",...
        "Tap-in",...
        "Counter attack goal",...
        "Long distance kick",...
        "Deflected shot on goal",...
        "Chest"];
    isTypeAndAssistMissing = ~isempty(regexp(goalRaw,"\d$",'once'));
    type = "";
    assist = "";
    if(contains(goalWords(end),goalTypeDictionary))
        type = goalWords(end);
    elseif(contains(goalWords(end-1),goalTypeDictionary))
        type = goalWords(end-1);
        assist = goalWords(end);
    elseif ~isTypeAndAssistMissing
        assist = goalWords(end);
    end

    % Assign goal metadata if it's a subsequent goal in the same match
    if(numel(goalWords) < 5)
        goal = previousGoal;
        goal.minute = goalWords(1);
        goal.atscore = goalWords(2);
        goal.type = type;
        goal.assist = assist;
        errId = 0;
        return;
    end

    % Extract Position Information
    position = regexp(goalRaw,"\:.+([A-Z]{2}).+\d\'",'tokens');
    if ~isempty(position)
        goalWords(7) = [];
        position = position{1};
    else
        position = "";
    end

    % Set goal metadata
    goal.season = season;
    goal.competition = goalWords(1);
    goal.matchday = goalWords(2);
    goal.date = goalWords(3);
    goal.venue = goalWords(4);
    goal.team = altWords(2);
    goal.opponent = altWords(3);
    goal.result = goalWords(6);
    goal.position = position;
    goal.minute = goalWords(7);
    goal.atscore = goalWords(8);
    goal.type = type;
    goal.assist = assist;
    
    errId = 0;
end
```

