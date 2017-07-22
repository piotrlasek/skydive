NYTC_PATH="https://s3.amazonaws.com/nyc-tlc/trip+data"
NYTC_HOME="~/nytc"

for year in {2009..2014}
do
  for month in {01..12}
  do
      fyt="yellow_tripdata_"$year-$month".csv"
      echo "==============================================================="
      echo "Downloading file: "$fyt
      echo "==============================================================="
      wget $NYTC_PATH/$fyt -P $NYTC_HOME
      echo "Changing format..."
      sed '1d' $NYTC_HOME/$fyt > $NYTC_HOME/"yt_"$year"-"$month".csv" # yt_2009-10.csv
  done
done
