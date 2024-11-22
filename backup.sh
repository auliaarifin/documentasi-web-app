#!/bin/bash
DATE=$(date +%Y-%m-%d)
BACKUP_DIR="/home/auliaarifin89/backup"
SOURCE="/var/www/laravel-starter"
GS_URI="gs://laravel-starter/backup-laravel-starter"
RETENTION_DAYS=7

echo "====>> Backup Datavase <===="
mysqldump -u laravel -p --verbose laravel_starter > $BACKUP_DIR/database/$DATE-laravel_starter.sql

sleep 2

echo "====> Source Code Backup <===="
tar -cvf $BACKUP_DIR/source-code/$DATE-larvel-starter.tar.gz $SOURCE

sleep 3

echo "====> Upload to Google Cloud Storage <===="
echo "====> DATABASE <===="
gsutil cp $BACKUP_DIR/database/$DATE-laravel_starter.sql $GS_URI/database

sleep 3 
echo "====> Source code <===="
gsutil cp $BACKUP_DIR/source-code/$DATE-larvel-starter.tar.gz $GS_URI/source-code

#Cleanup local backup
echo "====>>Clean up local directory database<<===="
find $BACKUP_DIR/database -type f -name "$DATE-laravel_starter*" -mtime +$RETENTION_DAYS -exec rm {} \;

echo "====>>Clean up local directory source-code<<===="
find $BACKUP_DIR/source-code -type f -name "$DATE-laravel_starter*" -mtime +$RETENTION_DAYS -exec rm {} \;

echo "Backup completed and uploaded to GCS. Local backups older than $RETENTION_DAYS days are deleted."
