--I - Simple queries
--Ex 1: 459 rows
select
	EventName,
	EventDate
from
	tblEvent
order by
	EventDate desc;

--Ex2:
SELECT
	top 5 
	EventName as What,
	EventDetails as Details 
From
	tblEvent te
Order by
	EventDate ASC;
	/* "Select top 5 event name" to limit the results in only 5 rows.
	 *Use "Order by EventDate ASC" to arrange the results in date order (from the earliest to latest).
	 */

--Ex3:
Select 
top 3
	CategoryID,
	CategoryName
From
	tblCategory tc
Order by
	CategoryName DESC; 
--Use "TOP 3" to limit the number of rows and "DESC" to arrange the last the in the alphabetical order.

--Ex4:
SELECT
	top 2 
	EventName,
	EventDetails
from
	tblEvent te
Order by
	EventDate ASC;
SELECT
	top 2
	EventName,
	EventDetails
FROM
		tblEvent te2
Order by
		EventDate DESC; 
	
--II - Using Where
--Ex 1:
select
	*
from
	tblEvent te
where
	CategoryID = 11;

--Ex2:
select
	*
from
	tblEvent te
where
	year(EventDate) = 2005
	and month(EventDate) = 2;
	
--Ex3:
SELECT
	EventName
from
	tblEvent te
where
	EventName like '%Teletubbies%'
	or EventName like '%Pandy%';
--As I don't know the arrangement of the words in the events, '%Teletubbies%' and '%Pandy%' can help me sort out the event names containing those words.

--Ex4:
select
	*
from
	tblEvent te
where
	(CountryID in (8, 22, 30, 35)
	or EventDetails like '%Water %'
	or CategoryID = 4) 
	and year(EventDate) >= 1970
--Here I use "OR" based on the requirements (one OR more of the following is true). 

--Ex5:
SELECT
	*
FROM
	tblEvent te
Where
	CategoryID != '14'
	and EventDetails like '%train%';
--Use "AND" to meet the requirements (Events aren't in the Transport category (No.14) and Include the text "train")

--Ex6: 
SELECT
	EventName,
	EventDetails,
	CountryID 
FROM
	tblEvent te
Where
	CountryID = '13'
	and EventName not like '%space%'
	and EventDetails not like '%space%';
--Using "NOT LIKE" to sort out the Events which don't mention the word "space" in eventname and eventdetails

--Ex7: 91 rows
SELECT
	EventName,
	EventDetails,
	CategoryID
FROM
	tblEvent te
Where
	CategoryID in (5, 6)
	and EventDetails not like '%war%'
	and EventDetails not like '%death%';

--V - Basic join
--Ex 1: 13 rows
SELECT
	tblAuthor.AuthorName,
	tblEpisode.Title,
	tblEpisode.EpisodeType
FROM
	tblAuthor
INNER JOIN tblEpisode ON
	tblAuthor.AuthorId = tblEpisode.AuthorId
WHERE
	tblEpisode.EpisodeType LIKE '%special%'
ORDER BY
	tblEpisode.Title;

--Ex2:
SELECT
	td.DoctorName,
	te.Title as Ep_title,
	te.EpisodeDate
FROM
	tblEpisode te
Left join tblDoctor td on
	te.DoctorId = td.DoctorId
Where
	te.EpisodeDate like '2010%';
	
--Ex3:
Select
	te.EventName,
	te.EventDate,
	tc.CountryName 
From
	tblCountry tc
Left join tblEvent te on
	tc.CountryID = te.CountryID;
	
--Ex4: 
Select
	te.EventName,
	tc.ContinentName,
	tc2.CountryName
From
	tblContinent tc
Left join tblCountry tc2 on
	tc.ContinentID = tc2.ContinentID
Left join
	tblEvent te on
	tc2.CountryID = te.CountryID
Where
	tc.ContinentName like '%Antarctic%'
	or tc2.CountryName like '%Russia%';
/*Keep repeating the "join" syntax. No need for a comma after each.
 * Here I first join tblContinent with tblCountry and then merge tblCountry with tbl Event.
 */

--Ex5:
Select
	*
From
	tblCategory tc
Full join tblEvent te on
	tc.CategoryID = te.CategoryID
Where
	te.EventName is null;
/*Inner join: There are 459 ROWS in the full table.
 * Full outer join: There are 461 ROWS in the full table.
 */

--Ex6: 
select
	Title,
	authorname,
	enemyname
from
	tblEpisode te
inner join tblAuthor ta on
	te.AuthorId = ta.AuthorId
inner join tblEpisodeEnemy tee on
	te.EpisodeId = tee.EpisodeId
inner join tblEnemy te2 on
	tee.EnemyId = te2.EnemyId
where
	te2.EnemyName = 'Daleks';
/*Here I use Inner joins based on requirements and the diagram. 
 * "tblEpisodeEnemy" joins with "tblEnemy" by "EnemyID".
 * "tblEpisodeEnemy" joins with "tblEpisode" by "EpisodeID".
 * "tblEpisode" joins with "tblAuthor" by "AuthorID"
 */ 

--Ex7:
Select
	ta.AuthorName,
	te2.Title as Ep_title,
	td.DoctorName,
	te.EnemyName,
	(Len(ta.AuthorName)+ Len(te2.Title)+ Len(td.DoctorName)+ Len(te.EnemyName)) as Character_Length
From
	tblEpisodeEnemy tee
Inner join tblEnemy te on
	tee.EnemyId = te.EnemyId
Inner join tblEpisode te2 on
	tee.EpisodeId = te2.EpisodeId
Inner join tblAuthor ta on
	te2.AuthorId = ta.AuthorId
Inner join tblDoctor td on
	te2.DoctorId = td.DoctorId
Where
	(Len(ta.AuthorName)+ Len(te2.Title)+ Len(td.DoctorName)+ Len(te.EnemyName)) < 40;
/*The joins are still the same as Ex6 with "tblEpisode" joins with "tblDoctor" by "DoctorID".
 * Well, I did google the Len() function and the arithmetic Operator (+) (The examples and explanation)
 */

--Ex8:
Select
	tc.CountryName,
	te.EventName
From
	tblCountry tc
Full join tblEvent te on
	tc.CountryID = te.CountryID
Where
	te.EventName is null;

--VI - Aggregation and Grouping 
--Ex 1: 25 rows
select
	ta.AuthorName,
	count(distinct EpisodeId) as [Count Episode],
	min(EpisodeDate) as [Earliest episode date],
	max(EpisodeDate) as [Latest episode date]
from
	tblEpisode te
inner join tblAuthor ta on
	te.AuthorId = ta.AuthorId
group by
	ta.AuthorName
order by
	count(distinct EpisodeId) desc;

--Ex2: 18 rows, 20 rows if use left join
select
	tc.CategoryName ,
	count(distinct te.EventID) as [Count event]
from
	tblCategory tc
inner join tblEvent te on
	tc.CategoryID = te.CategoryID
group by
	tc.CategoryName
order by
	count(distinct te.EventID) desc;
	
--Ex3: 
Select
	count(EventID) as [Number of Events],
	Min(EventDate) as [First date],
	Max(EventDate) as [Last date]
From
	tblEvent te 
	--Instructed by Phuong Anh D:
	
--Ex 4: 42 rows
select
	tc2.ContinentName ,
	tc.CountryName ,
	count(distinct te.EventID) as [Number of events]
from
	tblEvent te
inner join tblCountry tc on
	te.CountryID = tc.CountryID
inner join tblContinent tc2 on
	tc2.ContinentID = tc.ContinentID
group by
	tc2.ContinentName ,
	tc.CountryName;
  
	
--Ex 5: 4 rows
select
	ta.AuthorName ,
	td.DoctorName ,
	count(distinct te.EpisodeId) as [Number of episodes]
from
	tblEpisode te
inner join tblAuthor ta on
	te.AuthorId = ta.AuthorId
inner join tblDoctor td on
	te.DoctorId = td.DoctorId
group by
	ta.AuthorName ,
	td.DoctorName
having
	count(distinct te.EpisodeId) > 5
order by
	count(distinct te.EpisodeId) desc;

--Ex 6: 4 rows
select
	year(te.EpisodeDate) as [Episode Year],
	te2.EnemyName,
	count(distinct te.EpisodeId) as [Episodes]
from
	tblEpisode te
inner join tblEpisodeEnemy tee on
	te.EpisodeId = tee.EpisodeId
inner join tblEnemy te2 on
	tee.EnemyId = te2.EnemyId
inner join tblDoctor td on 
	te.DoctorId = td.DoctorId 
where year(td.BirthDate) < 1970
group by
	year(te.EpisodeDate) ,
	te2.EnemyName
having 
	count(distinct te.EpisodeId) > 1
order by 
	count(distinct te.EpisodeId) desc
	
--Ex 7: 12 rows without nulls, 14 rows with nulls
select
	left(tc.CategoryName, 1),
	count(distinct te.EventID) as [Number of events],
	avg(len(EventName)) as [Average event name length]
from
	tblEvent te
inner join tblCategory tc on
	te.CategoryID = tc.CategoryID
group by
	left(tc.CategoryName, 1)
order by 
	avg(len(EventName)) desc;

--Ex8:
select
	concat(1 + (year(EventDate) - 1) / 100,  
		case when right(1 + (year(EventDate) - 1) / 100, 1) = 1 
			 then 'st'
			 when right(1 + (year(EventDate) - 1) / 100, 1) = 2
			 then ' nd'
			 when right(1 + (year(EventDate) - 1) / 100, 1) = 3 
			 then ' rd'
			 else 'th'
			 end,
		' century')
	as century,
	count(distinct EventID) as [Number of events]
from
	tblEvent te
group by
	1 + (year(EventDate) - 1) / 100;
	--a bit complicated right here 

V.Calculations
--Ex1:
Select
	EventName,
	Len(EventName) as [Number of letters]
From
	tblEvent
Order by
	Len(EventName) asc;
	
--Ex2:
Select
	EventName,
	EventID,
	Concat(EventName, ' ', EventID) as [Results]
From
	tblEvent; 
	
--Ex3:
select 
	ContinentID,
	ContinentName, 
	Summary,
	isnull(Summary, 'No summary') as [IsNull], 
	COALESCE(Summary, 'No summary') as [Coalesce],
	case when Summary is null then 'No summary'	else Summary end as [Case When]
from 
	tblContinent tc;
 
	
--Ex4:
Select
	ContinentID,
	CountryName,
	Case
		when ContinentID in (1, 3) then 'Eurasia'
		when ContinentID in (2, 4) then 'Somewhere hot'
		When ContinentID in (5, 6) then 'Americas'
		when ContinentID in (7) then 'Somewhere cold'
		Else 'Somewhere else'
	End as [Country Location]
From
		tblCountry tc
Order by
	ContinentID Asc;
	
--Ex5:
select country, 
	   KmSquared,
	   KmSquared % 20761 as AreaLeftOver, round(KmSquared / 20761,0) as WalesUnits, 
	   concat(round(KmSquared / 20761,0), ' x Wales plus ', KmSquared % 20761, ' sq. km') as WalesComparison
from
	CountriesByArea cba
order by abs(KmSquared - 20761) ASC;
		
--Ex6:
Select
	EventName,
	Left(EventName, 1) as [Start],
	Right(EventName, 1) as [End]
From
	tblEvent te
Where
	Left(EventName, 1) in ('A', 'E', 'I', 'O', 'U')
	and Right(EventName, 1) in ('A', 'E', 'I', 'O', 'U')
	Order by EventName Asc;
	
--Ex7: 
Select
	EventName,
	Left(EventName, 1) as [Start],
	Right(EventName, 1) as [End]
From
		tblEvent te
Where
	Left(EventName, 1) = Right(EventName, 1)
Order by
	EventName Asc;
	
--VI.Calculations using dates
--Ex1:
Select
	EventName,
	DatePart(year, EventDate) as [Year]
From
	tblEvent te
Where
	DatePart(year, EventDate) = 2000
Order by
	EventName Asc;
	
--Ex2:
Select
	EventDate,
	DateDiff(Day, '2000-09-05', EventDate) as [Elapsed],
	Abs(DateDiff(Day, '2000-09-05', EventDate)) as [Diffrences]
From
	tblEvent te
Order by
	Abs(DateDiff(Day, '2000-09-05', EventDate)) Asc;
	
--Ex3: 
select
	EventName,
	EventDate,
	datename(weekday, EventDate) as [Day of week],
	datepart(day, EventDate) as [Day number]
from
	tblEvent te
where 
	datename(weekday, EventDate) = 'Friday' 
	and datepart(day, EventDate) = 13;

select
	EventName,
	EventDate,
	datename(weekday, EventDate) as [Day of week],
	datepart(day, EventDate) as [Day number]
from
	tblEvent te
where 
	datename(weekday, EventDate) = 'Thursday' 
	and datepart(day, EventDate) = 12;
	
select
	EventName,
	EventDate,
	datename(weekday, EventDate) as [Day of week],
	datepart(day, EventDate) as [Day number]
from
	tblEvent te
where 
	datename(weekday, EventDate) = 'Saturday' 
	and datepart(day, EventDate) = 14;

		
--Ex4: 
select 
	eventname,
	eventdate , 
	datename(weekday, EventDate) as [weekday], 
	datepart(day, EventDate) as [day], 
	case  
		when datepart(day, EventDate) in (01, 21, 31) then 'st'
		when datepart(day, EventDate) in (02, 22) then 'nd'
		when datepart(day, EventDate) in (03, 23) then 'rd'
		else 'th'
	end as [stt],
	datename(month, EventDate) as month,
	year(EventDate) as year,
	concat(datename(weekday, EventDate), 
			' ', 
		datepart(day, EventDate),
		case  
			when datepart(day, EventDate) in (01, 21, 31) then 'st'
			when datepart(day, EventDate) in (02, 22) then 'nd'
			when datepart(day, EventDate) in (03, 23) then 'rd'
			else 'th'
		end,
		' ',
		datename(month, EventDate),
		' ', 
		year(EventDate) ) as [FullDate]
from 
	tblEvent te;




--Intermediate SQL
--I - Subqueries
--Ex1:
Select
	EventName,
	EventDate
From
	tblEvent te
Where
	EventDate > (
	Select
		Max(EventDate)
	From
		tblEvent te2
	Where
		CountryID = 21)
Order by
	EventDate Desc;
	

--Ex2:
Select
	EventName
From
	tblEvent te
Where
	Len(EventName) > (
	Select
		Avg(Len(EventName))
	From
		tblEvent te2);

--Ex3:
-- 8 rows
select
	tc4.ContinentName ,
	EventName
from
	tblEvent te2
inner join tblCountry tc3 on
	te2.CountryID = tc3.CountryID
inner join tblContinent tc4 on
	tc3.ContinentID = tc4.ContinentID
where
	tc4.ContinentName in (
	select 
		top 3 tc2.ContinentName 
	from
		tblEvent te
	inner join tblCountry tc on
		te.CountryID = tc.CountryID
	inner join tblContinent tc2 on
		tc.ContinentID = tc2.ContinentID
	group by
		tc2.ContinentName
	order by
		count(distinct EventID) asc);
	
--Ex4:
Select
	tc.CountryName
From
	tblCountry tc
Where
	8 < (
	Select
		Count(te.EventID)
	From
		tblEvent te
	Where
		te.CountryID = tc.CountryID)
Order by
	tc.CountryName Asc;

--Ex5:
Select
	te.EventName
From
	tblEvent te
Where
	CountryID not in (
	Select
		top 30 tc.CountryID
	From
		tblCountry tc
	Order by
		tc.CountryName Desc)
	and CategoryID not in (
	Select
		top 15 tc2.CategoryID
	From
		tblCategory tc2 
	Order by
		tc2.CategoryName Desc)
	Order by EventName Asc;
		
		  
	
--II - CTEs	
--Ex1: 
With ThisAndThat as (
Select
	Case
		When te.EventName like '%this%' Then '1'
		Else '0'
	End as IfThis,
	Case
		When te.EventName like '%that%' then '1'
		Else '0'
	End as IfThat
From
	tblEvent te)
,
Result1 as (
Select
	tt.IfThis,
	tt.IfThat,
	Count(*) as [No. of Events]
From
	ThisAndThat as tt
Group by
	tt.IfThis,
	tt.IfThat)
	
Select
	te.EventName,
	te.EventDetails
From
	tblEvent te
Where
	te.EventDetails like '%this%' and te.EventDetails like '%that%';
	
--Ex2:
Select
	Second_half_Derived.EventName,
	tc.CountryID
From
	(
	Select
		te.EventName,
		te.CountryID
	From
		tblEvent te
	Where
		right(EventName,
		1) like '[n-z]') as Second_half_Derived
Left join tblCountry tc on
	Second_half_Derived.CountryID = tc.CountryID
Order by
	Second_half_Derived.EventName Asc;

--Ex3:
-- 4 rows
WITH mpEpisodes AS (
	SELECT
		e.EpisodeId
		--a.AuthorName
	FROM
		tblEpisode AS e
		INNER JOIN tblAuthor AS a ON e.AuthorId = a.AuthorId
	WHERE
		a.AuthorName like '%mp%'
)
SELECT DISTINCT
	c.CompanionName
FROM 
	mpEpisodes AS e
	INNER JOIN tblEpisodeCompanion AS ec ON e.EpisodeId = ec.EpisodeId
	INNER JOIN tblCompanion AS c ON ec.CompanionId = c.CompanionId
ORDER BY
	c.CompanionName;


--Ex4: 
With No_OWL_Events as
(
Select
	*
From
	tblEvent te
Where
	EventDetails not like '%o%'
	And EventDetails not like '%w%'
	And EventDetails not like '%l%')
,	
Event_Location as
(
Select
	tc.CountryName,
	te2.EventName, 
	te2.CountryID,
	te2.CategoryID
From
	No_OWL_Events as NOE
Left join tblCountry tc on
	NOE.CountryID = tc.CountryID
Inner join tblEvent te2 on
	te2.CountryID = NOE.Countryid)
	
Select
	distinct tc.CategoryName,
	te.EventName
From
	Event_Location as other
Left join tblCategory tc on
	tc.CategoryID = other.CategoryID
Left join tblEvent te on
	te.CategoryID = other.categoryid;
	
--Ex5:
With ERA_Events as (
Select
	Case when Year(EventDate) < 1900 then '19th century and earlier'
	When Year(EventDate) < 2000 then '20th century' 
	Else '21st century'
	End as [Era],
	EventID
From
	tblEvent te)
	
Select
	EE.[Era],
	Count(te.EventID) as [No. of Events]
From
	tblEvent te
Left join ERA_Events as EE on
	te.EventID = EE.EventID
Group by
	EE.[Era];