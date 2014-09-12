pkg_v7 = 'prince-7.1-ubuntu904-amd64-dynamic.tar.gz'
pkg_v9 = 'prince_9.0-5_ubuntu14.04_amd64.deb'

if node['platform_version'].to_f >= 14.04
  package 'ttf-mscorefonts-installer'
  package 'libjpeg62'

  libtiff_pkg = "libtiff4_3.9.7-2ubuntu1_amd64.deb"
  remote_file "/tmp/#{libtiff_pkg}" do
    source "http://mirrors.kernel.org/ubuntu/pool/universe/t/tiff3/#{libtiff_pkg}"
    mode 0644
    action :create_if_missing
  end

  dpkg_package 'libtiff' do
    source "/tmp/#{libtiff_pkg}"
    action :install
  end
end

if node['platform_version'].to_f >= 14.04
  remote_file "/tmp/#{pkg_v9}" do
    source "http://www.princexml.com/download/#{pkg_v9}"
    mode 0644
    action :create_if_missing
  end

  dpkg_package 'prince' do
    source "/tmp/#{pkg_v9}"
    action :install
  end
end

bash 'install_princexml' do
  not_if "/usr/local/bin/prince --version | grep 7.1"
  user 'root'
  cwd '/tmp'
  code "tar -xvf #{pkg_v7} && cd #{pkg_v7.gsub('.tar.gz', '')} && ./install.sh"
end

if node[:prince] && node[:prince][:license_cookbook]
  cookbook_file '/usr/local/lib/prince/license/license.dat' do
    backup 100
    mode 0444
    cookbook node[:prince][:license_cookbook]
  end
end
