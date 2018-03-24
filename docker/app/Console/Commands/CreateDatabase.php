<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class CreateDatabase extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'db:create';

    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'db:create';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Create database for app';

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle() {
        $dbhost = env('DB_HOST');
        $dbname = env('DB_DATABASE');
        $dbuser = env('DB_USERNAME');
        $dbpass = env('DB_PASSWORD');
        try {
            $db = new \PDO("pgsql:host=$dbhost", $dbuser, $dbpass);
            $test = $db->exec("CREATE DATABASE \"$dbname\" WITH TEMPLATE = template0 encoding = 'UTF8' lc_collate='C.UTF-8' lc_ctype='C.UTF-8';");
            if ($test === false)
                throw new \Exception($db->errorInfo()[2]);
            $this->info(sprintf('Successfully created %s database', $dbname));
        }
        catch (\Exception $exception) {
            $this->error(sprintf('Failed to create %s database: %s', $dbname, $exception->getMessage()));
        }
    }
}