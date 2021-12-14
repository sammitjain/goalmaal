% Goalmaal - Real-time Club Football Player Goal Statistics inside MATLAB 
% *Tl;dr*: Goalmaal is a quick data scraper I wrote in MATLAB to source all 
% goal statistics for a specific player.
% 
% I wanted to experiment a bit with Messi's goal statistics and find out some 
% more insights about the players who have assisted him the most (It's not Dani 
% Alves or Xavi or Iniesta!). Turns out that it's not so easy to directly get 
% football goal data into MATLAB (I could be wrong about this, but I didn't find 
% a quick solution) - so I wrote a quick scraper for collecting goal data given 
% a player's name.
% 
% *Disclaimer:* In this case, all the data is available thanks to the amazing 
% folks at <https://www.transfermarkt.com/ transfermarkt.com> and I don't own 
% any of it. Would have loved to see a filter on the website itself but here we 
% are.
%
% Note: For a detailed explanation of this script, check out the associated live
% script.

% Set player data
playerName = "Lionel Messi";
goalsURL = "https://www.transfermarkt.com/lionel-messi/alletore/spieler/28003/saison//verein/0/liga/0/wettbewerb//pos/0/trainer_id/0/minute/0/torart/0/plus/1";

% Read the URL and retrieve HTML data
goalsHTML = urlread(goalsURL);
goalsHTMLTree = htmlTree(goalsHTML);

% Find and filter valid goal rows
goalRows = findElement(goalsHTMLTree,"tr");
goalRows(1:10) = [];
overallStats = goalRows(end);
goalRows(end) = [];

% Extract Season info
[goal,~,season] = extractGoalInfo(goalRows(1));

% Populate Goals
[goal,~,season] = extractGoalInfo(goalRows(2),goal,season);
goals = goal;

for rowIdx = 3:numel(goalRows)
    [goal,errId,season] = extractGoalInfo(goalRows(rowIdx),goal,season);
    if errId~=1                 % Not a season heading
        goals = [goals goal];
    end
end

goalsTable = struct2table(goals);

player = repmat(playerName,[height(goalsTable) 1]);
goalsTable.player = player;

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
