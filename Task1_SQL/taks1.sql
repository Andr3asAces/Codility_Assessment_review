create table players (
      player_id integer not null unique,
      group_id integer not null
  );

  create table matches (
      match_id integer not null unique,
      first_player integer not null,
      second_player integer not null,
      first_score integer not null,
      second_score integer not null
  );

insert into players values(20, 2);
insert into players values(30, 1);
insert into players values(40, 3);
insert into players values(45, 1);
insert into players values(50, 2);
insert into players values(65, 1);
insert into matches values(1, 30, 45, 10, 12);
insert into matches values(2, 20, 50, 5, 5);
insert into matches values(13, 65, 45, 10, 10);
insert into matches values(5, 30, 65, 3, 15);
insert into matches values(42, 45, 65, 8, 4);


-- Solution

WITH winners AS(
SELECT match_id,
    CASE 
        WHEN first_score > second_score THEN first_player
        WHEN first_score < second_score THEN second_player
        WHEN (first_score = second_score) AND (first_player < second_player) THEN first_player
        WHEN (first_score = second_score) AND (first_player > second_player) THEN second_player
    END AS winner_id
FROM matches 
         )
		 
SELECT group_id, winner_id
FROM(
	SELECT group_id, winner_id, 
	ROW_NUMBER() OVER( PARTITION BY group_id ORDER BY winner_id_times_won DESC) AS ranked_by_winner_id_times_won
	FROM(
		SELECT group_id, COALESCE(winner_id, p.player_id) as winner_id, COUNT(winner_id) as winner_id_times_won
		FROM players as p
		LEFT JOIN winners as w
		ON p.player_id = w.winner_id
		GROUP BY group_id, w.winner_id, p.player_id
		ORDER BY group_id) AS winners_by_group
	) winners_by_group_ranked
WHERE ranked_by_winner_id_times_won IN (1);

