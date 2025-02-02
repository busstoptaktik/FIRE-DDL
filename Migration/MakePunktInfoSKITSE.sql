﻿/* -------------------------------------------------------------------------- */
/* Make PUNKTINFO data (with namespace SKITSE).
/* Data is found in REFGEO tables SKITSE and FIRE_SKITSER that was created by  
/* Kristian Evers specifically for migration purposes. 
/* File: MakePunktInfoSKITSE.sql   
/* -------------------------------------------------------------------------- */
/*
SPØRGSMÅL
*/

DELETE FROM PUNKTINFO WHERE INFOTYPEID IN (SELECT INFOTYPEID FROM PUNKTINFOTYPE WHERE INFOTYPE LIKE 'SKITSE:%');

-- SKITSE:sti
INSERT INTO PUNKTINFO (REGISTRERINGFRA, REGISTRERINGTIL, INFOTYPEID, TEKST, SAGSEVENTFRAID, PUNKTID)
SELECT 
    fs.IN_DATE AS REGISTRERINGFRA,
    ts.IN_DATE AS REGISTRERINGTIL,
    (SELECT INFOTYPEID FROM PUNKTINFOTYPE WHERE INFOTYPE = 'SKITSE:sti' AND ROWNUM <= 1) AS INFOTYPEID,
    imgs.FILEPATH AS TEKST,
    '15101d43-ac91-4c7c-9e58-c7a0b5367910' AS SAGSEVENTFRAID,
    conv.ID AS PUNKTID
FROM PUNKT p
INNER JOIN CONV_PUNKT conv ON p.ID = conv.ID
INNER JOIN (SELECT REFNR, VERSNR, IN_DATE FROM SKITSE@refgeo) fs ON fs.REFNR = conv.REFNR
INNER JOIN refadm.FIRE_SKITSER@refgeo imgs ON fs.REFNR = imgs.REFNR AND fs.VERSNR = imgs.VERSNR
LEFT JOIN (SELECT REFNR, VERSNR, IN_DATE FROM SKITSE@refgeo) ts ON ts.REFNR = fs.REFNR AND ts.VERSNR = (fs.VERSNR+1)
;

-- SKITSE:md5
INSERT INTO PUNKTINFO (REGISTRERINGFRA, REGISTRERINGTIL, INFOTYPEID, TEKST, SAGSEVENTFRAID, PUNKTID)
SELECT 
    fs.IN_DATE AS REGISTRERINGFRA,
    ts.IN_DATE AS REGISTRERINGTIL,
    (SELECT INFOTYPEID FROM PUNKTINFOTYPE WHERE INFOTYPE = 'SKITSE:md5' AND ROWNUM <= 1) AS INFOTYPEID,
    imgs.MD5 AS TEKST,
    '15101d43-ac91-4c7c-9e58-c7a0b5367910' AS SAGSEVENTFRAID,
    conv.ID AS PUNKTID
FROM PUNKT p
INNER JOIN CONV_PUNKT conv ON p.ID = conv.ID
INNER JOIN (SELECT REFNR, VERSNR, IN_DATE FROM SKITSE@refgeo) fs ON fs.REFNR = conv.REFNR
INNER JOIN refadm.FIRE_SKITSER@refgeo imgs ON fs.REFNR = imgs.REFNR AND fs.VERSNR = imgs.VERSNR
LEFT JOIN (SELECT REFNR, VERSNR, IN_DATE FROM SKITSE@refgeo) ts ON ts.REFNR = fs.REFNR AND ts.VERSNR = (fs.VERSNR+1)
;


COMMIT;