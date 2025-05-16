# Spotify Advanced SQL Project and Query Optimization P-6
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Spotify Logo](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_logo.jpg)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
-- create table
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
);
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 4. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.
  
---

## 15 Practice Questions

### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.
```sql
Select *
From spotify
Where stream > 1000000000;
```

2. List all albums along with their respective artists.
```sql
Select 
	album, 
	artist
From spotify;
```

3. Get the total number of comments for tracks where `licensed = TRUE`.
```sql
Select sum(comments) as total_comments
From spotify
Where licensed = 'True';
```
4. Find all tracks that belong to the album type `single`.
```sql
Select *
From spotify
Where album_type = 'single';
```

5. Count the total number of tracks by each artist.
```sql
Select
	artist,
	count(*) as number_of_songs
From spotify
Group by 
	artist
Order by number_of_songs desc;
```

### Medium Level
1. Calculate the average danceability of tracks in each album.
```sql
Select 
	album,
	round(avg(danceability)::numeric, 2) as avg_danceability
From spotify
Group by 
	album
Order by avg_danceability desc;
```

2. Find the top 5 tracks with the highest energy values.
```sql
Select track,
	max(energy) 
From spotify
Group by track
Order by max(energy) desc
limit 5;
```

3. List all tracks along with their views and likes where `official_video = TRUE`.
```sql
Select 
	track, 
	sum(views) as total_views, 
	sum(likes) as total_likes
from spotify
Where official_video = True
Group by track;
```

4. For each album, calculate the total views of all associated tracks.
```sql
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
```

5. Retrieve the track names that have been streamed on Spotify more than YouTube.
```sql
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
```

### Advanced Level
1. Find the top 3 most-viewed tracks for each artist using window functions.
```sql
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
```

2. Write a query to find tracks where the liveness score is above the average.
```sql
   Select 
	track,
	artist,
	liveness
From spotify
Where liveness > (Select avg(liveness) from spotify);
```

3. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
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
```
   
4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
```sql
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
```


5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
```sql
Select 
	track, 
	likes, 
	views,
	Sum(likes) Over(Partition by track Order by views) as cumulative_likes
From spotify
Order by track
```



## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4 (or any SQL editor), PostgreSQL (via Homebrew, Docker, or direct installation)


