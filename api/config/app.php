<?php

declare(strict_types=1);

return static function (\Psr\Container\ContainerInterface $container) {
    $app = \Slim\Factory\AppFactory::createFromContainer($container);
    (require __DIR__ . '/../config/middleware.php')($app, $container);
    (require __DIR__ . '/../config/routes.php')($app);
    return $app;

};