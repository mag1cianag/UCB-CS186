-- Before running drop any existing views
DROP VIEW IF EXISTS q0;
DROP VIEW IF EXISTS q1i;
DROP VIEW IF EXISTS q1ii;
DROP VIEW IF EXISTS q1iii;
DROP VIEW IF EXISTS q1iv;
DROP VIEW IF EXISTS q2i;
DROP VIEW IF EXISTS q2ii;
DROP VIEW IF EXISTS q2iii;
DROP VIEW IF EXISTS q3i;
DROP VIEW IF EXISTS q3ii;
DROP VIEW IF EXISTS q3iii;
DROP VIEW IF EXISTS q4i;
DROP VIEW IF EXISTS q4ii;
DROP VIEW IF EXISTS q4iii;
DROP VIEW IF EXISTS q4iv;
DROP VIEW IF EXISTS q4v;
-- Question 0
CREATE VIEW q0(era) AS
SELECT Max(era)
FROM pitching;
-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear) AS
SELECT namefirst,
  namelast,
  birthyear
FROM people
WHERE weight > 300;
-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear) AS
SELECT namefirst,
  namelast,
  birthyear
FROM people
WHERE namefirst LIKE '% %'
ORDER BY namefirst,
  namelast;
-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count) AS
SELECT birthyear,
  AVG(height),
  COUNT(*)
FROM people
GROUP BY birthyear
ORDER BY birthyear;
-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count) AS
SELECT birthyear,
  AVG(height) as a,
  COUNT(*)
FROM people
GROUP BY birthyear
HAVING a > 70
ORDER BY birthyear;
-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid) AS
SELECT p.namefirst,
  p.namelast,
  h.playerID,
  h.yearid
FROM people p,
  halloffame h
WHERE p.playerID = h.playerID
  AND h.inducted = 'Y'
ORDER BY h.yearid DESC,
  p.playerID;
-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid) AS
SELECT p.nameFirst,
  p.nameLast,
  c.playerID,
  s.schoolID,
  h.yearid
FROM collegeplaying c,
  halloffame h,
  people p,
  schools s
WHERE p.playerID = h.playerID
  AND c.playerID = h.playerID
  AND S.SCHOOLID = C.SCHOOLID
  AND s.schoolState = 'CA'
  AND h.inducted = 'Y'
ORDER BY h.yearid DESC,
  s.schoolID,
  c.playerID;
-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid) AS
SELECT q.playerID,
  namefirst,
  namelast,
  schoolid
FROM q2i q
  LEFT OUTER JOIN collegeplaying c ON q.playerID = c.playerID
ORDER BY q.playerID DESC,
  schoolID;
-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg) AS WITH slgt(playerid, yearid, slg) AS (
  SELECT playerid,
    yearid,
    (H + H2B + 2 * H3B + 3 * HR) * 1.0 / AB
  FROM batting
  where AB > 50
)
SELECT p.playerid,
  p.namefirst,
  p.namelast,
  s.yearid,
  s.slg
FROM people p,
  slgt s
WHERE p.playerid = s.playerid
ORDER BY s.slg DESC,
  s.yearid,
  p.playerid
LIMIT 10;
-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg) AS WITH SUMDATA(playerid, H, H2B, H3B, HR, AB) AS (
  SELECT b.playerid,
    SUM(b.H),
    SUM(b.H2B),
    SUM(b.H3B),
    SUM(b.HR),
    SUM(b.AB)
  FROM batting b,
    people p
  WHERE b.playerid = p.playerid
  GROUP BY b.playerid
  HAVING SUM(b.AB) > 50
),
LSLG(playerid, lslg) AS (
  SELECT playerid,
    (H + H2B + 2 * H3B + 3 * HR) * 1.0 / AB
  FROM SUMDATA
)
SELECT q.playerid,
  q.namefirst,
  q.namelast,
  l.lslg
FROM people q,
  LSLG l
WHERE q.playerid = l.playerid
ORDER BY l.lslg DESC,
  q.playerid
LIMIT 10;
-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg) AS WITH LSLG(playerid, lslg) AS (
  SELECT playerid,
    (
      (SUM(H) + SUM(H2B) + 2 * SUM(H3B) + 3 * SUM(HR)) * 1.0 / SUM(AB)
    )
  FROM batting
  GROUP BY playerid
  HAVING SUM(AB) > 50
)
SELECT p.namefirst,
  p.namelast,
  l.lslg
FROM LSLG AS l,
  people AS p
WHERE l.playerid = p.playerid
  AND l.lslg > (
    SELECT lslg
    FROM LSLG
    WHERE playerid = 'mayswi01'
  );
-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg) AS
SELECT yearid,
  MIN(salary),
  max(salary),
  avg(salary)
FROM salaries
GROUP BY yearid
ORDER BY yearid;
-- Question 4ii
-- Helper TABLE
DROP TABLE IF EXISTS binids;
CREATE TABLE binids(binid);
INSERT INTO binids
VALUES (0),
  (1),
  (2),
  (3),
  (4),
  (5),
  (6),
  (7),
  (8),
  (9);
CREATE VIEW q4ii(binid, low, high, count) AS WITH stat(min_2016, max_2016, range_2016, over_range) AS (
  SELECT MIN(salary),
    MAX(salary),
    (MAX(salary) - MIN(salary)) / 10,
    (MAX(salary) + 0.1 - MIN(salary)) / 10
  FROM salaries
  WHERE yearid = '2016'
),
bin(binid, count) AS (
  SELECT CAST(((salary - min_2016) / over_range) AS INTEGER) AS binid,
    COUNT(*)
  FROM salaries,
    stat
  WHERE yearid = '2016'
  GROUP BY binid
)
SELECT binid,
  min_2016 + range_2016 * binid,
  min_2016 + range_2016 *(binid + 1),
  count
FROM bin,
  stat
ORDER BY binid;
-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff) AS
SELECT cur.yearid,
  cur.min - pre.min,
  cur.max - pre.max,
  cur.avg - pre.avg
FROM q4i AS cur,
  q4i AS pre
WHERE cur.yearid = pre.yearid + 1
ORDER BY cur.yearid;
-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid) AS WITH max_salary(yearid, playerid, salary) AS (
  SELECT yearid,
    playerid,
    MAX(salary)
  FROM salaries
  GROUP BY yearid
)
SELECT p.playerid,
  namefirst,
  namelast,
  salary,
  yearid
FROM people AS p,
  max_salary as ms
WHERE p.playerid = ms.playerid
  AND (
    ms.yearid = '2000'
    OR ms.yearid = '2001'
  )
ORDER BY yearid;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
SELECT af.teamid,
  MAX(s.salary) - MIN(s.salary)
FROM allstarfull AS af,
  salaries as s
WHERE af.playerid = s.playerid
  AND af.yearid = '2016'
  AND s.yearid = '2016'
GROUP BY af.teamid
ORDER BY af.teamid;