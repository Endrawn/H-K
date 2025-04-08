-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Gép: localhost:3306
-- Létrehozás ideje: 2025. Ápr 08. 11:46
-- Kiszolgáló verziója: 5.7.24
-- PHP verzió: 8.3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `kedd`
--

DELIMITER $$
--
-- Eljárások
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTermekById` (IN `id` INT)   BEGIN
    SELECT * FROM termek WHERE termek_id = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetVasarlasFizetesModAlapjan` (IN `fizmod` ENUM("Készpénz","Bankkártya"))   BEGIN
    SELECT * FROM vasarlas WHERE fizetesmod = fizmod;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetVasarloByEmail` (IN `emailCim` VARCHAR(150))   BEGIN
    SELECT * FROM vasarlo WHERE email = emailCim;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetVasarloSzamaByVaros` (IN `varosNev` VARCHAR(50))   BEGIN
    SELECT COUNT(*) FROM vasarlo WHERE varos = varosNev;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SetTermekAr` (IN `termekNev` VARCHAR(100), IN `ujAr` INT)   BEGIN
    UPDATE termek SET ar = ujAr WHERE nev = termekNev;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UjTermek` (IN `beAr` INT, IN `beLejarat` DATE, IN `beMennyiseg` TINYINT, IN `beGyarto` VARCHAR(100), IN `beNev` VARCHAR(100), IN `beKategoria` ENUM("Élelmiszer","Háztartás"))   BEGIN
    INSERT INTO termek (ar, lejarat_datum, mennyiseg, gyarto, nev, kategoria)
    VALUES (beAr, beLejarat, beMennyiseg, beGyarto, beNev, beKategoria);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `termek`
--

CREATE TABLE `termek` (
  `termek_id` int(11) NOT NULL,
  `nev` varchar(100) NOT NULL,
  `ar` int(11) NOT NULL,
  `lejarat_datum` date NOT NULL,
  `mennyiseg` tinyint(4) NOT NULL,
  `gyarto` varchar(100) NOT NULL,
  `kategoria` enum('Élelmiszer','Háztartás') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `vasarlas`
--

CREATE TABLE `vasarlas` (
  `vasarlas_id` int(11) NOT NULL,
  `vasarlo_id` int(11) DEFAULT NULL,
  `termek_id` int(11) DEFAULT NULL,
  `fizetesmod` enum('Készpénz','Bankkártya') NOT NULL,
  `fizetoeszkoz` enum('Készpénz','Bankkártya','Mobilfizetés') NOT NULL,
  `vasarlas_osszeg` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `vasarlo`
--

CREATE TABLE `vasarlo` (
  `vasarlo_id` int(11) NOT NULL,
  `nev` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `varos` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `vasarlo`
--

INSERT INTO `vasarlo` (`vasarlo_id`, `nev`, `email`, `varos`) VALUES
(1, 'Kiss Péter', 'kiss.peter@gmail.com', 'Budapest'),
(2, 'Nagy Anna', 'nagy.anna@gmail.com', 'Debrecen'),
(3, 'Tóth Gábor', 'toth.gabor@gmail.com', 'Szeged'),
(4, 'Szabó Éva', 'szabo.eva@gmail.com', 'Pécs'),
(5, 'Varga László', 'varga.laszlo@gmail.com', 'Győr'),
(6, 'Kovács Zsuzsanna', 'kovacs.zsuzsanna@gmail.com', 'Miskolc'),
(7, 'Farkas István', 'farkas.istvan@gmail.com', 'Nyíregyháza'),
(8, 'Balogh Katalin', 'balogh.katalin@gmail.com', 'Kecskemét'),
(9, 'Molnár János', 'molnar.janos@gmail.com', 'Szombathely'),
(10, 'Papp Mária', 'papp.maria@gmail.com', 'Eger');

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `termek`
--
ALTER TABLE `termek`
  ADD PRIMARY KEY (`termek_id`),
  ADD KEY `idx_nev` (`nev`);

--
-- A tábla indexei `vasarlas`
--
ALTER TABLE `vasarlas`
  ADD PRIMARY KEY (`vasarlas_id`),
  ADD KEY `vasarlo_id` (`vasarlo_id`),
  ADD KEY `termek_id` (`termek_id`),
  ADD KEY `idx_fizetesmod` (`fizetesmod`);

--
-- A tábla indexei `vasarlo`
--
ALTER TABLE `vasarlo`
  ADD PRIMARY KEY (`vasarlo_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `termek`
--
ALTER TABLE `termek`
  MODIFY `termek_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT a táblához `vasarlas`
--
ALTER TABLE `vasarlas`
  MODIFY `vasarlas_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT a táblához `vasarlo`
--
ALTER TABLE `vasarlo`
  MODIFY `vasarlo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `vasarlas`
--
ALTER TABLE `vasarlas`
  ADD CONSTRAINT `vasarlas_ibfk_1` FOREIGN KEY (`vasarlo_id`) REFERENCES `vasarlo` (`vasarlo_id`),
  ADD CONSTRAINT `vasarlas_ibfk_2` FOREIGN KEY (`termek_id`) REFERENCES `termek` (`termek_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
