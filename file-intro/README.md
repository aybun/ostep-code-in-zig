
# How to run

Read the original file for details.

prompt> truncate -s 4096 ps.img
prompt> make pstack

prompt> ./pstack 7 13 47 pop
47
prompt> ./pstack pop pop 99
13
7
prompt> ./pstack pop
99


# How to clean 
prompt> make clean
