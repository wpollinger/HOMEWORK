import os
import csv



# Set path for file
csvpath = os.path.join(".", "Resources", "election_data.csv")

# Declare Variables
total = 0
khan = 0
correy = 0
li = 0
otooley = 0

# Open csv in default read mode with context manager
with open(csvpath) as elections:

    # Store data under the csvreader variable
    csvreader = csv.reader(elections,delimiter=",")

    # Skip the header so we iterate through the actual values
    header = next(csvreader)

    # Iterate through each row in the csv
    for row in csvreader:

        # Count the unique Voter ID's and store in variable  called total_votes
        total +=1

        # We have four candidates if the name is found, count the times it appears and store in a list
        # We can use this values in our percent vote calculation in the print statements
        if row[2] == "Khan":
            khan +=1
        elif row[2] == "Correy":
            correy +=1
        elif row[2] == "Li":
            li +=1
        elif row[2] == "O'Tooley":
            otooley +=1

 # To find the winner we want to make a dictionary out of the two lists we previously created
candidates = ["Khan", "Correy", "Li","O'Tooley"]
votes = [khan, correy,li,otooley]

# We zip them together the list of candidate(key) and the total votes(value)
# Return the winner using a max function of the dictionary
dict_candidates_and_votes = dict(zip(candidates,votes))
key = max(dict_candidates_and_votes, key=dict_candidates_and_votes.get)

# Print a the summary of the analysis
khan_percent = (khan/total) *100
correy_percent = (correy/total) * 100
li_percent = (li/total)* 100
otooley_percent = (otooley/total) * 100

# Print the summary table
print(f"Election Results")
print(f"----------------------------")
print(f"Total Votes: {total}")
print(f"----------------------------")
print(f"Khan: {khan_percent:.3f}% ({khan})")
print(f"Correy: {correy_percent:.3f}% ({correy})")
print(f"Li: {li_percent:.3f}% ({li})")
print(f"O'Tooley: {otooley_percent:.3f}% ({correy})")
print(f"----------------------------")
print(f"Winner: {key}")
print(f"----------------------------")

# Output files
# Assign output file location and with the pathlib library
output_file = os.path.join(".", "Resources", "election.txt")

with open(output_file,"w") as file:

# Write methods to print to Elections_Results_Summary
    file.write(f"Election Results")
    file.write("\n")
    file.write(f"----------------------------")
    file.write("\n")
    file.write(f"Total Votes: {total}")
    file.write("\n")
    file.write(f"----------------------------")
    file.write("\n")
    file.write(f"Khan: {khan_percent:.3f}% ({khan})")
    file.write("\n")
    file.write(f"Correy: {correy_percent:.3f}% ({correy})")
    file.write("\n")
    file.write(f"Li: {li_percent:.3f}% ({li})")
    file.write("\n")
    file.write(f"O'Tooley: {otooley_percent:.3f}% ({otooley})")
    file.write("\n")
    file.write(f"----------------------------")
    file.write("\n")
    file.write(f"Winner: {key}")
    file.write("\n")
    file.write(f"----------------------------")


