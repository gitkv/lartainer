#!/bin/sh

cd /var/www/app

# Install dependencies
composer install --no-interaction
npm install && npm run build

# Change permissions
chmod -R 777 /var/www/app/storage/logs/
chown -R www /var/www/app/storage/upload/
chown -R www /var/www/app/public/upload/
chmod -R 660 /var/www/app/storage/upload/
chmod -R 660 /var/www/app/public/upload/

# Clear the log
rm /var/www/app/storage/logs/lumen.log

# Clear the cache
chmod 777 /var/www/app/storage/cache/*
php artisan cache:clear --no-interaction

# Create database
php artisan db:create

# Run migrations
if [ "$APP_ENV" = "production" ]; then
    php artisan migrate --force --no-interaction;
else
    php artisan migrate:refresh --seed --no-interaction;
fi

echo "Service complete"

cd ~

# Run entrypoint
exec "$@"