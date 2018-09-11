#!/bin/bash
    # A simple copy script


echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "Bienvanido " $USER " estas corriendo el script" $0

echo "Intalar paquetes necesarios"
sudo apt install samba smbclient vim 


echo "Creacion de carpeta samba"
sudo mkdir -p /home/samba/{publico,invitado}


echo "Asignacion de permisos"
sudo chmod 775 /home/samba/publico/
sudo chmod 777 /home/samba/invitado/

echo "Creacion respaldo de smb.conf actual"
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak



echo "Modificacion de archivo smb seccion Invitados"

echo "[Invitados]
  comment = Todo privilegios
  path = /home/samba/invitados
  writeable = yes
  guest ok = yes
  browseable = yes" | sudo tee -a /etc/samba/smb.conf

echo "Modificacion de archivo smb seccion Publico"

echo "[Public]
   comment = Publico 
   path = /home/samba/Public
   guest ok = yes
   browseable = yes
   create mask = 0600
   read only = yes
   valid users = %U 
   writeable = yes" | sudo tee -a /etc/samba/smb.conf


echo "Modificacion de archivo smb seccion Usuario"

echo "[homes]
# Despued de logueado al servidor puedo accceder a las otras carpetas, 
# de home, pero no podre escribir nada 
  comment = Directorio de usuarios
  path = /home/%S
  valid users = %U
  create mask = 0700
  directory mask = 0700
  writeable = yes 
  force user = %U
  force group = %U " | sudo tee -a /etc/samba/smb.conf

echo "Reiniciamos el servidor"
sudo service smbd reload

sudo ifconfig 

echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GRACIAS %%%%%%%%%%%%%%%%%%%%%"

echo "Creacion de un usurio tester"

echo "sudo adduser tester"
echo "sudo smbpasswd -a tester"
