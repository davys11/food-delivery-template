<?php

declare(strict_types=1);

namespace App\Console;

class HelloCommand extends \Symfony\Component\Console\Command\Command
{
    protected function configure()
    {
        $this->setName('hello')->setDescription('Hello Command');
    }

    protected function execute(\Symfony\Component\Console\Input\InputInterface $input, \Symfony\Component\Console\Output\OutputInterface $output): int
    {
        $output->writeln('<info>Hello There</info>');

        return 0;
    }
}