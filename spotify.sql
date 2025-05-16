-- Advanced SQL Project -- Spotify 

Drop Table if Exists spotify;

Create Table spotify(
	artist VARCHAR(255),
	track VARCHAR(225),
	album VARCHAR(255),
	album_type VARCHAR(50),
	danceability FLOAT,
	energy FLOAT,
	loudness FLOAT,
	speechiness FLOAT,
	acousticness FLOAT,
	instrumentalness FLOAT,
	liveness FLOAT,
	valence FLOAT,
	tempo FLOAT, 
	duration_min FLOAT,
	title VARCHAR(255),
	channel VARCHAR(225),
	views FLOAT,
	likes BIGINT,
	comments BIGINT,
	licensed BOOLEAN,
	official_video BOOLEAN,
	stream BIGINT,
	energyLiveness FLOAT,
	most_playedon VARCHAR(50)
)


Select count(*)
from spotify;

Select count(distinct artist)
from spotify;

Select count(distinct album)
from spotify;

Select distinct album_type
from spotify;

Select max(duration_min)
from spotify;

Select *
from spotify
where duration_min = 0;

Delete from spotify
where duration_min = 0;


-- ----------------------------------------------------
-- DATA ANALYSIS - EASY
-- ----------------------------------------------------

-- 1. Retrieve the names of all tracks that have more than 1 billion streams. 

Select *
From spotify
Where stream > 1000000000;

-- 2. List all albums along with their respective artists.

Select 
	album, 
	artist
From spotify;

-- 3. Get the total number of comments for tracks where licensed = True.

Select sum(comments) as total_comments
From spotify
Where licensed = 'True';

-- 4. Find all tracks that belong to album type single

Select *
From spotify
Where album_type = 'single';

-- 5. Count the total number of tracks by each artist.

Select
	artist,
	count(*) as number_of_songs
From spotify
Group by 
	artist
Order by number_of_songs desc;

-- ----------------------------------------------------
-- DATA ANALYSIS - MEDIUM
-- ----------------------------------------------------

-- 6. Calculate the average danceability of tracks in each album.

Select 
	album,
	round(avg(danceability)::numeric, 2) as avg_danceability
From spotify
Group by 
	album
Order by avg_danceability desc;

-- 7. Find the top 5 tracks with the highest energy values. 

Select track,
	max(energy) 
From spotify
Group by track
Order by max(energy) desc
limit 5;

-- 8. List all the tracks along with their views and likes where official_video = TRUE

Select 
	track, 
	sum(views) as total_views, 
	sum(likes) as total_likes
from spotify
Where official_video = True
Group by track;

-- Q9. For each album, calculate the total views of all associated tracks.

Select 
	album, 
	album_type, 
	artist, 
	count(track) as number_of_songs, 
	sum(views) as total_views
From spotify
Group by 
	album, 
	album_type, 
	artist;

-- Q10. Retrieve the track names that have been streamed on spotify more than Youtube

Select *
From
(
Select 
	track,
	--most_playedon,
	Coalesce(sum(Case when most_playedon = 'Youtube' then stream end), 0) as streamed_on_youtube,
	Coalesce(sum(Case when most_playedon = 'Spotify' then stream end), 0) as streamed_on_spotify
From spotify
Group by track
) as t1
Where 
	streamed_on_spotify > streamed_on_youtube 
	and streamed_on_youtube != 0

-- 11. Find the top 3 most-viewed tracks for each artist using window functions. 

Select *
From 
(
Select 
	artist, 
	track, 
	sum(views) as total_views,
	dense_rank() over(Partition by artist Order by sum(views) desc) as rank
From spotify
Group by 
	artist,
	track
Order by artist, total_views desc
)
Where rank between 1 and 3;

-- 12. Write a query to find tracks where the liveness score is above the average. 

Select 
	track,
	artist,
	liveness
From spotify
Where liveness > (Select avg(liveness) from spotify)

-- 13. use a WITH clause to calculate the differnce between the highest and lowest energy values for tracks in each column

With Diff
As
(
Select 
	album, 
	max(energy) as max_energy, 
	min(energy) as min_energy
From spotify
Group by album)

Select *, round((max_energy-min_energy)::numeric, 4) as energy_difference
From Diff

Order by energy_difference desc;


 -- 14. Find tracks where the energy-to-likeness ratio is greater thab 1.2

Select *
From
(
 Select 
 	track, 
	 energy, 
	 liveness,
	 round((energy/liveness)::numeric, 3) as energy_to_liveness_ratio
 From spotify
) as t1

Where energy_to_liveness_ratio > 1.2


-- 15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

Select 
	track, 
	likes, 
	views,
	Sum(likes) Over(Partition by track Order by views) as cumulative_likes
From spotify
Order by track





 



