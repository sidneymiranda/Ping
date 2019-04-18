#!/bin/bash
hora=`date +%d-%m-%Y\ %H:%M:%S`

host="4.125.196.94" # ip Google 74.125.196.94, retirei o 7 apenas para gerar o erro na consulta
roteador="192.168.1.1"
PING="ping -c 1 $host"
CONECTADO="ping -c 1 $roteador"
email="felipe.torres@unifacs.br"

cd /home/sidney/desafios/desafio-02/

if $PING; then
   echo "******************************************************" >> log/online/log_on
   echo "                        INFORMAÇÕES DO PING ">> log/online/log_on
   echo "******************************************************" >> log/online/log_on 
   echo "Hora da consulta: $hora" >> log/online/log_on
   $PING >> log/online/log_on
exit

elif ! $PING && $CONECTADO; then
   echo "******************************************************" >> log/offline/log_off
   echo "                        INFORMAÇÕES DO PING " >> log/offline/log_off
   echo "******************************************************" >> log/offline/log_off
   echo "Hora da consulta: $hora" >> log/offline/log_off
   $PING >> log/offline/log_off
   echo "AVISO:" >> log/offline/log_off

   tail -n 10 log/offline/log_off > log/offline/email
   mutt -s "Log do ping - Desafio 2" -i log/offline/email -a log/offline/log_off -a cronjob -a desafio2.sh -- $email < /dev/null
exit

else ! $PING && ! $CONECTADO;
   echo "******************************************************" >> log/offline/log_off
   echo "                        INFORMAÇÕES DO PING " >> log/offline/log_off
   echo "******************************************************" >> log/offline/log_off
   echo "Hora da consulta: $hora" >> log/offline/log_off
   $PING >> log/offline/log_off
   echo "AVISO:" >> log/offline/log_off
   echo "Email não pode ser enviado na hora da consulta, estava sem acesso à internet" >> log/offline/log_off
exit
fi
