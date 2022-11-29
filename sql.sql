CREATE TABLE `MCD_Banned` (
  `banid` int(11) NOT NULL,
  `license` varchar(50) NOT NULL DEFAULT '',
  `reason` varchar(50) NOT NULL DEFAULT '',
  `unban` varchar(50) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `MCD_Banned`
  ADD PRIMARY KEY (`banid`);

ALTER TABLE `MCD_Banned`
  MODIFY `banid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
COMMIT;
