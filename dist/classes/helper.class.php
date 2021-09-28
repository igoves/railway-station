<?php
/**
 *=====================================================
 * @author vvShop - by xfor.top
 *=====================================================
 **/
if (!defined('XFOR')) {
    die('Hacking attempt!');
}

class Helper
{
    private $db;

    public function __construct($db)
    {
        $this->db = $db;
    }


    public function getStations(): array
    {
        $data = [];
        $sql = $this->db->query("SELECT * FROM train_stations");
        while ($row = $this->db->get_row($sql)) {
            $data[$row['id']] = $row;
        }
        return $data;
    }

    public function getTrains(): array
    {
        $data = [];
        $sql = $this->db->query("SELECT * FROM trains");
        while ($row = $this->db->get_row($sql)) {
            $data[$row['id']] = $row;
        }
        return $data;
    }

    public function getWagonKlasses(): array
    {
        $data = [];
        $sql = $this->db->query("SELECT * FROM wagon_klasses");
        while ($row = $this->db->get_row($sql)) {
            $data[$row['id']] = $row;
        }
        return $data;
    }

    public function getWagonSeats(): array
    {
        $data = [];

        $sql = $this->db->query("SELECT * FROM wagon_seats");
        while ($row = $this->db->get_row($sql)) {
            $data[$row['wagon_id']][$row['id']] = $row;
        }

        // busy
        $sql = $this->db->query("SELECT * FROM tickets");
        while ($row = $this->db->get_row($sql)) {
            $data[$row['wagon_id']][$row['wagon_seat_id']]['busy'] = $row['created_at'];
        }

        return $data;
    }

    public function getTrainDirections(): array
    {
        $data = [];
        $sql = $this->db->query("SELECT * FROM train_directions");
        while ($row = $this->db->get_row($sql)) {
            $data[$row['id']] = $row;
        }
        return $data;
    }

    public function getWagons(): array
    {
        $data = [];
        $sql = $this->db->query("SELECT * FROM wagons");
        while ($row = $this->db->get_row($sql)) {
            $data[$row['id']] = $row;
        }
        return $data;
    }

    public function getTrainPaths(): array
    {
        $data = [];
        $sql = $this->db->query("SELECT * FROM train_paths");
        while ($row = $this->db->get_row($sql)) {
            $data[$row['id']] = $row;
        }
        return $data;
    }

    public function getCustomers(): array
    {
        $data = [];
        $sql = $this->db->query("SELECT * FROM customers");
        while ($row = $this->db->get_row($sql)) {
            $data[$row['id']] = $row;
        }
        return $data;
    }

    public function getTickets(): array
    {
        $data = [];
        $sql = $this->db->query("SELECT * FROM tickets");
        while ($row = $this->db->get_row($sql)) {
            $data[$row['id']] = $row;
        }
        return $data;
    }

    public function showDefaultData(): array
    {
        // Станции
        $data['stations'] = $this->getStations();

        // Пути
        $data['paths'] = $this->getTrainPaths();

        // Направления
        $data['directions'] = $this->getTrainDirections();

        // Поезда
        $data['trains'] = $this->getTrains();

        // Классы вагонов
        $data['wagon_klasses'] = $this->getWagonKlasses();

        // Места вагонов
        $data['wagon_seats'] = $this->getWagonSeats();

        // Билеты
        $data['tickets'] = $this->getTickets();

        // Вагоны
        $data['wagons'] = $this->getWagons();

        // Покупатели
        $data['customers'] = $this->getCustomers();

        return $data;
    }

    public function showSearchData($request): array
    {
        $city_from = $this->db->safesql($request['city_from']);
        $city_to = $this->db->safesql($request['city_to']);
        $departure_date = $this->db->safesql($request['departure_date']);
//        $departure_time = $this->db->safesql($request['departure_time']);


        $row = $this->db->super_query("
            SELECT id
            FROM train_stations
            WHERE name LIKE '%{$city_from}%'  
        ");
        $station_id_from = $row['id'];

        $row = $this->db->super_query("
            SELECT id
            FROM train_stations
            WHERE name LIKE '%{$city_to}%'  
        ");
        $station_id_to = $row['id'];

        if (empty($station_id_from) || empty($station_id_to)) {
            die('error');
        }

        if ($station_id_from === $station_id_to) {
            die('error');
        }

        $sql = $this->db->query("
            SELECT direction_id
            FROM train_paths
            WHERE 
                station_id IN  ($station_id_from, $station_id_to)
            HAVING COUNT(*) > 2;
        ");
        $direction_ids = [];
        while ($row = $this->db->get_row($sql)) {
            $direction_ids[] = $row['direction_id'];
        }

        $sql = $this->db->query("
            SELECT *
            FROM train_directions
            WHERE 
                id IN  (" . implode(',', $direction_ids) . ")
        ");
        $founded_trains = [];
        while ($row = $this->db->get_row($sql)) {

//            echo '<pre>';
//            print_r($row);
//            echo '</pre>';

            $transit_days = $row['transit_days'];
            $rest_days = $row['rest_days'];

            $now = strtotime($departure_date);
            $start_from = strtotime($row['start_from']);
            $datediff = $now - $start_from;
            $total_days = floor($datediff / (60 * 60 * 24)) + 1;
            $available = $total_days / ($transit_days + $rest_days);
//            echo $available.'<br/>';
            if ( filter_var($available, FILTER_VALIDATE_INT) === false ) {
                // not founded
            } else {
                // founded
                $founded_trains[] = $row['train_id'];
            }

        }


//        print_r($founded_trains);
//        die();


        // Станции
        $data['stations'] = $this->getStations();

        // Пути
        $data['paths'] = $this->getTrainPaths();

        $paths = [];
        $i = 0;
        foreach ($data['paths'] as $row) {
            $paths[$row['direction_id']][$i]['id'] = $row['id'];
            $paths[$row['direction_id']][$i]['station_id'] = $row['station_id'];
            $paths[$row['direction_id']][$i]['station_name'] = $data['stations'][$row['station_id']];
            $paths[$row['direction_id']][$i]['direction_id'] = $row['direction_id'];
            $paths[$row['direction_id']][$i]['arriaval_time'] = !empty($row['arriaval_time']) ? date('H:i',
                strtotime($row['arriaval_time'])) : '';
            $paths[$row['direction_id']][$i]['departure_time'] = !empty($row['departure_time']) ? date('H:i',
                strtotime($row['departure_time'])) : '';
            $i++;
        }

        // Направления
        $data['directions'] = $this->getTrainDirections();

        $directions = [];
        foreach ($data['directions'] as $row) {
            $directions[$row['train_id']]['direction_id'] = $row['id'];
            $directions[$row['train_id']]['station_id_departure'] = $row['station_id_departure'];
            $directions[$row['train_id']]['station_name_departure'] = $data['stations'][$row['station_id_departure']];
            $directions[$row['train_id']]['station_id_arrival'] = $row['station_id_arrival'];
            $directions[$row['train_id']]['station_name_arrival'] = $data['stations'][$row['station_id_arrival']];
            $directions[$row['train_id']]['train_id'] = $row['train_id'];
            $directions[$row['train_id']]['stations'] = $paths[$row['id']];
        }

        // Поезда
        $data['trains'] = $this->getTrains();

        foreach ($data['trains'] as $row) {
            if (in_array($row['id'], $founded_trains)) {
                $data['search_trains'][$row['id']]['name'] = $row['name'];
                $data['search_trains'][$row['id']]['direction'] = $directions[$row['id']];
            }
        }

//        print_r($data['search_trains']);
//        die();

        // Классы вагонов
        $data['wagon_klasses'] = $this->getWagonKlasses();

        // Места вагонов
        $data['wagon_seats'] = $this->getWagonSeats();

        // Билеты
        $data['tickets'] = $this->getTickets();

        // Вагоны
        $data['wagons'] = $this->getWagons();

        foreach ($data['wagons'] as $row) {
            if (in_array($row['train_id'], $founded_trains)) {
                $data['search_trains'][$row['train_id']]['wagons'][$row['id']]['id'] = $row['id'];
                $data['search_trains'][$row['train_id']]['wagons'][$row['id']]['name'] = $row['name'];
                $data['search_trains'][$row['train_id']]['wagons'][$row['id']]['wagon_klass'] = $data['wagon_klasses'][$row['wagon_klass_id']];
                $data['search_trains'][$row['train_id']]['wagons'][$row['id']]['status'] = $row['status'];
                $data['search_trains'][$row['train_id']]['wagons'][$row['id']]['seats'] = $data['wagon_seats'][$row['id']];
            }
        }

        // Покупатели
        $data['customers'] = $this->getCustomers();



        return $data;
    }

    public function addOrder($data)
    {
        $login = $this->db->safesql($data['fields']['login']);
        $password = md5(md5($data['fields']['password']));
        $first_name = $this->db->safesql($data['fields']['first_name']);
        $last_name = $this->db->safesql($data['fields']['last_name']);
        $passport = $this->db->safesql($data['fields']['passport']);

        $this->db->query("
            INSERT INTO customers
            SET
                login = '$login',
                `password` = '$password',
                first_name = '$first_name',
                last_name = '$last_name',
                passport = '$passport'
        ");
        $customer_id = $this->db->insert_id();

        foreach ($data['cart'] as $value) {

            $seat_id = (int)$value['seat_id'];
            if ($seat_id === 0) {
                die('error');
            }

            $wagon_id = (int)$value['wagon_id'];
            if ($wagon_id === 0) {
                die('error');
            }

            $row = $this->db->super_query("
                SELECT
                    a.id as seat_id,
                    b.id as klass_id,
                    c.id as train_id,
                    d.id as wagon_id,
                    e.id as direction_id   
                FROM 
                     wagon_seats as a,
                     wagon_klasses as b,
                     trains as c,
                     wagons as d,
                     train_directions as e
                WHERE
                    (a.id = $seat_id AND
                    a.wagon_id = $wagon_id AND 
                    a.status = 1) AND
                    d.wagon_klass_id = b.id AND
                    d.id = a.wagon_id AND
                    d.train_id = c.id AND
                    e.train_id = c.id
            ");

            $this->db->query("
                INSERT INTO tickets
                SET
                    train_id = {$row['train_id']},
                    wagon_id = {$row['wagon_id']},
                    wagon_klass_id = {$row['klass_id']},
                    wagon_seat_id = {$row['seat_id']},
                    train_direction_id = {$row['direction_id']},
                    customer_id = $customer_id,
                    created_at = NOW()
            ");

        }

        echo '<pre>';
        print_r($data);
        echo '</pre>';
        die();
    }

    public static function getRequest()
    {
        return json_decode(file_get_contents('php://input'), true);
    }

}

$helper = new Helper($db);
