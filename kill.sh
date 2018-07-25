#!/bin/bash

# 대상이  데몬 / 실행자
process_target='httpd'
user_name='__PUT_TARGET_USER___'

# 유저 mustit_web으로 실행되었으며, 프로세스 명에 httpd가 포함되어있는 리스트
process_list=`ps -f -u $user_name | grep $process_target | awk '{print $2}'`
process_array=($process_list)

for p_id in ${process_array[@]}
do
	# 해당 프로세스의 실행 시간을 추출한다.
	p_time=`ps -p $p_id | awk '{print $3}'`
	p_time_length=`echo $p_time | wc -w`

	# 프로세스가 실행중이라면...
	if [ $p_time_length = '2' ] ; then
		p_time_array=($p_time)
		p_time_real=${p_time_array[1]}
		
		# 문자열 ":"를 공백으로 치환
		p_time_real_replace=`echo $p_time_real | sed 's/://g'`
		
		# 실행중인 프로세스의 실행 시간이 15분 이상이라면 kill
		# 00 00 00
		# 시 분 초
		# ex. 010000 = 1시간.
		# ex2. 003500 = 35분.
		if [ $p_time_real_replace -ge '001500' ]; then
			echo $p_id $p_time_real_replace
			`kill -9 $p_id`
		fi
	fi
done
