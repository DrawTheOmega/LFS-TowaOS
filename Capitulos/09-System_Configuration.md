# Capítulo 9

## General Network Configuration

Se va a trabajar con el daemon de "systemd-networkd" para la red y "systemd-resolved" para los DNS. En caso de no usar el primero porque no se quiere tener salida a internet o se usa otro como "NetworkManager" hay que deshabilitar el daemon
    systemctl disable systemd-networkd-wait-online

Los archivos de configuración por lo general están en /etc/systemd/network o /usr/lib/systemd/network, pero los de /etc/systemd/network tienen más prioridad. Hay 3 tipos de archivos de configuración:
    .link
    .netdev
    .network

### Network Device Naming

Udev asigna nombres en base a las características de la placa física, como enp2s1. Con el comando "ip link" se puede ver el nombre que tiene la placa. Para usar un nombre default o custom hay 3 caminos:

Primero se crea un archivo .link que apunte a /dev/null para anular la udev rule:
    ln -s /dev/null /etc/systemd/network/99-default.link

Luego podemos asignar una placa por mac:
    cat > /etc/systemd/network/10-ether0.link << "EOF"
    [Match]
    # Change the MAC address as appropriate for your network device
    MACAddress=12:34:45:78:90:AB

    [Link]
    Name=ether0
    EOF

Podemos asignar una placa con ip fija:
    cat > /etc/systemd/network/10-eth-static.network << "EOF"
    [Match]
    Name=<network-device-name>

    [Network]
    Address=192.168.0.2/24
    Gateway=192.168.0.1
    DNS=192.168.0.1
    Domains=<Your Domain Name>
    EOF

O podemos asignar por DHCP:
    cat > /etc/systemd/network/10-eth-dhcp.network << "EOF"
    [Match]
    Name=<network-device-name>

    [Network]
    DHCP=ipv4

    [DHCPv4]
    UseDomains=true
    EOF

### Resolv.conf

Al igual que con systemd-networkd, si pensamos usar otro servicio de DNS que no sea resolved debemos deshabilitarlo:
    systemctl disable systemd-resolved

Con un archivo de resolv.conf estático:
    cat > /etc/resolv.conf << "EOF"
    # Begin /etc/resolv.conf

    domain <Your Domain Name>
    nameserver <IP address of your primary nameserver>
    nameserver <IP address of your secondary nameserver>

    # End /etc/resolv.conf
    EOF

El campo de "domain" puede ser omitido o reemplazado con "search .", mientras que en "nameserver" podemos poner los dns de nuestro proveedor o directamente los públicos.

### Hostname

El archivo de /etc/hostname se usa para asignarle el nombre al equipo cuando bootea. Para crearlo corremos el siguiente comando:
    echo "<lfs-towaos>" > /etc/hostname

### Hosts

Podemos crear el archivo /etc/hosts para resolver nuestro propio nombre o algún otro personalizado, el formato es el siguiente:
    IP_address myhost.example.org aliases

Es importante respetar los diferentes rangos de ip para no tener conflictos cuando se conecte con internet, el rango usado debería ser de los privados de clase C

Private Network Address Range      Normal Prefix
10.0.0.1 - 10.255.255.254           8
172.x.0.1 - 172.x.255.254           16
192.168.y.1 - 192.168.y.254         24

    cat > /etc/hosts << "EOF"
    # Begin /etc/hosts

    <192.168.0.2> <FQDN> [alias1] [alias2] ...
    ::1       ip6-localhost ip6-loopback
    ff02::1   ip6-allnodes
    ff02::2   ip6-allrouters

    # End /etc/hosts
    EOF

Habría que cambiar <192.168.0.2> y <FQDN> por los deseados.