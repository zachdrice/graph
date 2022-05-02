sudo apt update
sudo apt dist-upgrade

sudo reboot

sudo apt install git build-essential cmake libusb-1.0 libopencv-dev libproj-dev

git clone https://github.com/steve-m/librtlsdr.git
cd librtlsdr
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DINSTALL_UDEV_RULES=ON ..
sudo make -j2 install

sudo cp ../rtl-sdr.rules /etc/udev/rules.d/
sudo ldconfig
echo 'blacklist dvb_usb_rtl28xxu' | sudo tee --append /etc/modprobe.d/blacklist-dvb_usb_rtl28xxu.conf

sudo reboot

rtl_test

git clone https://github.com/pietern/goestools.git
cd goestools
git submodule init
git submodule update --recursive
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ..

sudo make -j2 install 

cat <<EOF > ~/goesrecv.conf
[demodulator]
mode = "hrit"
source = "rtlsdr"

[rtlsdr]
frequency = 1694100000
sample_rate = 2400000
gain = 5
bias_tee = false

[costas]
max_deviation = 200e3

[decoder.packet_publisher]
bind = "tcp://0.0.0.0:5004"
send_buffer = 1048576

[monitor]
statsd_address = "udp4://localhost:8125"
EOF