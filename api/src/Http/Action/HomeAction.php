<?php

declare(strict_types=1);

namespace App\Http\Action;

use App\JsonResponse;
use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;

class HomeAction implements RequestHandlerInterface
{
    public function handle(ServerRequestInterface $request): ResponseInterface {
        return new JsonResponse(new \stdClass());
    }
}