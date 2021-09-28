USE `test`;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;



--
-- База данных: `test`
--

-- --------------------------------------------------------

--
-- Структура таблицы `customers`
--

CREATE TABLE `customers` (
  `id` tinyint(4) NOT NULL,
  `login` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `passport` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `customers`
--

INSERT INTO `customers` (`id`, `login`, `password`, `first_name`, `last_name`, `passport`) VALUES
(1, '1', '5', '3', '4', '5');

-- --------------------------------------------------------

--
-- Структура таблицы `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `train_id` tinyint(4) NOT NULL,
  `wagon_id` tinyint(4) NOT NULL,
  `wagon_klass_id` tinyint(4) NOT NULL,
  `wagon_seat_id` tinyint(4) NOT NULL,
  `train_direction_id` tinyint(4) NOT NULL,
  `customer_id` tinyint(4) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `tickets`
--

INSERT INTO `tickets` (`id`, `train_id`, `wagon_id`, `wagon_klass_id`, `wagon_seat_id`, `train_direction_id`, `customer_id`, `created_at`) VALUES
(1, 1, 3, 1, 2, 1, 1, '2021-09-28 13:14:36');

-- --------------------------------------------------------

--
-- Структура таблицы `trains`
--

CREATE TABLE `trains` (
  `id` tinyint(4) NOT NULL,
  `name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `trains`
--

INSERT INTO `trains` (`id`, `name`) VALUES
(1, '763 D'),
(2, '145 K');

-- --------------------------------------------------------

--
-- Структура таблицы `train_directions`
--

CREATE TABLE `train_directions` (
  `id` tinyint(4) NOT NULL,
  `station_id_departure` tinyint(4) NOT NULL,
  `station_id_arrival` tinyint(4) NOT NULL,
  `train_id` tinyint(4) NOT NULL,
  `transit_days` tinyint(4) NOT NULL,
  `rest_days` tinyint(4) NOT NULL,
  `start_from` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `train_directions`
--

INSERT INTO `train_directions` (`id`, `station_id_departure`, `station_id_arrival`, `train_id`, `transit_days`, `rest_days`, `start_from`) VALUES
(1, 1, 3, 1, 3, 2, '2021-01-01'),
(2, 3, 4, 2, 1, 1, '2021-07-01');

-- --------------------------------------------------------

--
-- Структура таблицы `train_paths`
--

CREATE TABLE `train_paths` (
  `id` tinyint(4) NOT NULL,
  `station_id` tinyint(4) NOT NULL,
  `direction_id` tinyint(4) NOT NULL,
  `arriaval_time` time DEFAULT NULL,
  `departure_time` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `train_paths`
--

INSERT INTO `train_paths` (`id`, `station_id`, `direction_id`, `arriaval_time`, `departure_time`) VALUES
(1, 1, 1, NULL, '16:30:00'),
(2, 2, 1, '17:25:00', '17:30:00'),
(3, 3, 1, '23:20:00', NULL),
(4, 3, 2, NULL, '16:30:00'),
(5, 4, 2, '17:25:00', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `train_stations`
--

CREATE TABLE `train_stations` (
  `id` tinyint(4) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `train_stations`
--

INSERT INTO `train_stations` (`id`, `name`) VALUES
(1, 'Kyiv'),
(2, 'Vinnica'),
(3, 'Jmerinka'),
(4, 'Odessa');

-- --------------------------------------------------------

--
-- Структура таблицы `wagons`
--

CREATE TABLE `wagons` (
  `id` tinyint(4) NOT NULL,
  `name` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `train_id` tinyint(4) NOT NULL,
  `wagon_klass_id` tinyint(4) NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `wagons`
--

INSERT INTO `wagons` (`id`, `name`, `train_id`, `wagon_klass_id`, `status`) VALUES
(1, '4', 1, 1, 1),
(3, '5', 1, 1, 1),
(4, '6', 1, 2, 1),
(5, '1', 2, 2, 1),
(6, '2', 2, 2, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `wagon_klasses`
--

CREATE TABLE `wagon_klasses` (
  `id` tinyint(4) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seats` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `wagon_klasses`
--

INSERT INTO `wagon_klasses` (`id`, `name`, `seats`) VALUES
(1, 'Cupe', 1),
(2, 'Reserved Seat', 2),
(3, 'Sedentary class 1', 3),
(4, 'Sedentary class 2', 4);

-- --------------------------------------------------------

--
-- Структура таблицы `wagon_seats`
--

CREATE TABLE `wagon_seats` (
  `id` tinyint(4) NOT NULL,
  `name` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `wagon_id` tinyint(4) NOT NULL,
  `type` tinyint(1) NOT NULL,
  `price` decimal(10,0) NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `wagon_seats`
--

INSERT INTO `wagon_seats` (`id`, `name`, `wagon_id`, `type`, `price`, `status`) VALUES
(1, '1', 1, 1, '100', 1),
(2, '1', 3, 1, '100', 1),
(3, '1', 4, 1, '100', 1),
(4, '2', 4, 1, '100', 1),
(5, '1', 5, 1, '100', 1),
(6, '2', 5, 1, '100', 1),
(7, '3', 5, 1, '100', 1),
(8, '4', 5, 1, '100', 1),
(9, '1', 6, 1, '100', 1),
(10, '2', 6, 1, '100', 1);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `train_id` (`train_id`),
  ADD KEY `wagon_id` (`wagon_id`),
  ADD KEY `wagon_klass_id` (`wagon_klass_id`),
  ADD KEY `tickets_ibfk_1` (`customer_id`),
  ADD KEY `train_direction_id` (`train_direction_id`),
  ADD KEY `wagon_seat_id` (`wagon_seat_id`);

--
-- Индексы таблицы `trains`
--
ALTER TABLE `trains`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `train_directions`
--
ALTER TABLE `train_directions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `train_id` (`train_id`),
  ADD KEY `station_id_arrival` (`station_id_arrival`),
  ADD KEY `station_id_departure` (`station_id_departure`);

--
-- Индексы таблицы `train_paths`
--
ALTER TABLE `train_paths`
  ADD PRIMARY KEY (`id`),
  ADD KEY `direction_id` (`direction_id`),
  ADD KEY `station_id` (`station_id`);

--
-- Индексы таблицы `train_stations`
--
ALTER TABLE `train_stations`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `wagons`
--
ALTER TABLE `wagons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `train_id` (`train_id`),
  ADD KEY `wagon_klass_id` (`wagon_klass_id`);

--
-- Индексы таблицы `wagon_klasses`
--
ALTER TABLE `wagon_klasses`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `wagon_seats`
--
ALTER TABLE `wagon_seats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `wagon_id` (`wagon_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `customers`
--
ALTER TABLE `customers`
  MODIFY `id` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `trains`
--
ALTER TABLE `trains`
  MODIFY `id` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `train_directions`
--
ALTER TABLE `train_directions`
  MODIFY `id` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `train_paths`
--
ALTER TABLE `train_paths`
  MODIFY `id` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `train_stations`
--
ALTER TABLE `train_stations`
  MODIFY `id` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `wagons`
--
ALTER TABLE `wagons`
  MODIFY `id` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `wagon_klasses`
--
ALTER TABLE `wagon_klasses`
  MODIFY `id` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `wagon_seats`
--
ALTER TABLE `wagon_seats`
  MODIFY `id` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `tickets_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  ADD CONSTRAINT `tickets_ibfk_2` FOREIGN KEY (`train_id`) REFERENCES `trains` (`id`),
  ADD CONSTRAINT `tickets_ibfk_3` FOREIGN KEY (`wagon_id`) REFERENCES `wagons` (`id`),
  ADD CONSTRAINT `tickets_ibfk_4` FOREIGN KEY (`wagon_klass_id`) REFERENCES `wagons` (`id`),
  ADD CONSTRAINT `tickets_ibfk_5` FOREIGN KEY (`train_direction_id`) REFERENCES `train_directions` (`id`),
  ADD CONSTRAINT `tickets_ibfk_6` FOREIGN KEY (`wagon_seat_id`) REFERENCES `wagon_seats` (`id`);

--
-- Ограничения внешнего ключа таблицы `train_directions`
--
ALTER TABLE `train_directions`
  ADD CONSTRAINT `train_directions_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `trains` (`id`),
  ADD CONSTRAINT `train_directions_ibfk_2` FOREIGN KEY (`station_id_arrival`) REFERENCES `train_stations` (`id`),
  ADD CONSTRAINT `train_directions_ibfk_3` FOREIGN KEY (`station_id_departure`) REFERENCES `train_stations` (`id`);

--
-- Ограничения внешнего ключа таблицы `train_paths`
--
ALTER TABLE `train_paths`
  ADD CONSTRAINT `train_paths_ibfk_1` FOREIGN KEY (`direction_id`) REFERENCES `train_directions` (`id`),
  ADD CONSTRAINT `train_paths_ibfk_2` FOREIGN KEY (`station_id`) REFERENCES `train_stations` (`id`);

--
-- Ограничения внешнего ключа таблицы `wagons`
--
ALTER TABLE `wagons`
  ADD CONSTRAINT `wagons_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `trains` (`id`),
  ADD CONSTRAINT `wagons_ibfk_2` FOREIGN KEY (`wagon_klass_id`) REFERENCES `wagon_klasses` (`id`);

--
-- Ограничения внешнего ключа таблицы `wagon_seats`
--
ALTER TABLE `wagon_seats`
  ADD CONSTRAINT `wagon_seats_ibfk_1` FOREIGN KEY (`wagon_id`) REFERENCES `wagons` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
