# What the code does?

-It writes the input ad data to the csv file by sorting it according to click numbers first.

-The csv file is read from the data and the values corresponding to the header values are kept in a “Hash” with the help of “combine_hash” function

-After the process is finished, the processed data is added to the file again.

-If the number of lines is greater than LINES_PER_FILE, the output is #filename_index as multiple files.

