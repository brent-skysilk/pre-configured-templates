#show contents of creds file to user
cat /root/creds.txt

#remove self from showing after login
ex -snc '$-0,$d|x' /root/.bashrc

#remove self
rm  -- "$0"  
