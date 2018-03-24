<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class DropDatabase extends Command {
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'db:drop';

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
            $test = $db->exec("DROP DATABASE \"$dbname\";");
            if ($test === false)
                throw new \Exception($db->errorInfo()[2]);
            $this->info(sprintf('Successfully dropped %s database', $dbname));
        }
        catch (\Exception $exception) {
            $this->error(sprintf('Failed to dropped %s database: %s', $dbname, $exception->getMessage()));
        }
    }
}