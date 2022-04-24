-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 30, 2022 at 08:31 PM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 8.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mybnb`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `billAmt` (IN `book_id` VARCHAR(8), IN `prop_id` VARCHAR(20), IN `fromDate` DATE, IN `toDate` DATE)  NO SQL
Update bookings set amount = ((select rent_amt from properties where property_id = prop_id) * datediff(toDate,fromDate))
where booking_id = book_id$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `booking_id` varchar(8) NOT NULL,
  `property_id` varchar(20) DEFAULT NULL,
  `user_id` varchar(20) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`booking_id`, `property_id`, `user_id`, `from_date`, `to_date`, `amount`) VALUES
('bUs5QFER', 'man1', 'sumit17', '2022-02-15', '2022-02-24', 9000),
('NSVsahjQ', 'sim1', 'sumit17', '2021-06-10', '2021-06-22', 21600),
('ptrP8UyW', 'and2', 'sumit17', '2022-02-10', '2022-02-18', 8000),
('QBM0Ffdm', 'man1', 'sumit17', '2021-06-10', '2021-06-22', 12000),
('wkzJLwpy', 'sim2', 'sumit17', '2022-02-01', '2022-02-16', 12000),
('wQDShwFl', 'man2', 'sumit17', '2021-06-10', '2021-06-22', 26400);

--
-- Triggers `bookings`
--
DELIMITER $$
CREATE TRIGGER `changeAvailability` AFTER INSERT ON `bookings` FOR EACH ROW UPDATE properties 
set availability = 'No' 
WHERE new.property_id = property_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `makeAvailable` BEFORE INSERT ON `bookings` FOR EACH ROW update properties 
set availability="Yes"
where property_id IN (select property_id from bookings where to_date < curDate())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `hosts`
--

CREATE TABLE `hosts` (
  `host_id` varchar(20) NOT NULL,
  `host_name` varchar(30) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `pan_no` varchar(10) DEFAULT NULL,
  `phone_no` bigint(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `hosts`
--

INSERT INTO `hosts` (`host_id`, `host_name`, `password`, `pan_no`, `phone_no`) VALUES
('kumar', 'Kumar Shanu', '$2b$10$.eHmxuYg0TW47HGLb1JlK.Z7pOLr1V9d48MRhDMT5x9ZBPsXCXHu2', 'GKLSJ9088R', 6290075880),
('nrk20', 'Narayan', '$2b$10$Jkq5Fr5Va.MpMgFYBjWpoeuP.VTY8k7xw9tZx03fpcnJqsWiSbTze', 'KOKOP5050K', 9988770022),
('pk123', 'Pankaj Kumar', '$2b$10$lkS5vkC8i5fv8eDWl.XgoOlwvs0KMQuTSAeezv.V3ECaNW4LCi5J.', 'ROUCK2121R', 8892070022),
('priya', 'Priya Anand', '$2b$10$MW9h6uDatmWRkPqZEE6DzuiRhrimtoLdbjuPujgXMnyGYIET44ppC', 'SOUPP2222R', 9122320050),
('raj123', 'Raj Kumar', '$2b$10$hG.t8tMVpgB2RjTa2BLneOWi7hVI3wG3Hcinu4DD5DK2sCgG02jDW', 'GLISJ9088P', 8989009090),
('rm02', 'Ram Yadav', '$2b$10$aINSgvTJMkGf/jQrteomOu15d5TFA72eY9IYqjP6lCFXxTog/O4x6', 'LFHGJ9001B', 9001190400),
('sk15', 'Shyam Kumar', '$2b$10$5XmWGn7iZSBuC6APa.B5gOvuCNo2WhcAhe1obsfbhx7rRraym9aXy', 'JKHHI2120I', 8786780011);

-- --------------------------------------------------------

--
-- Stand-in structure for view `host_view`
-- (See below for the actual view)
--
CREATE TABLE `host_view` (
`host_id` varchar(20)
,`password` varchar(128)
);

-- --------------------------------------------------------

--
-- Table structure for table `properties`
--

CREATE TABLE `properties` (
  `host_id` varchar(20) DEFAULT NULL,
  `property_id` varchar(20) NOT NULL,
  `property_name` varchar(30) DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `city` varchar(10) DEFAULT NULL,
  `rent_amt` int(11) DEFAULT NULL,
  `availability` varchar(3) DEFAULT NULL,
  `rating` decimal(2,1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `properties`
--

INSERT INTO `properties` (`host_id`, `property_id`, `property_name`, `location`, `city`, `rent_amt`, `availability`, `rating`) VALUES
('priya', 'and1', 'Tune of Ocean', 'Bailey Road', 'Andaman', 1200, 'Yes', '4.0'),
('nrk20', 'and2', 'Fables in Frost', 'Boring Road', 'Andaman', 1000, 'No', '4.2'),
('kumar', 'goa1', 'Beach Way Homestay', 'Nala Road', 'Goa', 1300, 'Yes', '4.4'),
('nrk20', 'goa2', 'Iris Stays', 'Beach Road', 'Goa', 1400, 'Yes', '3.8'),
('pk123', 'man1', 'Coffee House', 'Sector 63', 'Manali', 1000, 'No', '4.0'),
('rm02', 'man2', 'Pine Royale', 'Sector 58', 'Manali', 2200, 'Yes', '4.3'),
('sk15', 'sim1', 'The House of Mangoes', 'MG Road', 'Shimla', 1800, 'Yes', '4.5'),
('rm02', 'sim2', 'Fernweh Cottage', 'Area 51', 'Shimla', 800, 'No', '4.1');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(20) NOT NULL,
  `user_name` varchar(30) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `age` int(2) DEFAULT NULL,
  `gender` varchar(6) DEFAULT NULL,
  `phone_no` bigint(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `password`, `age`, `gender`, `phone_no`) VALUES
('ak420', 'Aakriti', '$2b$10$hFXy29kvGXiwTZQrbfspdenys6Fmy8xcRiPJ5/PhKTXD5G6faaXmG', 19, 'Female', 9008866231),
('ksh123', 'Khushi', '$2b$10$e2H4D6Di/tqbjQHLvJThS.js99K/JiQnDIQrBIaMf1TrMLusH5cb.', 18, 'Female', 8899000055),
('sumit17', 'Sumit Kushwaha', '$2b$10$g7TRMy6nVryONCZxVuXtt.zfu7fZjbWFnxLqInhyl26iyWLGVeXJC', 20, 'Male', 7782090024),
('suraj123', 'Suraj Chaudhary', '$2b$10$pJQrA2pHxX9643DwPYwv8eXRKfXNfDpvHP8ahkgT39BG9yJyFtI6O', 21, 'Male', 9878653400),
('yash', 'Yash Pathak', '$2b$10$uO0nV/CEj68Uk64YrIfr3.A1Y1FlShVHzpB9stg/qGTgOxUjk2v4C', 24, 'Male', 8976770011);

-- --------------------------------------------------------

--
-- Stand-in structure for view `user_view`
-- (See below for the actual view)
--
CREATE TABLE `user_view` (
`user_id` varchar(20)
,`password` varchar(128)
);

-- --------------------------------------------------------

--
-- Structure for view `host_view`
--
DROP TABLE IF EXISTS `host_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `host_view`  AS SELECT `hosts`.`host_id` AS `host_id`, `hosts`.`password` AS `password` FROM `hosts` ;

-- --------------------------------------------------------

--
-- Structure for view `user_view`
--
DROP TABLE IF EXISTS `user_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `user_view`  AS SELECT `users`.`user_id` AS `user_id`, `users`.`password` AS `password` FROM `users` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `property_id` (`property_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `hosts`
--
ALTER TABLE `hosts`
  ADD PRIMARY KEY (`host_id`);

--
-- Indexes for table `properties`
--
ALTER TABLE `properties`
  ADD PRIMARY KEY (`property_id`),
  ADD KEY `host_id` (`host_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`);

--
-- Constraints for table `properties`
--
ALTER TABLE `properties`
  ADD CONSTRAINT `properties_ibfk_1` FOREIGN KEY (`host_id`) REFERENCES `hosts` (`host_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
