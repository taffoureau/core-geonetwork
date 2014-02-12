# Usage: ./mongeosource-migration.sh www-data db_1044

function showUsage
{
  echo -e "\nThis script is used to migrate mongeosource from 2.7.3 to 2.11.0"
  echo -e "Usage: ./`basename $0 $1` username database"
}

if [ $# -lt 2 ]
then
  showUsage
  exit
fi

if [ "$1" = "-h" ]
then
        showUsage
        exit
fi

psql -U $1 -f run.sql $2 -L log-$2-query.log -o log-$2.log


