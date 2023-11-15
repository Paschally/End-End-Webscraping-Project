# End-End-Webscraping-Project
Webscraping Project + Database Normalization + Visualization

This project starts with webscraping of rotten tomatoes 140 Action Movies using Python.
The webscraped data was converted to a dataframe using pandas library and exported as csv file.
Then in MySQL, a new database and table were created before importing the data.
In the dataset, each the column,'cast' contains multiple actors.
We will write a query to split the cast column into 4 columns for each actor
A new table will be created for the actors such that each actor will have separate record.
This was to ensure Database Normalization (second order).
Then visualization was carried out using Power BI.
