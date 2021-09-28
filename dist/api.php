<?php
error_reporting(E_ALL);
ini_set('display_errors', true);
ini_set('html_errors', true);

const XFOR = true;
const ROOT_DIR = __DIR__;
const CLASSES_DIR = ROOT_DIR . '/classes/';
const CONFIG_DIR = ROOT_DIR . '/config/';

require_once CLASSES_DIR . 'mysql.class.php';
if (!file_exists(CONFIG_DIR . 'dbconfig.php')) {
    die('Error: db config not exist, fon install /_install/go.php');
}

require_once CONFIG_DIR . 'dbconfig.php';
require_once CLASSES_DIR . 'helper.class.php';

date_default_timezone_set('Europe/Moscow');

$api = Helper::getRequest();

// PRODUCTION
@error_reporting(E_ALL & ~E_WARNING & ~E_DEPRECATED & ~E_NOTICE);
@ini_set('display_errors', false);
@ini_set('html_errors', false);

$data = [];

switch ($api['api']) {
    case 'order':
        $helper->addOrder($api);
        break;
    case 'search':
        $data = $helper->showSearchData($api['data']);
        break;
    default:
        $data = $helper->showDefaultData();
}


echo json_encode($data, JSON_THROW_ON_ERROR);
die();

// echo '<pre>';
// print_r($data);
// echo '</pre>';
// die();