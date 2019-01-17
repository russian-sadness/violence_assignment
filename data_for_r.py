import json
import csv
# Types of conflict
#1: state-based conflict
#2: non-state conflict
#3: one-sided violence


# Create an empty list., read .json file., create a list of lists for Chechnya, each list containing all the necessary info for one row
chechnya_list = []
with open('chechnya.json', 'r') as file:
    chechnya = json.load(file)
    for line in chechnya:
        list1 = [int(line['year']), line['side_a'], line['side_b'], line['type_of_violence'], line['best'], line['deaths_civilians'], line['latitude'], line['longitude']]
        chechnya_list.append(list1)

# Open a new CSV file, create cvs.writer(), loop through lists in chechnya_list and use writerow() to write them as new lines to file, one by one

with open('chechnya.csv', 'w', newline = '') as file:
    filewriter = csv.writer(file)
        # header
    filewriter.writerow(['year', 'side_a', 'side_b', 'type_of_violence', 'best', 'deaths_civilians', 'latitude', 'longitude'])
    for line in chechnya_list:
        filewriter.writerow(line)