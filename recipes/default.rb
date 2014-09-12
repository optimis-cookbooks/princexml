if node['platform_version'].to_f >= 14.04
  package_version = 9
  pkg = 'prince_9.0-5_ubuntu14.04_amd64.deb'
else
  package_version = 7
  pkg = 'prince-7.1-ubuntu904-amd64-dynamic.tar.gz'
end

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

remote_file "/tmp/#{pkg}" do
  source "http://www.princexml.com/download/#{pkg}"
  mode 0644
  action :create_if_missing
end

if node['platform_version'].to_f >= 14.04
  dpkg_package 'prince' do
    source "/tmp/#{pkg}"
    action :install
  end
end

bash 'install_princexml' do
  not_if "/usr/local/bin/prince --version | grep #{package_version}"
  user 'root'
  cwd '/tmp'
  code "tar -xvf #{package} && cd #{package.gsub('.tar.gz', '')} && ./install.sh"
end

if node[:prince] && node[:prince][:license_cookbook]
  cookbook_file '/usr/local/lib/prince/license/license.dat' do
    backup 100
    mode 0444
    cookbook node[:prince][:license_cookbook]
  end
end
