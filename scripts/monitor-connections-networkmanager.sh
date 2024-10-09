
#!/bin/bash

while read line; do
    echo $line;
    echo "----"
    
    notify-send 'NetworkManager' -c network "$line"
done < <(nmcli monitor)
