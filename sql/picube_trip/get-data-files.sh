NYTC_PATH="https://s3.amazonaws.com/nyc-tlc/trip+data"
NYTC_HOME="~/nytc/data"

for year in {2009..2015}
do
  for month in {01..12}
  do
      fyt="yellow_tripdata_"$year-$month".csv"
      echo "==============================================================="
      echo "Downloading file: "$fyt
      echo "==============================================================="
      wget $NYTC_PATH/$fyt -P $NYTC_HOME
      echo "Changing format..."
      sed '1d' $NYTC_HOME/$fyt > "yt_"$year"-"$month".csv" # yt_2009-10.csv
  done
done
