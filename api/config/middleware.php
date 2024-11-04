<?php

declare(strict_types=1);

return static function (\Slim\App $app, \Psr\Container\ContainerInterface $container): void {
    $app->addErrorMiddleware($container->get('config')['debug'], true, true);
};