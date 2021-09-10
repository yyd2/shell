#!/usr/bin/env bash
function ssh{

host=~/host
for i in `cat ${host}`
do
  ssh-keyscan $i >> ~/.ssh/known_hosts
  ssh-copy-id $i
done

}
host
