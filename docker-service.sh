#!/bin/bash
num=$#
date=`date +%Y-%m-%d_%H:%M`
container_id=`docker ps --format {{.ID}}`
orderer=`docker ps -q -a --no-trunc --filter name=^orderer.*`
if [ $# -lt 1 ]
then
    echo "At least one parameter"
    exit 1 
else
    for name in  ${@:2}
	do 
	case $1 in
		start)
		  docker start ${name}
	          if [ $? -ne 0]
		  then
		      echo "start ${name} failed"	
	 	  fi
		;;
		stop)
		  docker stop ${name} &>> docker-stop.${date}.log
		;;
		restart)
		  docker restart ${name} &>> docker-restart.${date}.log
		  if [ $? -ne 0 ]
		  then
		    echo “restart ${name} failed”
			exit 1
		  fi
		;;
		status)
		 #docker ps |grep ${name}
		 docker inspect --format "状态:{{.State.Status}}" ${name} 
		 docker inspect --format "已绑定端口列表:{{println}}{{range \$p,\$conf := .NetworkSettings.Ports}}{{\$p}} -> {{(index \$conf 0).HostPort}}{{println}}{{end}}" ${name}
		 docker inspect -f 'ip:{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${name}
		;;
		down)
		docker-compose -f docker-compose_${name}.yml down
		;;
		up)
		docker-compose -f docker-compose_${name}.yml up
		;;
	esac
	done

	for ID in $orderer
	do
	case $1 in
		start-all)
		docker start ${ID}
		;;
		restart-all)
		docker restart ${ID}
		;;
		stop-all)
		docker stop ${ID}
		;;
	esac
	done
	
fi
