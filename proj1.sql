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
CREATE VIEW slgv(playerid, yearid, AB, slg) as
SELECT playerid,
  yearid,
  AB,
  (H + H2B + 2 * H3B + 3 * HR + 0.0) /(AB + 0.0)
FROM batting;
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg) AS
SELECT p.playerid,
  p.namefirst,
  p.namelast,
  s.yearid,
  s.slg
FROM people p
  INNER JOIN slgv s ON p.playerid = s.playerid
WHERE s.AB > 50
ORDER BY s.slg DESC,
  s.yearid,
  p.playerid
LIMIT 10;
-- Question 3ii
CREATE VIEW lslgview(playerid, lslg) AS
SELECT playerid,
  (
    SUM(H) + SUM(H2B) + 2 * SUM(H3B) + 3 * SUM(HR) + 0.0
  ) /(SUM(AB) + 0.0)
FROM batting
GROUP BY playerid
HAVING SUM(AB) > 50;
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg) AS
SELECT p.playerid,
  p.namefirst,
  p.namelast,
  l.lslg
FROM people p
  INNER JOIN lslgview l ON p.playerid = l.playerid
ORDER BY l.lslg DESC,
  p.playerid
LIMIT 10;
-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg) AS
SELECT p.namefirst,
  p.namelast,
  l.lslg
  FROM people p INNER JOIN lslgview l
  ON p.playerid = l.playerid
  WHERE l.lslg > (
    SELECT lslg
    FROM lslgview
    WHERE playerid = 'mayswi01'
  )
;
-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg) AS
SELECT 1,
  1,
  1,
  1 -- replace this line
;
-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count) AS
SELECT 1,
  1,
  1,
  1 -- replace this line
;
-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff) AS
SELECT 1,
  1,
  1,
  1 -- replace this line
;
-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid) AS
SELECT 1,
  1,
  1,
  1,
  1 -- replace this line
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
SELECT 1,
  1 -- replace this line
;