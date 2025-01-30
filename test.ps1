$list = dir
get-itemProperty $list | format-list | out-file fileinfo.txt
